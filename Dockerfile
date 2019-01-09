FROM i386/debian:latest

# add in Debian testingsource repositories
RUN /usr/bin/perl -i -ne 'print; s/^deb /deb-src / && s/stretch/testing/ && print' /etc/apt/sources.list

# exim4 source plus some libraries not pulled in by default
RUN /usr/bin/apt-get update && /usr/bin/apt-get install -y apt-src && /usr/bin/apt-src install exim4 && \
/usr/bin/apt-get install -y libspf2-dev libssl-dev libidn11-dev libidn2-0-dev libopendmarc-dev dctrl-tools

COPY EDITME.exim4-wormnet.diff ./

# build the beastie
RUN cd /exim4-4.91 && \
	debian/rules unpack-configs; \
	cp EDITME.exim4-heavy EDITME.exim4-wormnet; \
	patch -p0 < ../EDITME.exim4-wormnet.diff; \
	debian/rules pack-configs; \
	debian/create-custom-package wormnet; \
	env CFLAGS=-Os customdaemon=exim4-daemon-wormnet dpkg-buildpackage -uc -us; \
	/bin/true

VOLUME /exim4-4.91/b-exim4-daemon-wormnet/build-Linux-x86_64

