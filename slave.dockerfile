FROM ubuntu:18.04

ENV JENKINSUSER=jenkins
ENV JENKINSPASSWORD=W3cW_Yw&D%rQ%rk

LABEL maintainer="Mário Santos <mariogilgsantos@gmail.com>"

# Make sure the package repository is up to date.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq && \
    apt-get install dialog apt-utils -qy && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 11
    apt-get install openjdk-11-jdk && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user
    echo "${JENKINSUSER}:${JENKINSPASSWORD}" | chpasswd && \
    mkdir /home/jenkins/.m2

#ADD settings.xml /home/jenkins/.m2/
# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
