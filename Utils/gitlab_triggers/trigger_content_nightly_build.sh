#!/usr/bin/env bash
# This script triggers a nightly job in gitlab-CI.

# For this script to work you will need to use a trigger token (see here for more about that: https://code.pan.run/help/ci/triggers/README#trigger-token)

# This script takes the gitlab-ci trigger token as first parameter and the branch name as an optional second parameter (the default is the current branch).

# Ways to run this script are:
# 1. Utils/gitlab_triggers/trigger_content_nightly_build.sh <trigger-token> <branch-name>
# 2. Utils/gitlab_triggers/trigger_content_nightly_build.sh <trigger-token>
if [[ "$#" -lt 1 ]]; then
  echo "Usage: $0 <trigger-token> <branch-name>[current-branch as default]"
  echo "See here to learn more about trigger tokens https://code.pan.run/help/ci/triggers/README#trigger-token"
  exit 1
fi
_gitlab_token=$1

[ -n "$2" ] && _branch="$2" || _branch="$(git branch  --show-current)"

source Utils/gitlab_triggers/trigger_build_url.sh

curl "$BUILD_TRIGGER_URL" -F "ref=$_branch" -F "token=$_gitlab_token" -F "variables[NIGHTLY]=true" -F "variables[IFRA_ENV_TYPE]=Nightly" | jq
