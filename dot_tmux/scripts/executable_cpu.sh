#!/bin/sh
cores=$(sysctl -n hw.logicalcpu)
ps -A -o %cpu | awk -v c="$cores" '{s+=$1} END {printf "C:%.0f%%", s/c}'
