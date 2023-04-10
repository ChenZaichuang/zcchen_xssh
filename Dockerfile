FROM debian:11-slim

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server sudo readline-common
ADD . .
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && touch /root/.Xauthority \
  && true

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory, but also be able to sudo
RUN useradd docker \
        && passwd -d docker \
        && mkdir /home/docker \
        && chown docker:docker /home/docker \
        && addgroup docker staff \
        && addgroup docker sudo \
        && chmod +x /init.sh && /init.sh && rm /init.sh /ssh_keys.txt \
        && true

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
