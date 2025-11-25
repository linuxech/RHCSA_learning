#!/usr/bin/bash

sudo touch ~/output.txt

echo "You are successfully connected with the Linuxech" > ~/output.txt
echo "" >> ~/output.txt
echo "########################################################" >> ~/output.txt
echo " Your System IP is " >> ~/output.txt
ip a >>  ~/output.txt
echo "" >> ~/output.txt
echo "#######################################################" >> ~/output.txt
echo "List Block Devices" >> ~/output.txt
echo "" >> ~/output.txt
lsblk >> ~/output.txt
echo "" >> ~/output.txt
echo "#######################################################" >> ~/output.txt
echo "Filesystem Free Space Status" >> ~/output.txt
echo "" >> ~/output.txt
df -h >> ~/output.txt
echo "#######################################################" >> ~/output.txt
