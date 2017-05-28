FROM ubuntu:16.04

ENV TERM xterm

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa -y && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
        sudo \
        man \
        git-core \
        sysstat \
        vim \
        wget \
        curl \
        python \
        openjdk-7-jdk \
        && \
    curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get install -y nodejs && \
    ldconfig && \
    chmod a+x /usr/local/bin/entrypoint.sh && \
    echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]