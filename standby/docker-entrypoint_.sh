#!/bin/bash

/etc/init.d/ssh start
/docker-entrypoint.sh "$@"
