#!/bin/bash

ulimit -S -n 4096
sysctl -w fs.inotify.max_user_watches=100000

python3 generator.py

for rate in 100 150 200 300 500; do
  vegeta attack -rate="$rate" -duration=300s -targets=targets.txt > "results-$rate.bin"
done

vegeta report -inputs="$(echo results-*.bin | tr ' ' ',')"
