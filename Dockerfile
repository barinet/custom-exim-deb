FROM i386/debian:latest

# add in Debian testing source repositories
RUN /usr/bin/perl -i -ne 'print; s/^deb /deb-src / && s/stretch/testing/ && print' /etc/apt/sources.list

# exim4 source plus some libraries not pulled in by default
RUN /usr/bin/apt-get update && /usr/bin/apt-get install -y apt-src && /usr/bin/apt-src install exim4 && \
/usr/bin/apt-get install -y libspf2-dev libssl-dev libidn11-dev libidn2-0-dev libopendmarc-dev dctrl-tools

# patch to the config
COPY EDITME.exim4-wormnet.diff ./
# hack to make pack-configs not fail
COPY debrules.diff ./
# and to help make the custom package
COPY debcontrol.custom.diff ./

# build the beastie
RUN cd /exim4-4.* && \
	/usr/bin/patch -p0 < ../debrules.diff && \
	env customdaemon=exim4-daemon-wormnet debian/rules unpack-configs && \
	/bin/cp EDITME.exim4-heavy EDITME.exim4-wormnet && \
	/usr/bin/patch -p0 < ../EDITME.exim4-wormnet.diff && \
	/bin/rm -f EDITME.exim4-wormnet.orig && \
	env customdaemon=exim4-daemon-wormnet debian/rules pack-configs && \
	/usr/bin/patch -p0 < ../debcontrol.custom.diff && \
	env customdaemon=exim4-daemon-wormnet debian/create-custom-package wormnet && \
	env customdaemon=exim4-daemon-wormnet debian/rules build && \
	/usr/bin/patch -p0 -R  < ../debcontrol.custom.diff && \
	env customdaemon=exim4-daemon-wormnet debian/rules binary
