#!/bin/bash
ENVIRONMENT=$1
PROJECT_NAME=$2
TEMPLATE_FILE_PATH=""
BIN_PROFILE='default'
REGION='ap-northeast-1'

CFN_STACK_NAME=${ENVIRONMENT}-${PROJECT_NAME}

AWS_COMMAND='aws --profile '${BIN_PROFILE}' --region '${REGION}

${AWS_COMMAND} cloudformation deploy \
--stack-name ${CFN_STACK_NAME} \
--template-file ${TEMPLATE_FILE_PATH} \
--region ${REGION} \
--parameter-overrides ProjectName=${PROJECT_NAME} Environment=${ENVIRONMENT}

Exports=$(${AWS_COMMAND} cloudformation list-exports --output json)
_TARGET=${ENVIRONMENT}-${PROJECT_NAME}-VpcId
VPCID=$(echo ${Exports} | jq -r '.Exports[] | select(.Name == "'${_TARGET}'") | .Value')

echo ${VPCID}

${AWS_COMMAND} cloudformation delete-stack --stack-name ${CFN_STACK_NAME}