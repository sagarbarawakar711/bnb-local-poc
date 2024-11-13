#! /usr/bin/env bash
# Reusing shell which is set by defaul.
# 'sh' sometimes gives issues, especially if it is linked to `dash`
# so trying without this first line: #!/usr/bin/env sh
# Another option is to explicitly use !/usr/bin/env bash

set -o nounset -o errexit
# Debian's (and probably all derivatibes, such as Ubuntu) default shell (dash) doesn't support pipefail
if set -o | grep pipefail>/dev/null; then
  set -o pipefail
fi
case "$(uname -s)" in
    Darwin*)  export SCRIPTDIR="$( cd "$( dirname "${0}" )" && pwd -P)";;
    *)        export SCRIPTDIR="$(dirname $(readlink -f "$0"))"
esac
CWD=$(pwd -P)

if [ "${environment}" == "prod" ]; then
  ACCOUNT_TYPE="prod"
else
  ACCOUNT_TYPE="nonprod"
fi

load_var_file() {
  local filename="${1}"
  if [ ! -f "${filename}" ]; then return; fi
  echo "Loading common variables from ${filename}, unless they are already defined"
  for VAR in $(grep -v -e '^#' "${filename}"); do
    local VAR_NAME="${VAR%%=*}"
    if printenv | grep -e "^${VAR_NAME}=" >/dev/null 2>&1; then
      echo " - Skip $(env | grep -e "^${VAR_NAME}=") is already defined"
    else
      echo " - Using ${VAR}"
      export ${VAR}
    fi
  done
}

# For creating expandable groups in logs, if CI supports it.
# See https://docs.github.com/en/actions/reference/workflow-commands-for-github-actions#grouping-log-lines
[ -n "${LOG_GROUP_START-}" ] || export LOG_GROUP_START="::group::"
[ -n "${LOG_GROUP_END-}" ] || export LOG_GROUP_END="::endgroup::"

# echo "${LOG_GROUP_START}Loading variables"
# Applying environment variables recursively from the specified workdir ${EXEC_DIR_ON_TF} up to the current working directory
cd "${EXEC_DIR_ON_TF}"
while true; do
  load_var_file "$(pwd -P)/.env.local.${ACCOUNT_TYPE}"
  load_var_file "$(pwd -P)/.env.local"
  load_var_file "$(pwd -P)/.env.${ACCOUNT_TYPE}"
  load_var_file "$(pwd -P)/.env"
  if [ "${CWD}" == "$(pwd -P)" ]; then break; fi
  cd ..
done

export TF_IMAGE="hashicorp/terraform:${TF_VERSION}"

set | grep TF_VAR || echo "No TF_VAR defined"


# http://artifactory.mheducation.com/artifactory/webapp/#/artifacts/browse/simple/Builds/docker-local/avalon_sc/terraform-0.12.29-aws-1.16.300/master-20201112-1377828

# Re-exporting environment value as TF_WORKSPACE built-in variable for automation
[ -n "${TF_WORKSPACE-}" ] || export TF_WORKSPACE="${environment}"

if [ "${environment}" == "prod" ];then
  AWS_ACCOUNT="${AWS_ACCOUNT_PROD}"
  export TF_VAR_NR_ACCOUNT_ID=${PROD_NR_ACCOUNT_ID}
  export TF_VAR_NR_API_KEY=${NR_API_KEY_PROD-}
  export TF_VAR_aws_account=${AWS_ACCOUNT_PROD}
else
  AWS_ACCOUNT="${AWS_ACCOUNT_NONPROD}"
  export TF_VAR_NR_ACCOUNT_ID=${NON_PROD_NR_ACCOUNT_ID}
  export TF_VAR_NR_API_KEY=${NR_API_KEY_NONPROD-}
  export TF_VAR_aws_account=${AWS_ACCOUNT_NONPROD}
fi

export TF_STATE_BUCKET_NAME="${AWS_ACCOUNT}-${TF_STATE_BUCKET_NAME_PREFIX}-${ACCOUNT_TYPE}"
# State key should be the same across environments, unfortunately.
# State file for each environment on SDLC will be put in a different folder due to usage of Workspaces feature of Terraform.
export TF_STATE_BACKEND_KEY="${TF_STATE_BACKEND_KEY_PREFIX}-${EXEC_DIR_ON_TF}.state.json"

# A folder which will be mounted inside terraform image to work with
export WORKDIR_ON_TF=${SCRIPTDIR}/${WORKDIR_ON_TF-}

export TF_VAR_application=${TF_VAR_application}
export TF_VAR_platform=${TF_VAR_platform}

source ${SCRIPTDIR}/terraform-runner.sh