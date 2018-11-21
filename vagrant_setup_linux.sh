#!/bin/bash

if [ ! -f /proc/cpuinfo ]
then
    echo "Lo script deve essere eseguito da Linux"
    exit 0
fi

is_virtual_machine="cat /proc/cpuinfo |grep hypervisor"

if [ -z "$is_virtual_machine" ]
then
    echo "Lo script deve essere avviato da una macchina virtuale vagrant"
    exit 0
fi

if [ $(whoami) != 'root' ]
then
    echo "Lo script deve essere eseguito da root"
    exit 0
fi

cd /
ln -s /vagrant/ ./azurelaagent
echo "include azurelaagent" > ./test.pp
