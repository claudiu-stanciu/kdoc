#!/bin/bash
DEV=${1-false}

if [ ${DEV} = "false" ]; then
    curl -o /tmp/kylo.rpm -L http://bit.ly/2r4P47A
else