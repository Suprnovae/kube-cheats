function help() {
  echo "Usage: MASK=? [CONTROL_HOST=?] [PROJECT=?] [ZONE=?] $0 (up|down)"
}
function up() {
  FLANNEL_CONF="{\"Network\":\"$MASK\", \"Backend\":{\"Type\": \"alloc\"}}"
  ssh $USER@$CONTROL_HOST etcdctl --debug --no-sync set /coreos.com/network/config \'$FLANNEL_CONF\'
}

function down() {
  ssh $USER@$CONTROL_HOST etcdctl rm /coreos.com/network/config
}

if test $1 == "up"; then
  up
elif test $1 == "down"; then
  down
else
  help;
fi
