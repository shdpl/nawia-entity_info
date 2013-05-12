#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/.. && \
dmd @build.rf && \
cd bin && \
./nawia-entity_info --tfs=/home/shd/src/nawia-data/data --rme=/home/shd/src/nawia-data/rme/data/854
