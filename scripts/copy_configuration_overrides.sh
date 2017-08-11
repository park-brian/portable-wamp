#!/bin/bash

WORK_DIR="environment"
CONFIGURATION_DIR="configuration"

## copy default configuration overrides
echo "[COPY] $CONFIGURATION_DIR/* [->] $WORK_DIR/"
cp -rf $CONFIGURATION_DIR/* "$WORK_DIR/"
