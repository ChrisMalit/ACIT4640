#!/bin/bash -x

## Copy Setup Folder
scp -r ./setup todoapp:/home/admin

USER="root"
PASSWD="P@ssw0rd"

ssh root@todoapp "bash -s" < ./setup/install_script.sh