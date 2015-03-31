function load_vars() {
  if test -f "$CONFIG_FILE"; then
    source $CONFIG_FILE
  else
    echo "no config file"
  fi
}

function help() {
  echo "[CONFIG_FILE=?] $0 CMD"
  echo "  CMD = [mon|tunnel|flannel]"
}

function tunnel() {
  TUNNEL_SETUP_CMD=$(dirname $0)/02-setup-ssh-tunnels.sh
  if test "$1" == "up"; then
    REMOTE_HOST=$INTERNAL_GATEWAY TUNNEL_HOST=$EXTERNAL_GATEWAY $TUNNEL_SETUP_CMD up # fleetctl tunnel
    REMOTE_HOST=$K8S_IP REMOTE_PORT=$K8S_PORT LOCAL_PORT=$LOCAL_K8S_PORT TUNNEL_HOST=$EXTERNAL_GATEWAY $TUNNEL_SETUP_CMD up # kubecfg tunnel
  elif test "$1" == "down"; then
    REMOTE_HOST=$INTERNAL_GATEWAY TUNNEL_HOST=$EXTERNAL_GATEWAY $TUNNEL_SETUP_CMD down # fleetctl tunnel
    REMOTE_HOST=$K8S_IP REMOTE_PORT=$K8S_PORT LOCAL_PORT=$LOCAL_K8S_PORT TUNNEL_HOST=$EXTERNAL_GATEWAY $TUNNEL_SETUP_CMD down # kubecfg tunnel
  else
    echo "up or down?"
  fi
}

function flannel() {
  TUNNEL_SETUP_CMD=$(dirname $0)/02-setup-ssh-tunnels.sh
  if test "$1" == "up"; then
    CONTROL_HOST=$EXTERNAL_GATEWAY MASK=10.240.0.0/16 ./03-config-flannel.sh up
  elif test "$1" == "down"; then
    CONTROL_HOST=$EXTERNAL_GATEWAY MASK=10.240.0.0/16 ./03-config-flannel.sh down
  else
    echo "up or down?"
  fi
}

function mon() {
  kubectl get pods,rc,services --server="127.0.0.1:$LOCAL_K8S_PORT"
}

load_vars
if test "$1" == "tunnel"; then
  tunnel $2
elif test "$1" == "flannel"; then
  flannel $2
elif test "$1" == "mon"; then
  mon
else
  help
fi
