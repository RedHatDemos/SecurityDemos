FROM centos:7

RUN yum -y install epel-release
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install openssh-server audit authconfig initscripts git sudo selinux-policy-targeted cronie firewalld; \
    yum -y update; \
    yum clean all

# Fix for Travis docker containers
RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
RUN sed -i "s/disabled/permissive/g" -i /etc/selinux/config

VOLUME ["/sys/fs/cgroup", "/var/log/audit"]

CMD ["/usr/sbin/init"]
