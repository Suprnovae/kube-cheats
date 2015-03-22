#!/bin/sh
function help() {
  echo "Usage: [IMAGE=? [IMAGE_PROJECT=?]] [CLOUD_CONFIG=?] [PROJECT=?] [DISK_SIZE=?] $0 (up|down)"
}

function up() {
  gcloud compute instances create $NAME \
    $PROJECT_STR \
    $TAGS_STR \
    $IMAGE_PROJECT_STR \
    --image $IMAGE \
    --boot-disk-size ${DISK_SIZE}GB \
    --machine-type $MECH \
    --can-ip-forward \
    --scopes compute-rw \
    --metadata-from-file user-data=$CLOUD_CONFIG \
    --zone $ZONE \
    --tags control $TAGS
}

function down() {
  gcloud compute instances delete $NAME \
    --project $PROJECT
}

if test -z $IMAGE; then
  IMAGE=coreos
fi

if test -z $CLOUD_CONFIG; then
  CLOUD_CONFIG=cloud-configs/control.yaml
fi

if test -z $MECH; then
  MECH=f1-micro
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

if test -z "$NAME"; then
  NAME="kcontrol"
fi

if test $1 == "up"; then
  up
elif test $1 == "down"; then
  down
else
  help
fi
