#!/bin/bash

# This file simulates some I/O operations to demonstrate the sandbox functionality.
# Xiangyu Bu <xybu92@live.com>

# Read from file in a R-only dir
cat readable.txt

# Write to file in a R-only dir
echo "THIS FILE SHOULD NOT BE CREATED!" > WARNING.txt

# Create a new dir in a R-only dir
mkdir new_dir

# Enter the RW-only dir
cd rw

# Read a file
cat r.txt

# Write a file
echo "This shouldn't be written to the disk." > w.txt

# Prepare a file for later deletion.
echo "This file will be deleted." > d.txt

# List all files
ls -asl

# Remove a file
rm d.txt

# List result
ls -asl

# Sleep for 60 seconds so sandbox will kill the process halfway before it's done.
sleep 60
