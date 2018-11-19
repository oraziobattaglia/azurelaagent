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

# Copia moduli
if [ ! -d /vagrant/modules ]; then
    mkdir /vagrant/modules
fi
echo "Utente DSA per l'accesso remoto al puppetserver, per copia di moduli e certificati:"
read user_dsa
rsync -rvz $user_dsa@puppetserver.unibo.it:/etc/puppetlabs/code/environments/integration/modules/ /vagrant/modules

# Copia keys per lettura eyaml
if [ ! -d /etc/puppetlabs/puppet/keys ]; then
    mkdir /etc/puppetlabs/puppet/keys
fi
echo "Password di root per la copia delle key per eyaml:"
rsync -rvz root@puppetserver.unibo.it:/etc/puppetlabs/puppet/keys/ /etc/puppetlabs/puppet/keys
