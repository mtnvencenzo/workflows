#!/bin/bash



OWNER="$1"
GITHUB_TOKEN="$2"
DATE="$3"

# Error if OWNER or GITHUB_TOKEN is not supplied
if [ -z "$OWNER" ]; then
  echo "Error: OWNER (first argument) is required." >&2
  exit 1
fi
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN (second argument) is required." >&2
  exit 1
fi

# If DATE is not supplied, set to 2 months ago in ISO format
if [ -z "$DATE" ]; then
  DATE=$(date -u -d '2 months ago' +'%Y-%m-%dT%H:%M:%SZ')
  echo "No date supplied. Using date 2 months ago: $DATE"
else
  # Validate DATE
  if ! date -d "$DATE" >/dev/null 2>&1; then
    echo "Error: Provided date '$DATE' is not a valid date." >&2
    exit 1
  fi
fi

echo "Deleting all workflow runs (including orphaned) for all repos owned by $OWNER created before $DATE"

# Get all repositories accessible by the token (public, private, orgs; first 100, can be paginated if needed)
REPOS=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/user/repos?per_page=100" | jq -r '.[] | [.owner.login, .name] | @tsv')

echo "$REPOS" | while IFS=$'\t' read -r REPO_OWNER REPO_NAME; do
  if [[ "$REPO_OWNER" == "$OWNER" ]]; then
    echo "\nProcessing repository: $REPO_OWNER/$REPO_NAME"
    PAGE=1
    while :; do
      RESPONSE=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs?per_page=100&page=$PAGE")
      RUNS=$(echo "$RESPONSE" | jq -c '.workflow_runs[]?')
      [ -z "$RUNS" ] && break

      echo "$RUNS" | while read -r RUN; do
        RUN_ID=$(echo "$RUN" | jq -r '.id')
        CREATED_AT=$(echo "$RUN" | jq -r '.created_at')
        WORKFLOW_NAME=$(echo "$RUN" | jq -r '.name')
        if [[ "$CREATED_AT" < "$DATE" ]]; then
          echo "  Deleting run $RUN_ID created at $CREATED_AT (workflow: $WORKFLOW_NAME)"
          curl -s -X DELETE -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs/$RUN_ID"
        fi
      done

      ((PAGE++))
    done
  fi
done