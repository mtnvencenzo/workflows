#!/bin/bash

set -euo pipefail

REGISTRY_NAME="${1:-${ACR_REGISTRY_NAME:-}}"
RETAIN_COUNT="${2:-3}"
REPOSITORY="${3:-}"
DRY_RUN="${DRY_RUN:-false}"
DELETE_UNTAGGED="${DELETE_UNTAGGED:-true}"
ACR_USERNAME="${ACR_USERNAME:-${ACR_USER_NAME:-}}"
ACR_PASSWORD="${ACR_PASSWORD:-${ACR_ACCESS_KEY:-}}"

if [ -z "$REGISTRY_NAME" ]; then
  echo "Error: REGISTRY_NAME (first argument) is required." >&2
  exit 1
fi

if ! [[ "$RETAIN_COUNT" =~ ^[0-9]+$ ]] || [ "$RETAIN_COUNT" -lt 1 ]; then
  echo "Error: RETAIN_COUNT (second argument) must be a positive integer." >&2
  exit 1
fi

if ! command -v az >/dev/null 2>&1; then
  echo "Error: Azure CLI (az) is required." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required." >&2
  exit 1
fi

ACR_AUTH_ARGS=()
if [ -z "$ACR_USERNAME" ] || [ -z "$ACR_PASSWORD" ]; then
  echo "Error: ACR username and password are required. Provide ACR_USERNAME/ACR_PASSWORD or set ACR_USER_NAME/ACR_ACCESS_KEY." >&2
  exit 1
fi

ACR_AUTH_ARGS=(--username "$ACR_USERNAME" --password "$ACR_PASSWORD")

echo "Listing repositories in ACR '$REGISTRY_NAME'"

REPOSITORIES=$(az acr repository list \
  --name "$REGISTRY_NAME" \
  "${ACR_AUTH_ARGS[@]}" \
  --output tsv)

if [ -z "$REPOSITORIES" ]; then
  echo "No repositories found in ACR '$REGISTRY_NAME'."
  exit 0
fi

echo "$REPOSITORIES" | while IFS= read -r REPOSITORY_NAME; do
  [ -z "$REPOSITORY_NAME" ] && continue

  if [ -n "$REPOSITORY" ] && [ "$REPOSITORY_NAME" != "$REPOSITORY" ]; then
    continue
  fi

  echo
  echo "Processing repository: $REPOSITORY_NAME"

  MANIFEST_ROWS=$(az acr manifest list-metadata \
    --registry "$REGISTRY_NAME" \
    --name "$REPOSITORY_NAME" \
    "${ACR_AUTH_ARGS[@]}" \
    --orderby time_desc \
    --output json)

  MANIFEST_COUNT=$(echo "$MANIFEST_ROWS" | jq 'length')
  TAGGED_MANIFEST_COUNT=$(echo "$MANIFEST_ROWS" | jq '[.[] | select((.tags // []) | length > 0)] | length')
  UNTAGGED_MANIFEST_COUNT=$(echo "$MANIFEST_ROWS" | jq '[.[] | select((.tags // []) | length == 0)] | length')

  echo "  Found $MANIFEST_COUNT digest(s): $TAGGED_MANIFEST_COUNT tagged, $UNTAGGED_MANIFEST_COUNT untagged."

  TAGGED_DIGESTS_TO_DELETE=$(echo "$MANIFEST_ROWS" | jq -c --argjson retain "$RETAIN_COUNT" '
    map(select((.tags // []) | length > 0))
    | sort_by(.lastUpdateTime // .createdTime // "")
    | .[0:((length - $retain) | if . < 0 then 0 else . end)]
    | map({
        digest: .digest,
        lastUpdateTime: (.lastUpdateTime // .createdTime // "unknown"),
        tags: (.tags // []),
        reason: "old-tagged"
      })
    | .[]
  ')

  UNTAGGED_DIGESTS_TO_DELETE=""
  if [ "$DELETE_UNTAGGED" = "true" ]; then
    UNTAGGED_DIGESTS_TO_DELETE=$(echo "$MANIFEST_ROWS" | jq -c '
      map(select((.tags // []) | length == 0))
      | sort_by(.lastUpdateTime // .createdTime // "")
      | map({
          digest: .digest,
          lastUpdateTime: (.lastUpdateTime // .createdTime // "unknown"),
          tags: (.tags // []),
          reason: "untagged"
        })
      | .[]
    ')
  fi

  DIGESTS_TO_DELETE=$(printf '%s\n%s\n' "$TAGGED_DIGESTS_TO_DELETE" "$UNTAGGED_DIGESTS_TO_DELETE" | sed '/^$/d')

  if [ -z "$DIGESTS_TO_DELETE" ]; then
    echo "  No digests selected for deletion."
    continue
  fi

  echo "$DIGESTS_TO_DELETE" | while IFS= read -r MANIFEST; do
    [ -z "$MANIFEST" ] && continue

    DIGEST=$(echo "$MANIFEST" | jq -r '.digest')
    LAST_UPDATED=$(echo "$MANIFEST" | jq -r '.lastUpdateTime')
    TAGS=$(echo "$MANIFEST" | jq -r 'if (.tags | length) == 0 then "<untagged>" else (.tags | join(", ")) end')
    REASON=$(echo "$MANIFEST" | jq -r '.reason')
    IMAGE_REF="$REPOSITORY_NAME@$DIGEST"

    if [ "$DRY_RUN" = "true" ]; then
      echo "  [dry-run] Would delete $IMAGE_REF"
      echo "            Reason: $REASON"
      echo "            Last updated: $LAST_UPDATED"
      echo "            Tags: $TAGS"
      continue
    fi

    echo "  Deleting $IMAGE_REF"
    echo "            Reason: $REASON"
    echo "            Last updated: $LAST_UPDATED"
    echo "            Tags: $TAGS"
    az acr repository delete \
      --name "$REGISTRY_NAME" \
      --image "$IMAGE_REF" \
      "${ACR_AUTH_ARGS[@]}" \
      --yes \
      --output none
  done
done