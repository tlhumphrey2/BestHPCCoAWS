#!/bin/bash -e
# Run this with ssh: ssh -i <pem> $user@<ip> "bash mkNewKeysAndSaveOldKeysThenDistributeThem.sh"

# On master ssh in as user hpcc and mkdir new_ssh
master_private_ip=`head -1 private_ips.txt`;
echo "sudo -u hpcc ssh -t -o stricthostkeychecking=no hpcc@$master_private_ip \"mkdir new_ssh; mkdir old_ssh; cp -r .ssh old_ssh\""
sudo -u hpcc ssh -t -o stricthostkeychecking=no hpcc@$master_private_ip "mkdir new_ssh; mkdir old_ssh; cp -r .ssh old_ssh"

# On the master, as user ec2-user, make new ssh keys and put them in /home/hpcc/new_ssh:
echo "sudo -u hpcc ssh-keygen -f /home/hpcc/new_ssh/id_rsa -N \"\" -q"
echo -e  'y'|sudo -u hpcc ssh-keygen -f /home/hpcc/new_ssh/id_rsa -N "" -q
echo "sudo -u hpcc chmod 600 /home/hpcc/new_ssh/id_rsa"
sudo -u hpcc chmod 600 /home/hpcc/new_ssh/id_rsa
echo "sudo -u hpcc chmod 600 /home/hpcc/new_ssh/id_rsa.pub"
sudo -u hpcc chmod 600 /home/hpcc/new_ssh/id_rsa.pub

# copy private ips to /home/hpcc and change user:group to hpcc:hpcc
echo "sudo cp private_ips.txt /home/hpcc"
sudo cp private_ips.txt /home/hpcc
echo "sudo chown hpcc:hpcc /home/hpcc/private_ips.txt"
sudo chown hpcc:hpcc /home/hpcc/private_ips.txt

# Copy distribute_keys.sh to /home/hpcc, check owner to hpcc:hpcc
ehco "sudo cp distribute_keys.sh /home/hpcc"
sudo cp distribute_keys.sh /home/hpcc
echo "sudo chown hpcc:hpcc /home/hpcc/distribute_keys.sh"
sudo chown hpcc:hpcc /home/hpcc/distribute_keys.sh

# On the master switch user to hpcc and execute distribute_keys.sh
echo "sudo -u hpcc ssh -t -o stricthostkeychecking=no hpcc@$master_private_ip \"bash distribute_keys.sh\""
sudo -u hpcc ssh -t -o stricthostkeychecking=no hpcc@$master_private_ip "bash distribute_keys.sh"

