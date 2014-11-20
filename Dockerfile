FROM marcells/mono
MAINTAINER Marcell Spies (@marcells)

# Replace dash with bash
RUN \
  ln -sf /bin/bash /bin/sh

# Install curl and unzip (everything to get kvm running)
RUN apt-get -q update \
  && apt-get -qy install \
    curl \
    unzip

# Download and install kvm
RUN \
  curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh

# Download and install latest runtime version
RUN \
  source ~/.kre/kvm/kvm.sh \
  && kvm upgrade

# Download root certificates to permit kpm to download packages from https sources
RUN \
  mozroots --import --sync

# Install correct version of libuv to use Kestrel server
RUN \
  apt-get -qy install \
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

# Define working directory.
WORKDIR /data

# Volumes
VOLUME ["/data"]

# Define default command.
CMD ["bash"]

# Expose ports
EXPOSE 5004