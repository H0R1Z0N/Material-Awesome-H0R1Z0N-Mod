#!/bin/bash
# Polls UPower for every connected battery-reporting device (Bluetooth
# peripherals, USB UPS, etc.), skipping the synthetic DisplayDevice and
# anything with no percentage (e.g. line-power/AC adapters).
for d in $(upower -e | grep -v DisplayDevice); do
  info=$(upower -i "$d")
  model=$(echo "$info" | awk -F: '/model:/{ $1=""; sub(/^[ \t]+/,""); print }')
  percentage=$(echo "$info" | awk -F: '/percentage:/{ gsub(/[ \t%]/,"",$2); print $2 }')
  state=$(echo "$info" | awk -F: '/state:/{ gsub(/[ \t]/,"",$2); print $2 }')
  if [ -n "$percentage" ]; then
    echo "${d}|${model:-Unknown}|${percentage}|${state:-unknown}"
  fi
done
