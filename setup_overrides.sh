#!/bin/bash

WORKING_DIR="environment"

WORK_DIR="environment"
OVERRIDES_DIR="$WORK_DIR/overrides"

## copy default overrides
echo "[COPY] $OVERRIDES_DIR/* [->] $WORK_DIR/"
cp -rf $OVERRIDES_DIR/* "$WORK_DIR/"
