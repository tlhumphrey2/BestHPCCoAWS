# BestHPCCoAWS
Scripts for configuring and deploying an HPCC on AWS that executes fast.

On 2015/02/19 added the document, SetupBestHPCCoAWS.pdf, which describes in detail how to setup the HPCC System on AWS.

Detailed documentation still needs to be written. But, the following is a list of steps to deploy a high performing HPCC cluster on AWS

1.	Fill in cfg_BestHPCC.sh (in the instance_files directory), the configuration table with the following info. Included ctg_BestHPCC.sh
	contains parameter values used to create a high performance HPCC on AWS
  * user=			# The name of the user when logging into a launched instance
  * private_ips=		# File containing the private IPs of instances deployed (this is created by step 4 below)
  * public_ips=			# File containing the public IPs of instances deployed (this is created by step 4 below)
  * created_environment_file=	# See cfg_BestHPCC.sh for example
  * supportnodes=		# Number of support nodes (this software expects this to be 1)
  * non_support_instances=	# Number of instances that will have thor slave nodes (
  * roxienodes=			# Number of roxie nodes
  * slavesPerNode=		# Number of thor slave nodes per instance
  * hpcc_platform=		# The version of HPCC to be installed (see cfg_BestHPCC.sh for example)
  * S3_ACCESS_KEY=		# Your AWS access key
  * S3_SECRET_KEY=		# Your AWS secret key
  * bucket_name=		# If you have a S3 bucket you want mounted to the dropzone, name bucket here otherwise leave this out.
  * slave_instance_type=	# Instance type of instances that will have thor slaves
  * master_instance_type=	# Instance type of master instance
  * pem=			# Your pem file associated with instances that were launched.
  * infolder=			# Name of folder containing all files to be copied to launched instances.
  * instance_ids=		# Name of file containing ids of instances launched (1st instance id should be that for master)
  * region=			# Region where instances have been launched (e.g. us-west-1 or us-west-2, etc.)
2.	Bring up instances using aws console. Use instructions in document, Manual Steps to Bring Up Best HPCC on AWS.docx
3.	From Instances page of aws console, put instance ids of all instances into instance_ids.txt. MAKE SURE master's id is 1st.
4.	getPublicAndPrivateIPsOfAllInstances.pl to get private and public IPs into the files, private_ips.txt and public_ips.txt, respectively.
5.	cpServerFilesToAllInstances.pl to copy software to instances that will be ran there.
6.	setupDisksOnAllInstances.pl to setup disk for good performance (raid, mount unmounted disks, etc)
7.	installHPCCOnAllInstancesAndStart.pl to install HPCC and start it (this will be a 1st minimal system with 1 slave node per instance)
8.	Go into ECL Watch just to make sure the system is up and running.
9.	configureHPCC_multislaves_per_instance.pl to reconfigure HPCC System so there are multiple slave nodes per instance.
10.	Go into ECL Watch just to make sure the system is up and running.Try running on thor the code in playground.
11.	If you need data in an S3 bucket, ssh into master instance and run mountS3Bucket.sh to mount your S3 bucket on the dropzone.
12.	updateSystemFilesOnAllInstances.pl to update system files that enable the Linux system to handle the traffic from many slave nodes per instance.
13.	Check to make sure that system is up and running. Run terasort.

