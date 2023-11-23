#!/bin/bash
 
IP="1.1.1.1"
COUNT=1
 
if ping -c $COUNT $IP > /dev/null 2>&1; then
  echo "Ping to $IP was successful."
 termux-notification --title 'Network Status'  --content UP
else
  echo "Ping to $IP failed."
 termux-notification --title 'Network Status'  --content Down
fi
