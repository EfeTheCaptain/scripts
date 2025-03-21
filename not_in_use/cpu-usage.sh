#!/bin/bash

cache_file="/tmp/cpu_usage"

while true; do
  {
    readarray -t prev < <(grep ^cpu[0-9] /proc/stat)
    sleep 1
    readarray -t curr < <(grep ^cpu[0-9] /proc/stat)
  }

  max_usage=-1
  highest_core=""

  for i in "${!prev[@]}"; do
    prev_vals=(${prev[i]})
    curr_vals=(${curr[i]})

    idle_prev=${prev_vals[4]}
    idle_curr=${curr_vals[4]}

    total_prev=0
    total_curr=0
    for j in "${prev_vals[@]:1}"; do total_prev=$((total_prev + j)); done
    for j in "${curr_vals[@]:1}"; do total_curr=$((total_curr + j)); done

    total_diff=$((total_curr - total_prev))
    idle_diff=$((idle_curr - idle_prev))

    if (( total_diff > 0 )); then
      usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))
    else
      usage=0
    fi

    if (( usage > max_usage )); then
      max_usage=$usage
      highest_core=${prev_vals[0]}
    fi
  done

  # Cache the result
  echo "$max_usage%" > "$cache_file"
  sleep 1
  echo "$cache_file"
done
