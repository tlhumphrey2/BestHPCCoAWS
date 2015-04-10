#!/usr/bin/perl
=pod
 This code is executed after installing HPCCSystems on an box.

 Note: The following example assumes you are in the directory, ~/BestHoA
 configureHPCC_multislaves_per_instance.pl ec2-user public_ips.txt private_ips.txt environment_16slaves.xml 1 2 0 16 tlh_keys_us_west_2.pem
=cut
require "getConfigurationFile.pl";

=pod
THESE ARE VARIABLES USED FROM getConfigurationFile.pl.
$user = shift @ARGV; # arg 1. This should be juju node id (e.g. tlh-hpcc/0) or user@ip (ec2-user@54.193.105.181)
$public_ips = shift @ARGV;# arg 2
$private_ips = shift @ARGV;# arg 3.
$created_environment_file = shift @ARGV;# arg 4.
$supportnodes = shift @ARGV;# arg 5.
$non_support_instances = shift @ARGV;# arg 6.
$roxienodes = shift @ARGV;# arg 7.
$slavesPerNode = shift @ARGV;# arg 8.
$pem = shift @ARGV;# arg 9
=cut

# Get all public ips
open(IN,$public_ips) || die "Can't open for input: \"$public_ips\"\n";
while(<IN>){
   next if /^\s*$/;
   chomp;
   $esp = $_ if $. == 1;
   push @public_ips, $_;
}
close(IN);

#Stop HPCC on all instances.
for( my $i=$#public_ips; $i >= 0; $i--){ 
  my $ip=$public_ips[$i];
  print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init stop\"\n");
  system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init stop\"");
}

print "ssh -t -o stricthostkeychecking=no -i $pem $user\@$esp \"bash configureHPCC.sh\n";
system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$esp \"bash configureHPCC.sh\"");

print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$esp \"bash mkNewKeysAndSaveOldKeysThenDistributeThem.sh\"\n");
system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$esp \"bash mkNewKeysAndSaveOldKeysThenDistributeThem.sh\"");

#Start HPCC on all instances. But, with the master the last to start
for( my $i=$#public_ips; $i >= 0; $i--){ 
  my $ip=$public_ips[$i];
  print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init start\"\n");
  system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init start\"");
}


