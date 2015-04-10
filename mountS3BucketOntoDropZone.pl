#!/usr/bin/perl
=pod
 perl mountS3BucketOntoDropzone.pl
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
$esp = <IN>; chomp $esp;
close(IN);

print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$esp \"bash $outfolder/mountS3Bucket.sh\"\n");
system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$esp \"bash $outfolder/mountS3Bucket.sh\"");
