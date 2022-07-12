#!/bin/bash
set -v #echo on
set -e #fail on error
# mkdir -p /root/.ssh
mkdir -p ~/.ssh/
echo "$GITLAB_SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
ssh-keyscan -H gitlab.dev.spotdraft.com > ~/.ssh/known_hosts
chmod 600 ~/.ssh/id_rsa
apk add --no-cache git && apk add yq
TAG_NAME=qa_20220706_RC7
yq --version
git config --global user.name "siva"
git config --global user.email "siva@spotdraft.com"
git clone --single-branch --branch master git@gitlab.dev.spotdraft.com:sd/argo-manifests.git
cd argo-manifests/spotdraft
if [ $DEPLOY_ENV == "QA" ]; then
    echo "updating QA image version"
    yq eval ".django-app.image.tag = \"$TAG_NAME\"" -i values-qa.yaml
    yq eval ".django-app.image.tag = \"$TAG_NAME\"" -i values-qa-india.yaml
    yq eval ".django-app.image.tag = \"$TAG_NAME\"" -i values-qa-usa.yaml
fi
git checkout -b update-django-rest-api-qa_20220706_RC7
git add .
git commit -m "update image version for django-rest-api QA to qa_20220706_RC7"
git push origin update-django-rest-api-qa_20220706_RC7
TARGET_BRANCH=master
SOURCE_BRANCH=update-django-rest-api-qa_20220706_RC7
CI_PROJECT_ID=156
PRIVATE_TOKEN=$GITLAB_PRIVATE_TOKEN
GITLAB_HOST=https://gitlab.dev.spotdraft.com

#JSON body for gitlab create MR api POST request
BODY="{
\"id\": \"${CI_PROJECT_ID}\",
\"source_branch\": \"${SOURCE_BRANCH}\",
\"target_branch\": \"${TARGET_BRANCH}\",
\"remove_source_branch\": true,
\"squash\": true,
\"reviewer_ids\": [125],
\"title\": \"merge request for: qa_20220706_RC7 on django-rest-api for $DEPLOY_ENV\"
}";

# reviewer id 125 is sudarsh gitlab user id

LISTMR=`curl --silent "${GITLAB_HOST}/api/v4/projects/${CI_PROJECT_ID}/merge_requests?state=opened" --header "PRIVATE-TOKEN:${PRIVATE_TOKEN}"`;

# check if any MR is already there for this source branch
COUNTBRANCHES=`echo ${LISTMR} | grep -o "\"source_branch\":\"${SOURCE_BRANCH}\"" | wc -l`;
# No MR found, let's create a new one
if [ ${COUNTBRANCHES} -eq "0" ]; then
    echo "creating MR"
    curl -X POST "${GITLAB_HOST}/api/v4/projects/${CI_PROJECT_ID}/merge_requests" \
        --header "PRIVATE-TOKEN:${PRIVATE_TOKEN}" \
        --header "Content-Type: application/json" \
        --data "${BODY}";

    echo "Opened a new merge request and assigned to sudarsh";
    exit;
fi