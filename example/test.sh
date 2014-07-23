#!/bin/bash

# Run sample.sh (containing I/O operations) in sandbox.
# Xiangyu Bu <xybu92@live.com>

# ../ulimits sets more restrictions on the process via `ulimit`
# use `nice` to change process priority
# . is mounted as R-only
# ./rw is mounted RW-only
# memory ceiling is set to 48MiB
# kill the process after 20 seconds
/usr/bin/umlbox -B -fw ./rw -f . -m 48m -T 20 `pwd`/ulimits /usr/bin/nice -n10 ./sample.sh
