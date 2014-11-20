# KVM
#
# VERSION 0.0.1

FROM ubuntu:14.10
MAINTAINER Marcell Spies

# Replace dash with bash
RUN \
  ln -sf /bin/bash /bin/sh

# Install mono-complete, curl and unzip (everything to get kvm running)
RUN \
  apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list \
  && apt-get -qq update \
  && apt-get -qqy install \
    mono-complete \
    curl \
    unzip

# Install correct version of libuv to use Kestrel server
RUN \
  apt-get -qqy install \
    autoconf \
    automake \
    build-essential \
    libtool \
  && LIBUV_VERSION=1.0.0-rc2 \
  && curl -sSL https://github.com/joyent/libuv/archive/v${LIBUV_VERSION}.tar.gz | tar zxfv - -C /usr/local/src \
  && cd /usr/local/src/libuv-$LIBUV_VERSION \
  && sh autogen.sh && ./configure && make && make install \
  && rm -rf /usr/local/src/libuv-$LIBUV_VERSION \
  && ldconfig

# Cleanup
RUN \
  rm -rf /var/lib/apt/lists/*

# Download and install kvm
RUN \
  curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh

# Download and install latest runtime version
RUN \
  source ~/.kre/kvm/kvm.sh \
  && kvm upgrade

# Download root certificates to permit kpm to donwload packages from https sources
RUN \
  mozroots --import --sync

# Define working directory.
WORKDIR /data

# Volumes
VOLUME ["/data"]

# Define default command.
CMD ["bash"]

# Expose ports
EXPOSE 5004