#!/bin/bash

# install pre-requisite packages
sudo apt-get install user-mode-linux

# compile and install
make nokernel
sudo make install

sudo cp example/ulimits /usr/bin/umlbox-limits
sudo chmod +x /usr/bin/umlbox-limits
