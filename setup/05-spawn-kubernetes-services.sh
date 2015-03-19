#!/bin/sh
function help() {
  echo "Usage: CONTROL_IP=? $0 (up|down)"
}

KUBE_SERVICES=(kube-kubelet kube-proxy kube-apiserver kube-controller-manager kube-scheduler)
function up() {
  for f in "${KUBE_SERVICES[@]}"
  do
    sed -e "s:CONTROL-NODE-INTERNAL-IP:$CONTROL_IP:" units/$f.service > /tmp/$(basename $f.service)
    fleetctl start /tmp/$(basename $f.service)
    echo "started $f.service"
  done
}

function down() {
  for f in "${KUBE_SERVICES[@]}"; do
    fleetctl stop $(basename $f.service)
  done
}

if test $1 == "help"; then
  help
  exit
fi

if test -z $CONTROL_IP; then
  CONTROL_IP=
  echo "Specify a CONTROL_IP (private ip) for the Kubernetes control mech"
  exit
fi

if test $1 == "up"; then
  up
elif test $1 == "down"; then
  down
else
  help;
fi

