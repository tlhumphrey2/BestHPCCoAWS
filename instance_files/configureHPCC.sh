#!/bin/bash -e
# This code is executed on ESP after installing HPCCSystems on all instances.

# The following usage example is what you do to configure an hpccsystem for best high performance on AWS when i2.8xlarge
# instances are used for the slave nodes. This example, configures 16 thor slave nodes per instance. And, there are 7
# instances. Making the total number of thor slave nodes 112 thor slave nodes. Also, this newly configured system will
# do mirroring.

. cfg_BestHPCC.sh

if [ -n "$1" ] && [ -n "$2" ]
then
   roxienodes=$1
   slavesPerNode=$2
fi

envgen=/opt/HPCCSystems/sbin/envgen;

# Make new environment.xml file for newly configured HPCC System.
echo "sudo $envgen -env $created_environment_file -override esp,@method,htpasswd -override thor,@replicateAsync,true -override thor,@replicateOutputs,true -ipfile $private_ips -supportnodes $supportnodes -thornodes $non_support_instances -roxienodes $roxienodes -slavesPerNode $slavesPerNode -roxieondemand 1"
sudo $envgen  -env $created_environment_file -override esp,@method,htpasswd -override thor,@replicateAsync,true -override thor,@replicateOutputs,true -ipfile $private_ips -supportnodes $supportnodes -thornodes $non_support_instances -roxienodes $roxienodes  -slavesPerNode $slavesPerNode -roxieondemand 1

if [ -n "$system_password" ] && [ -n "$system_username" ]
then
  # turn on authentication method htpasswed
  echo "For $created_environment_file, sed to change method to htpasswd and passwordExpirationWarningDays to 100"
  sudo sed "s/method=\"none\"/method=\"htpasswd\"/" $created_environment_file \
  | sudo sed "s/passwordExpirationWarningDays=\"[0-9]*\"/passwordExpirationWarningDays=\"100\"/" > ~/environment_with_htpasswd_enabled.xml 
  # copy changed environment file back into $created_environment_file
  echo "sudo cp ~/environment_with_htpasswd_enabled.xml $created_environment_file"
  sudo cp ~/environment_with_htpasswd_enabled.xml $created_environment_file
fi

# Copy the newly created environment file  to /etc/HPCCSystems on all nodes of the THOR
out_environment_file=/etc/HPCCSystems/environment.xml
echo "sudo /opt/HPCCSystems/sbin/hpcc-push.sh -s $created_environment_file -t $out_environment_file"
sudo /opt/HPCCSystems/sbin/hpcc-push.sh -s $created_environment_file -t $out_environment_file
