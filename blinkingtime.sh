#!/bin/bash

while true; do
  read -r hour minute < <(date +"%H %M")
  printf "\r$hour:$minute"
  sleep 1
  printf "\r$hour $minute"
  sleep 1
done
