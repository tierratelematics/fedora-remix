#!/bin/bash

file="${@: -1}"
touch "$file"
chattr -C "$file"
fallocate.real "$@"
if [ $? -ne 0 ]; then
    echo "WARNING: ignoring fallocate failure" >&2
fi
