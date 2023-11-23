#!/bin/bash

# -----------------------------------------------------------------------------
# Info:
#   author:    Santhosh veer
#   website:   https://santhoshveer.com
#   file:      gotify.sh
#   created:   22.01.2020
#   revision:  22.02.2020
#   version:   0.1
# -----------------------------------------------------------------------------
# Requirements:
#   curl, Gotify API
#
# Description:
#   Gotify - Send Push Notification to the Gotify Server.
#
# -----------------------------------------------------------------------------

# Version Info
VERSION=0.1

# Gotify API URL - Replace it with your GOTIFY API URL
API="http://localhost:9000/message?token=XXXXXXXXXXXXXXX"

# Add Notification priority - https://github.com/gotify/android/issues/18#issuecomment-437403888
priority="5"

# HTTP Status Code
HTTP200="200"
HTTP400="400"
HTTP401="401"
HTTP403="403"
HTTP404="404"

# File name
SCRIPTNAME=$(basename "$0")

# Send Push Notification
send_push(){

echo -e "\\n"
echo -e "== Enter a Push title and Message =="
echo -e "\\n"

echo -n "Enter a Push title: "
read -r pushtitle

echo -n "Enter a Push Message: "
read -r pushmessage

echo -e "\\n"

# If no Inputs you will see this Alert message
  if [[ ! $pushtitle ]]; then
    echo -e "Error: Push title is Missing \\n"
    exit 1
fi

  if [[ ! $pushmessage ]]; then
    echo -e "Error: Push Message is Missing \\n"
    exit 1
fi

# Curl request
GETSTATUS(){
  curl --silent --output /dev/null -w "%{http_code}" -X POST \
  "$API" \
  -F "title=$pushtitle" -F "message=$pushmessage" -F "priority=$priority"
 }

 STATUSCHECK=$(GETSTATUS)

 if [ "$STATUSCHECK" == "$HTTP200" ]; then
    echo "Data Posted Successfully..."
 elif [ "$STATUSCHECK" == "$HTTP400" ]; then
    echo "Bad Request"
 elif [ "$STATUSCHECK" == "$HTTP401" ]; then
    echo "Unauthorized Error - Invalid Token"
 elif [ "$STATUSCHECK" == "$HTTP403" ]; then
    echo "Forbidden"
 elif [ "$STATUSCHECK" == "$HTTP404" ]; then
    echo "API URL Not Found"
fi

echo -e "\\n"

}

# Help Message
help(){
  echo -e "\\n"
  echo -e  "$SCRIPTNAME [options]
        
           Example:
           gotify.sh -s

          Options:
          -s   Send Push Notificaiton
          -h   Display Help Message
          -v   Check CLI Version
          \\n"
}

# No input params triggers this error
check_for_empty_input(){
  if [ $# -eq 0 ];
  then
      echo -e "\\n"
      echo -e "\\033[1;31m Error:  No input \\033[0m \\n"
      help
      exit 1
    fi
}

# Check for required packages
check_requirements(){
  local requirements=("$@")
  for app in "${requirements[@]}"; do
    type "$app" >/dev/null 2>&1 || \
      { echo >&2 "$app is required but it's not installed. Aborting."; exit 1; }
  done
}

# Main Functions
main(){
  check_for_empty_input "$@"
  check_requirements curl

  while getopts ':svh' flag; do
  case "$flag" in 
s)
  send_push
  exit 0
  ;;
v)
  echo -e "Version $VERSION"
  exit 0
  ;;
h) 
help
exit 0
;;
  ?)
  echo "script usage: $SCRIPTNAME [-s] [-v] [-h]" >&2
  exit 1
  ;;
*)

 esac
done
  shift $((OPTIND-1))
}

main "$@"

exit 0
