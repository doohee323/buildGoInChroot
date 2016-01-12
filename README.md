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



