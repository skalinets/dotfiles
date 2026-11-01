#!/bin/sh
memory_pressure | awk '/percentage/ {gsub(/%/,"",$5); printf "M:%d%%", 100-$5}'
