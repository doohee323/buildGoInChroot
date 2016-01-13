# BuildGoInChroot

When you need to build golang app. in different ubuntu version, you can use chroot. I made it for the usecase. It makes chroot environment and a builds debian file.

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
	- add lucid in vagrant
	vagrant box add lucid64 http://files.vagrantup.com/lucid64.box
	- run vm
	vagrant up
	vagrant@hello:/vagrant$ hello server
	
	- open another terminal and run hello with client argument.
	vagrant ssh
	vagrant@hello:/vagrant$ hello client
	=> it works!
	 
	- but When you install hello_precise.deb in lucid, you'll get this error! 
	dpkg -i hello_precise.deb
	vagrant@hello:/vagrant$ hello server
	=> hello: /lib/libc.so.6: version `GLIBC_2.14' not found (required by hello)
	
```



