#!/bin/bash

# Sets up a user & group and runs as them within the container

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo 'Create user and group and switch to them'
    echo 'Arguments: are username userid groupname groupid'
    echo 'At least one is missing!'
    exit 1
else
    addgroup "$3" --gid "$4"
    useradd "$1" -u "$2" -g "$3"
    su $1 -c bash
fi
#addgroup "$(id -gn)" --gid "$(id -g)" && useradd "$(id -un)" -u $(id -u) -g $(id -g)