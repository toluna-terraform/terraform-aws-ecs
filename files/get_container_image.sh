#!/bin/bash

eval "$(jq -r '@sh "XAPP_NAME=\(.app_name) XIMAGE_NAME=\(.image_name) XAWS_PROFILE=\(.aws_profile)"')"
is_local=$(cat ~/.aws/config | grep $XAWS_PROFILE || echo "false")
IMAGE_TAG="$(cut -d':' -f2 <<< $XIMAGE_NAME)"
ECR="$(cut -d'/' -f1 <<< $XIMAGE_NAME)"
if [[ $is_local != "false" ]];then
    IMAGE=$(aws ecr describe-images --repository-name "$XAPP_NAME-main" --image-ids=imageTag=$IMAGE_TAG --profile $XAWS_PROFILE || aws ecr describe-images --repository-name "$XAPP_NAME-main" --image-ids=imageTag=latest --profile $XAWS_PROFILE || echo "NULL" )
else
    IMAGE=$(aws ecr describe-images --repository-name "$XAPP_NAME-main" --image-ids=imageTag=$IMAGE_TAG || aws ecr describe-images --repository-name "$XAPP_NAME-main" --image-ids=imageTag=latest || echo "NULL" )
fi
if [[ "$IMAGE" == *"$IMAGE_TAG"* ]]; then
    jq -n --arg image "$XIMAGE_NAME" '{ "image": $image }'
elif [[ "$IMAGE" == *"latest"* ]]; then
    jq -n --arg image "$ECR/$XAPP_NAME-main:latest" '{ "image": $image }'
else
    jq -n --arg image "$ECR/soa-base" '{ "image": $image }'
fi
