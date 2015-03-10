#!/bin/sh
if test -z $IMAGE; then
  IMAGE=coreos-alpha-472-0-0-v20141017
fi

if test -z $CLOUD_CONFIG; then
  CLOUD_CONFIG=control.yaml
fi

if test -z $PROJECT; then
  PROJECT_STR=
else
  PROJECT_STR="--project $PROJECT"
fi

if test -z $IMAGE_PROJECT; then
  IMAGE_PROJECT_STR=
else
  IMAGE_PROJECT_STR="--image-project $IMAGE_PROJECT"
fi

if test -z $DISK_SIZE; then
  DISK_SIZE=200
fi

if test $1 == "up"; then
  gcloud compute instances create kcontrol \
    $PROJECT_STR \
    $IMAGE_PROJECT_STR \
    --image $IMAGE \
    --boot-disk-size ${DISK_SIZE}GB \
    --machine-type $MECH \
    --can-ip-forward \
    --scopes compute-rw \
    --metadata-from-file user-data=$CLOUD_CONFIG \
    --zone $ZONE
elif test $1 == "down"; then
  gcloud compute instances delete kcontrol \
    --project $PROJECT
else
  echo "Usage: [IMAGE=X1 [IMAGE_PROJECT=X2]] [CLOUD_CONFIG=X3] [PROJECT=X4] [DISK_SIZE=X5] $0 (up|down)"
fi
