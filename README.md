
apt-get install dchroot
apt-get install debootstrap

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
