```shell

BEFORE_DATE=2026-04-20T00:00:00Z

./delete-old-workflow-runs.sh \
    mtnvencenzo \
    $GH_REPOS_PAT_TOKEN_ALL \
    $BEFORE_DATE
```

---

### Register as a cron job (run on the 1st of every month)
Add the following line to your crontab (edit with `crontab -e`):

``` shell
# This will run the script every day at 7:00 PM, defaulting to delete workflow runs older than 2 months.

0 19 * * * $HOME/Github/Workflows/delete-old-workflow-runs.sh mtnvencenzo $GH_REPOS_PAT_TOKEN_ALL
```

