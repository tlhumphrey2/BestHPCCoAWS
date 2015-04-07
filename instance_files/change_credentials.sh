#!/bin/bash

system_username=$1
system_password=$2

echo "sudo htpasswd -cb /etc/HPCCSystems/.htpasswd $system_username $system_password"
sudo htpasswd -cb /etc/HPCCSystems/.htpasswd $system_username $system_password
