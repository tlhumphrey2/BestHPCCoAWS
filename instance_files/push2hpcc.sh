#!/bin/bash -e

. cfg_BestHPCC.sh

out_environment_file=/etc/HPCCSystems/environment.xml
#echo "sudo -u hpcc /opt/HPCCSystems/sbin/hpcc-push.sh -s $created_environment_file -t $out_environment_file"
#sudo -u hpcc /opt/HPCCSystems/sbin/hpcc-push.sh -s $created_environment_file -t $out_environment_file
echo "sudo /opt/HPCCSystems/sbin/hpcc-push.sh -s $created_environment_file -t $out_environment_file"
sudo /opt/HPCCSystems/sbin/hpcc-push.sh -s $created_environment_file -t $out_environment_file
