#!/bin/bash
# Copyright (c) 2017, 2021, Oracle and/or its affiliates.
# Copyright (c) 2021, 2021, Hopsworks AB and/or its affiliates.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
set -e

echo "[Entrypoint] RonDB Docker Image"

echo "\$@: $@"

# https://stackoverflow.com/a/246128/9068781
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "$1" = 'mysqld' ]; then
    $SCRIPT_DIR/mysqld.sh "$@"
else
	if [ -n "$MYSQL_INITIALIZE_ONLY" ]; then
		echo "[Entrypoint] MySQL already initialized and MYSQL_INITIALIZE_ONLY is set, exiting without starting MySQL..."
		exit 0
	fi

	# "set" lets us set the arguments to the current script.
	# the command also has its own commands (see set --help).
	# to avoid accidentally using one of the set-commands,
	# we use "set --" to make clear that everything following
	# this is an argument to the script itself and not the set
	# command.

	set -- "$@" --nodaemon
	if [ "$1" == "ndb_mgmd" ]; then
		echo "[Entrypoint] Starting ndb_mgmd"
		set -- "$@" -f $RONDB_DATA_DIR/config.ini --configdir=$RONDB_DATA_DIR/log
	elif [ "$1" == "ndbmtd" ]; then
		echo "[Entrypoint] Starting ndbmtd"
		# Command for more verbosity with ndbmtds: `set -- "$@" --verbose=TRUE`
	elif [ "$1" == "ndb_mgm" ]; then
		echo "[Entrypoint] Starting ndb_mgm"
	fi
	exec "$@"
fi
