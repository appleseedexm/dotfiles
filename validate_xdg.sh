#!/bin/bash

VALID=true

if [ -z $XDG_CONFIG_HOME ]; then VALID=false; fi
if [ -z $XDG_CACHE_HOME ]; then VALID=false; fi
if [ -z $XDG_DATA_HOME ]; then VALID=false; fi
if [ -z $XDG_STATE_HOME ]; then VALID=false; fi
if [ -z $XDG_DATA_DIRS ]; then VALID=false; fi
if [ -z $XDG_CONFIG_DIRS ]; then VALID=false; fi

if [ $VALID == false ]; then
  echo "some XDG values are not set! abort"
  exit 1
fi
