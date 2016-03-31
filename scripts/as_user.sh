#!/bin/bash

# Sets up a user & group and runs as them within the container, adding them as a sudoer

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo 'Create user and group and switch to them'
    echo 'Arguments: are username userid groupname groupid'
    echo 'At least one is missing!'
    exit 1
else
    addgroup "$3" --gid "$4"
    useradd "$1" -m -u "$2" -g "$3"
    echo "$1 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    su $1 -c bash
fi