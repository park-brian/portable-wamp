#!/bin/bash

WORKING_DIR="environment"
OVERRIDES_DIR="$WORKING_DIR/overrides"

## copy default overrides
echo "[COPY] $OVERRIDES_DIR/* [->] $WORKING_DIR/"
cp -rf $OVERRIDES_DIR/* "$WORKING_DIR/"
