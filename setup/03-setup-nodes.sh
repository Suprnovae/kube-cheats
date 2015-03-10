#!/bin/sh
if test -z $NODES; then
  NODES="mercury venus earth" # mars jupiter saturn uranus neptune pluto"
fi

if test -z $IMAGE; then
  IMAGE=coreos
fi

if test -z $CLOUD_CONFIG; then
  CLOUD_CONFIG=node.yaml
fi

if test -z $CONTROL_IP; then
  CONTROL_IP=
  echo "Specify a CONTROL_IP (private ip) for the Kubernetes control mech"
  exit
fi

if test -z $MECH; then
  MECH=g1-small
fi

if test -z $PROJECT; then
  PROJECT_STR=
  echo "Specify a PROJECT"
  exit
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
  sed -e "s:CONTROL-NODE-INTERNAL-IP:$CONTROL_IP:" $CLOUD_CONFIG > /tmp/$(basename $CLOUD_CONFIG)
  gcloud compute instances create $NODES \
    $PROJECT_STR \
    $IMAGE_PROJECT_STR \
    --image $IMAGE \
    --boot-disk-size ${DISK_SIZE}GB \
    --machine-type $MECH \
    --can-ip-forward \
    --scopes compute-rw \
    --metadata-from-file user-data=/tmp/$(basename $CLOUD_CONFIG) \
    --zone $ZONE
elif test $1 == "down"; then
  gcloud compute instances delete $NODES \
    --project $PROJECT \
    --zone $ZONE \
    --delete-disks all
else
  echo "Usage: CONTROL_IP=? [NODES=?] [IMAGE=? [IMAGE_PROJECT=?]] [CLOUD_CONFIG=?] [PROJECT=?] [DISK_SIZE=?] $0 (up|down)"
  #echo "Usage: [LOCAL_PORT=?] [USER=?] [REMOTE_HOST=?] [REMOTE_PORT=?] [TUNNEL_HOST=?] $0 (up|down)"
fi
