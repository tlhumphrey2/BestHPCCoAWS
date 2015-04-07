#!/usr/bin/perl
=pod
  Note: The following 2 examples assume you are in the directory, ~/BestHoA
 
  Use following if instances are ubuntu
  perl getPublicAndPrivateIPsOfAllInstances.pl instance_ids.txt instance_files ec2-user us-west-2
=cut
 
require "getConfigurationFile.pl";
=pod
 ENVIRONMENT VARIABLES USED BY THIS PROGRAM
 $instance_ids = $ARGV[0];
 $infolder = $ARGV[1];
 $user = $ARGV[2];
 $region = $ARGV[3];
=cut

 print "instance_ids=\"$instance_ids\", infolder=\"$infolder\", user=\"$user\", region=\"$region\"\n";
 
 open(IN, $instance_ids) || die "Can't open for input: \"$instance_ids\"\n";
 
 my $private_ips_file="$infolder/private_ips.txt";
 my $public_ips_file="public_ips.txt";
 open(OUT1,">$private_ips_file") || die "Can't open for output: \"$private_ips_file\"\n";
 open(OUT2,">$public_ips_file") || die "Can't open for output: \"$public_ips_file\"\n";
 
 while(<IN>){
    next if /^#/ || /^\s*$/;
    chomp;
    print "DEBUG: Input from <IN> is \"$_\"\n";
    my $instance_id=$_;
    print "DEBUG: instance_id=\"$instance_id\"\n";
    
    print "AWS COMMAND IS: aws ec2 describe-instances --instance-ids $instance_id --region $region\n\n";
    local $_=`aws ec2 describe-instances --instance-ids $instance_id --region $region`;
    print "DEBUG: Length of AWS's output is: ",length($_),"\n";
    my $public_ip = $1 if /\"PublicIpAddress\": \"(\d+\.\d+\.\d+\.\d+)\"/;
    my $private_ip = $1 if /\"PrivateIpAddress\": \"(\d+\.\d+\.\d+\.\d+)\"/;
    print "DEBUG: public_ip=\"$public_ip\"\n";
    print "DEBUG: private_ip=\"$private_ip\"\n";
    print OUT1 "$private_ip\n";
    print OUT2 "$public_ip\n";
 }
 
 close(OUT1);
 close(OUT2);
 print "Outputting $public_ips_file\n";
 print "Outputting $private_ips_file\n";
 
