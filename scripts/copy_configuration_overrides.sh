#!/bin/bash

WORK_DIR="environment"
CONFIGURATION_DIR="configuration"

## change directory to root if required
[[ ! -d "$WORK_DIR" && -d "../$WORK_DIR" ]] && pushd ..

## copy default configuration overrides
echo "[COPY] $CONFIGURATION_DIR/* [->] $WORK_DIR/"
cp -rf $CONFIGURATION_DIR/* "$WORK_DIR/"
