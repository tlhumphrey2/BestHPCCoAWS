#!/usr/bin/perl
=pod
 Note: The following 2 examples assume you are in the directory, $share/naveens_data
 Use the following if instances are Amazon linux AMIs

 perl updateSystemFilesOnAllInstances.pl public_ips.txt ec2-user tlh_keys_us_west_2.pem
=cut

require "getConfigurationFile.pl";
=pod
ENVIRONMENT VARIABLES USED BY THIS PROGRAM
$user = shift @ARGV; # arg 1
$public_ips = shift @ARGV;# arg 2
$pem = shift @ARGV;# arg 3
=cut

 $outfolder="/home/$user";
 
 open(IN, $public_ips) || die "Can't open for input: \"$public_ips\"\n";
 
 my $ecp_ip='';
 while(<IN>){
    next if /^#/;
    chomp;
    my $ip=$_;
    push @public_ips, $ip;

    print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init stop\"\n");
    system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init stop\"");
    
    print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"perl $outfolder/updateSystemFilesForHPCC.pl\"\n");
    system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"perl $outfolder/updateSystemFilesForHPCC.pl\"");
 }
 
#Start HPCC on all instances. But, with the master the last to start
for( my $i=$#public_ips; $i >= 0; $i--){ 
  my $ip=$public_ips[$i];
  print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init start\"\n");
  system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"sudo service hpcc-init start\"");
}
