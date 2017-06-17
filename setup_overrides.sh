#!/bin/bash

WORK_DIR="environment"
OVERRIDES_DIR="configuration"

## copy default overrides
echo "[COPY] $OVERRIDES_DIR/* [->] $WORK_DIR/"
cp -rf $OVERRIDES_DIR/* "$WORK_DIR/"
