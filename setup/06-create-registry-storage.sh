#!/bin/sh
function help() {
  echo "Usage: NAME=? [LOCATION=?] [PROJECT=?] $0 (up|down)"
}

function up() {
  gsutil mb -c DRA -l $LOCATION $PROJECT_STR gs://$NAME
}

function down() {
  gsutil rb gs://$(NAME)
}

if test $1 == "help"; then
  help
  exit
fi

if test -z $PROJECT; then
  PROJECT_STR=
  echo "Specify a PROJECT"
  exit
else
  PROJECT_STR="-p $PROJECT"
fi

if test $1 == "up"; then
  up
elif test $1 == "down"; then
  down
else
  help;
fi
