#!/usr/bin/env bash

set -euxo pipefail

CURRENT="$( cd "$( dirname "$0" )" && pwd )"
cd "$CURRENT"

./update_dockerfiles.pl 5.38 al2023
./update_dockerfiles.pl 5.38 al2
