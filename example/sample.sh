#!/bin/bash

cat readable.txt
echo "THIS FILE SHOULD NOT BE CREATED!" > WARNING.txt
cd rw
cat r.txt
echo "This shouldn't be written to the disk." > w.txt
echo "This file will be deleted." > d.txt
ls -asl
rm d.txt
ls -asl
