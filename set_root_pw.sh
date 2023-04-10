#!/bin/bash

if [ -z "${SSH_KEY}" ]; then
echo "=> Please pass your public key(s) in the SSH_KEY environment variable"
exit 1
fi

# split the SSH_KEY into an array of strings

readarray -t SSH_KEYS <<<"$SSH_KEY"

for MYHOME in /root /home/docker; do
  echo "=> Adding SSH key(s) to ${MYHOME}"
  mkdir -p ${MYHOME}/.ssh
  chmod go-rwx ${MYHOME}/.ssh
  for KEY in "${SSH_KEYS[@]}"; do
    echo "${KEY}" >> ${MYHOME}/.ssh/authorized_keys
  done
  chmod go-rw ${MYHOME}/.ssh/authorized_keys
  echo "=> Done!"
done
chown -R docker:docker /home/docker/.ssh

echo "========================================================================"
echo "You can now connect to this container via SSH using:"
echo ""
echo " ssh -p <port> <user>@<host>"
echo ""
echo "Choose root (full access) or docker (limited user account) as <user>."
echo "========================================================================"

