# KVM
#
# VERSION 0.0.1

FROM ubuntu:14.10
MAINTAINER Marcell Spies

# Replace dash with bash
RUN \
  ln -sf /bin/bash /bin/sh

# Install mono-complete, curl and unzip
RUN \
  apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mono-complete curl unzip && \
  rm -rf /var/lib/apt/lists/*

# Download and install kvm
RUN \
  curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh

# Download and install latest runtime version
RUN \
  source ~/.kre/kvm/kvm.sh && kvm upgrade

# Define working directory.
WORKDIR /data

# Volumes
VOLUME ["/data"]

# Define default command.
CMD ["bash"]

# Expose ports
EXPOSE 5000
