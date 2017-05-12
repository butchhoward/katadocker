FROM ubuntu:14.04

ENV no_proxy localhost,*.ford.com

ENV TERM xterm

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa -y

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \
        git-core \
        subversion \
        autoconf \
        gtk-doc-tools \
        libgtk2.0-dev \
        libncurses5-dev \
        ant \
        libusb-1.0-0-dev \
        gv \
        libncurses-dev \
        openjdk-7-jdk \
        libgl1-mesa-dev \
        libgsl0-dev \
        socat \
        libdc1394-22-dev \
        ptpd \
        espeak \
        libncurses5-dev \
        libudev-dev \
        libjpeg-dev \
        libssl-dev \
        bc \
        sysstat \
        valgrind \
        gitk \
        vim \
        libav-tools \
        wget \
        libsuitesparse-dev \
        libboost-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        cmake \
        python

#----------------------------------------
# LCM
#----------------------------------------
COPY external-lcm /tmp/external-lcm
WORKDIR /tmp/external-lcm
RUN ./bootstrap.sh
RUN ./configure
RUN make -j$(nproc)
RUN make install
RUN rm -rf /tmp/external-lcm

#----------------------------------------
# Eigen3
#----------------------------------------
COPY external-packages/eigen-vds_3.1.3_amd64.deb /tmp/eigen-vds_3.1.3_amd64.deb
RUN dpkg -i /tmp/eigen-vds_3.1.3_amd64.deb
RUN rm /tmp/eigen-vds_3.1.3_amd64.deb

#----------------------------------------
# ISAM
#----------------------------------------
COPY external-isam /tmp/external-isam
WORKDIR /tmp/external-isam
RUN make -j$(nproc) BUILD_PREFIX=/usr/local
RUN rm -rf /tmp/external-isam

RUN ldconfig

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]