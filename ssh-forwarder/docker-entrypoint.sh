#!/bin/sh

SSH_KEYFILE="/root/.ssh/id_rsa"

if [ ! -f $SSH_KEYFILE ]
then
    ssh-keygen -q -f $SSH_KEYFILE -N "" -C "ssh-forwarder@$HOSTNAME"

    echo "Generated ssh keypair"
    echo
    echo "Public key:"
    echo
    echo "$(cat "$SSH_KEYFILE".pub)"
    echo
    echo "Please add the public key to the authorized_keys file on the server and restart the container."
else
    exec ssh -vvv -4 -N -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no $@
fi

