#!/usr/bin/perl

require "getConfigurationFile.pl";

# Get all public ips
open(IN,$public_ips) || die "Can't open for input: \"$public_ips\"\n";
while(<IN>){
   next if /^\s*$/;
   chomp;
   $esp = $_ if $. == 1;
   push @public_ips, $_;
}
close(IN);

# push2hpcc.sh on all hpcc instances
for( my $i=$#public_ips; $i >= 0; $i--){ 
  my $ip=$public_ips[$i];
  print("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"./push2hpcc.sh\"\n");
  system("ssh -t -o stricthostkeychecking=no -i $pem $user\@$ip \"./push2hpcc.sh\"");
}


