#!/usr/bin/perl
=pod
 Note: The following examples assume you are in the directory, ~/BestHoA
 
 perl cpServerFilesToAllInstances.pl tlh_keys_us_west_2.pem public_ips.txt instance_files  ec2-user
 
=cut
 
require "getConfigurationFile.pl";
=pod
ENVIRONMENT VARIABLES USED BY THIS CODE
 $pem = shift @ARGV;
 $public_ips = shift @ARGV;
 $infolder = shift @ARGV;
 $user = shift @ARGV;
=cut

 $outfolder="/home/$user";
 
 print "Entering. pem=\"$pem\", public_ips=\"$public_ips\", infolder=\"$infolder\", user=\"$user\", outfolder=\"$outfolder\"\n";

 my @CopyJustThis=();
 if ( scalar(@ARGV)  > 0 ){
    @CopyJustThis=@ARGV;
 }
 
 open(IN, $public_ips) || die "Can't open for input: \"$public_ips\"\n";
 
 while(<IN>){
    next if /^#/;
    chomp;
    my $ip=$_;
    
    my $CopyThis = (length($CopyJustThis)> 0)? "$infolder/$CopyJustThis": "$infolder/*";
    
    if ( scalar(@CopyJustThis) > 0 ){
       foreach my $CopyJustThis (@CopyJustThis){
           my $CopyThis = "$infolder/$CopyJustThis";
           print("scp -i $pem $CopyThis $user\@$ip:$outfolder\n");
           system("scp -i $pem $CopyThis $user\@$ip:$outfolder");
       }
    }
    else{
       my $CopyThis = "$infolder/*";
       print("scp -i $pem $CopyThis $user\@$ip:$outfolder\n");
       system("scp -i $pem $CopyThis $user\@$ip:$outfolder");
    }

 }
