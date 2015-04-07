#!/usr/bin/perl
=pod
getInstanceIDs.pl
=cut

require "getConfigurationFile.pl";

$x=`aws ec2 describe-instances --region $region|egrep "InstanceId.:"`;
@x=split(/\n/,$x);
@x=grep(s/^.+InstanceId\":\s\"//,@x);
@x=grep(s/\",\s*$//,@x);

print STDERR "Outputting to $instance_ids\n";
open(OUT,">$instance_ids") || die "Can't open for output: \"$instance_ids\"\n";
print OUT join("\n",@x),"\n";
close(OUT);
