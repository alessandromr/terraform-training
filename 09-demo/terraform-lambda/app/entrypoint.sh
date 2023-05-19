#!/bin/bash
set -eo pipefail

REQUEST_ID=$(curl -X GET -sI "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next" \
  | awk -v FS=": " -v RS="\r\n" '/Lambda-Runtime-Aws-Request-Id/{print $2}')
export REQUEST_ID

function error {
  curl -s -d "ERROR" "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/${REQUEST_ID}/error"
}

trap error ERR

cp main.tf /tmp/main.tf
cp ec2.tf /tmp/ec2.tf
cd /tmp
TF_DATA_DIR=/tmp terraform init -input=false
TF_DATA_DIR=/tmp terraform plan -input=false

curl -s -d "SUCCESS" "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/${REQUEST_ID}/response"