#!/bin/bash

WORK_DIR="environment"

## change directory to root if required
[[ ! -d "$WORK_DIR" && -d "../$WORK_DIR" ]] && pushd ..

## remove .git
echo "[RM] .git"
rm -rf .git
echo

## remove .gitignore
echo "[RM] .gitignore"
rm -rf .gitignore
echo

## remove readme
echo "[RM] README.md"
rm -rf README.md
echo
