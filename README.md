# BuildGoInChroot

When you need to build Golang app. in different ubuntu version, you can use chroot. I made it for the usecase. It makes chroot environment and a builds debian file. And I made a lucid with vagrant, and installed below 3 ubuntu version debians in it. Since ZMQ library is needed for this app, only lucid debian can run in lucid VM.

# Required
```
	1. install chroot
		apt-get install dchroot
		apt-get install debootstrap
		
	2. edit chroot configuration
		vi /etc/schroot/schroot.conf
		
		[precise]
		description=Ubuntu precise
		location=~/chroot/precise
		priority=3
		users=hello
		group=hello
		root-groups=root
		
		[lucid]
		description=Ubuntu lucid
		location=~/chroot/lucid
		priority=3
		users=hello
		group=hello
		root-groups=root
		
		[trusty]
		description=Ubuntu trusty
		location=~/chroot/trusty
		priority=3
		users=hello
		group=hello
		root-groups=root
```

# How to run
```
	$ bash chroot.sh precise 1.0
		- 1st arg: ubuntu version precise / lucid / trusty ...
		- 2nd arg: want to build version
```

# Verify in lucid
```
	- install vagrant 4.3
	https://www.virtualbox.org/wiki/Download_Old_Builds_4_3
	cf. vagrant box add ubuntu/trusty64
		vagrant box add lucid64 http://files.vagrantup.com/lucid64.box
```



