#!/usr/bin/env sh

MYSQL_SOCKET=$(grep ^socket /srv/hops/mysql-cluster/my.cnf/my.cnf | sed -e 's/socket.*= //' | tail -n 1)

echo "$MYSQL_SOCKET"
