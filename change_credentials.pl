#!/usr/bin/perl

# USAGE: change_credentials.pl thumphrey4 mypassword5

require "getConfigurationFile.pl";

# Get username and password from command line
$username=$ARGV[0];
$password=$ARGV[1];

# Get all public ips
open(IN,$public_ips) || die "Can't open for input: \"$public_ips\"\n";
while(<IN>){
   next if /^\s*$/;
   chomp;
   $esp = $_ if $. == 1;
   push @public_ips, $_;
}
close(IN);

# Change credentials on every instance of HPCC
for( my $i=$#public_ips; $i >= 0; $i--){ 
  my $ip=$public_ips[$i];
  print("ssh -t -i $pem $user\@$ip \"./change_credentials.sh $username $password\"\n");
  system("ssh -t -i $pem $user\@$ip \"./change_credentials.sh $username $password\"");
}


