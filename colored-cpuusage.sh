#!/bin/bash

{
  readarray -t prev < <(grep ^cpu[0-9] /proc/stat)
  sleep 1
  readarray -t curr < <(grep ^cpu[0-9] /proc/stat)
}

max_usage=-1

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
  fi
done

# Determine color for the  icon
if [ "$max_usage" -le 5 ]; then
    color="^c#26b51f^"
elif [ "$max_usage" -le 10 ]; then
    color="^c#1f56b5^"
elif [ "$max_usage" -le 20 ]; then
    color="^c#1fa4b5^"
elif [ "$max_usage" -le 30 ]; then
    color="^c#1fb57e^"
elif [ "$max_usage" -le 40 ]; then
    color="^c#60b51f^"
elif [ "$max_usage" -le 50 ]; then
    color="^c#8ab51f^"
elif [ "$max_usage" -le 60 ]; then
    color="^c#b5ae1f^"
elif [ "$max_usage" -le 70 ]; then
    color="^c#b5771f^"
elif [ "$max_usage" -le 80 ]; then
    color="^c#b5541f^"
elif [ "$max_usage" -le 90 ]; then
    color="^c#b5541f^"
else
    color="^c#bd1919^"
fi

# Output with colored icon
printf "%s^d^ %.0f%%\n" "$color" "$max_usage"
