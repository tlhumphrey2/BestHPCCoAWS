#!/bin/bash -e
# distribute_keys.sh

master_private_ip=`head -1 private_ips.txt`;
   
# Make file private_ips_slaves.txt under /home/hpcc
egrep -v $master_private_ip private_ips.txt > private_ips_slaves.txt
   
# On every slave node, save ssh keys for user hpcc in /home/hpcc/old_ssh
cat private_ips_slaves.txt|xargs -t -I{} ssh -o stricthostkeychecking=no {} "mkdir old_ssh; cp -r .ssh old_ssh"
   
# Copy master's new ssh keys to all slave nodes and put its public ssh key in each slave's ~/.ssh/authorized_keys
cat private_ips_slaves.txt|xargs -t -I{} ssh -o stricthostkeychecking=no {} "scp -o stricthostkeychecking=no $master_private_ip:/home/hpcc/new_ssh/id_rsa*  ~/.ssh/;cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
   
# Move keys in new_ssh to .ssh
cp ~/new_ssh/* ~/.ssh

cat ~/new_ssh/id_rsa.pub >> .ssh/authorized_keys