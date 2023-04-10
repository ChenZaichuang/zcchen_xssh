#!/bin/bash

set -e

for MYHOME in /root /home/docker; do
  mkdir -p ${MYHOME}/.ssh
  chmod go-rwx ${MYHOME}/.ssh
  cp /ssh_keys.txt ${MYHOME}/.ssh/authorized_keys
  chmod go-rw ${MYHOME}/.ssh/authorized_keys
done
chown -R docker:docker /home/docker/.ssh
