#!/bin/bash

# install pre-requisite packages
sudo apt-get install user-mode-linux

# compile and install
make nokernel
sudo make install
