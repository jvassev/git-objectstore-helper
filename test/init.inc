export AWS_CONFIG_FILE="$(realpath ../local-minio-profile.conf)"
export GIT_OBJECTSTORE_ENDPOINT="http://localhost:9000"
export GIT_OBJECTSTORE_LOG="1"
export AWS_CLI_ARGS="--endpoint $GIT_OBJECTSTORE_ENDPOINT"
export PATH="$(realpath ..):${PATH}"

random-name() {
    local len="${1:-6}"
    cat /dev/urandom | tr -dc 'ybndrfg8ejkmcpqxot1uwisza345h769' | fold -w "$len" | head -n 1
    return 0
}

BUCKET="$(random-name)"
WORKDIR="/tmp/tmp-objstore-${BUCKET}"
mkdir -p "${WORKDIR}"

echo "Workdir is ${WORKDIR}"
echo "Bucket is ${BUCKET}"
echo "Script is $(which git-remote-s3)"
cd "${WORKDIR}"
echo "############ setup done"

set -o errexit
#set -o pipefail
set -o nounset
