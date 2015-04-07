#!/usr/bin/perl
=pod
 Note: The following 2 examples assume you are in the directory, $share/naveens_data

 Use following if instances are Amazon linux AMIs
 perl setupDisksOnAllInstances.pl public_ips.txt ec2-user tlh_keys_us_west_2.pem

=cut
 
require "getConfigurationFile.pl";
=pod
 ENVIRONMENT VARIABLES USED BY THIS PROGRAM
 $public_ips = $ARGV[0];
 $user = $ARGV[1];
 $pem = $ARGV[2];
=cut

 $outfolder="/home/$user";
 
 open(IN, $public_ips) || die "Can't open for input: \"$public_ips\"\n";
 
 while(<IN>){
    next if /^#/;
    chomp;
    my $ip=$_;
    
    print("ssh -t -i $pem $user\@$ip \"perl $outfolder/setup_zz_zNxlarge_disks.pl\"\n");
    system("ssh -t -i $pem $user\@$ip \"perl $outfolder/setup_zz_zNxlarge_disks.pl\"");

 }
