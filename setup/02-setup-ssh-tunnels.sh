#!/bin/sh
if test -z $REMOTE_PORT; then
  REMOTE_PORT=4001
fi

if test -z $REMOTE_HOST; then
  REMOTE_HOST=127.0.0.1
fi

if test -z $LOCAL_PORT; then
  LOCAL_PORT=4001
fi

if test -z $TUNNEL_HOST; then
  TUNNEL_HOST=$REMOTE_HOST
fi

if test -z $LOCAL_HOST; then
  LOCAL_HOST_STR=
else
  LOCAL_HOST_STR=$LOCAL_HOST:
fi

if test $1 == "up"; then
  ssh -i ~/.ssh/google_compute_engine -f -nNT -L $LOCAL_HOST_STR$LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT $USER@$TUNNEL_HOST
elif test $1 == "down"; then
  kill -3 $(ps aux | grep -E 'ssh.*google' | grep -F $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT | grep -F $USER@$TUNNEL_HOST | grep -Fv 'grep' | awk '{print $2}')
else
  echo "Usage: [LOCAL_PORT=?] [USER=?] [REMOTE_HOST=?] [REMOTE_PORT=?] [TUNNEL_HOST=?] $0 (up|down)"
fi
