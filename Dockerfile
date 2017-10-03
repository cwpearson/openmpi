FROM ubuntu:16.04

LABEL maintainer="carl.w.pearson@gmail.com"

ENV USER mpiuser
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/${USER}

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    apt-utils \
    && apt-get clean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    openssh-server \
    gcc \
    g++ \
    gfortran \
    libopenmpi-dev \
    openmpi-bin \
    openmpi-common \
    openmpi-doc \
    && apt-get clean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN adduser --disabled-password --gecos "" ${USER} && \
echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV SSHDIR ${HOME}/.ssh/
RUN mkdir -p ${SSHDIR}

ADD ssh/config ${SSHDIR}/config
ADD ssh/id_rsa ${SSHDIR}/id_rsa
ADD ssh/id_rsa.pub ${SSHDIR}/id_rsa.pub
ADD ssh/id_rsa.pub ${SSHDIR}/authorized_keys

RUN chmod -R 600 ${SSHDIR}* && \
chown -R ${USER}:${USER} ${SSHDIR}

RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]