#!/bin/sh
function help() {
  echo "Usage: DNS_SERVER_IP=? DNS_DOMAIN=? [DNS_REPLICAS=1] [K8S_SERVER=?] [K8S_PORT=?] $0 (up|down)"
}

ASSETS=(service rc)
function up() {
  for t in "${ASSETS[@]}"
  do
    #echo "k8s/$t/skydns.yaml > /tmp/skydns-$t.yaml"
    sed -e "s:DNS-SERVER-IP:$DNS_SERVER_IP:" \
        -e "s:DNS-DOMAIN:$DNS_DOMAIN:" \
        -e "s:DNS-REPLICAS:$DNS_REPLICAS:" \
      k8s/$t/skydns.yaml > /tmp/skydns-$t.yaml
    kubectl create -f /tmp/skydns-$t.yaml --server="$K8S_SERVER:$K8S_PORT"
  done
}

function down() {
  for t in "${ASSETS[@]}"; do
    sed -e "s:DNS-SERVER-IP:$DNS_SERVER_IP:" \
        -e "s:DNS-DOMAIN:$DNS_DOMAIN:" \
        -e "s:DNS-REPLICAS:$DNS_REPLICAS:" \
      k8s/$t/skydns.yaml > /tmp/skydns-$t.yaml
    kubectl delete -f /tmp/sky-dns-$t.yaml --server=\"$K8S_SERVER:$K8S_PORT\"
  done
}

if test $1 == "help"; then
  help
  exit
fi

if test -z $DNS_DOMAIN; then
  DNS_DOMAN=
  echo "Specify a DNS_DOMAIN"
  exit
fi

if test -z $DNS_SERVER_IP; then
  DNS_SERVER_IP=10.0.0.10
fi

if test -z $DNS_REPLICAS; then
  DNS_REPLICAS=1
fi

if test $1 == "up"; then
  up
elif test $1 == "down"; then
  down
else
  help
fi
