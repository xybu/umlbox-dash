#!/bin/bash

# /usr/bin/umlbox -B -fw ./rw -f . -m 16m -T 20 `pwd`/../limits /usr/bin/nice -n10 ./sample.sh
/usr/bin/umlbox -B -fw ./rw -f . -m 48m -T 20 `pwd`/ulimits /usr/bin/nice -n10 time ./sample.sh
