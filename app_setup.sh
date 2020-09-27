#!/bin/bash -x

## copy setup directory
scp -r ./setup todoapp:/home/admin

## this sets the username of the service account used by the todoapp service
## SERVICE_ACCOUNT must match the user account in configuration files found in ./setup directory
USER="root"
PASSWD="P@ssw0rd"

ssh root@todoapp "bash -s" < ./setup/install_script.sh