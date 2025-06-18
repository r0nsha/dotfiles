#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/../.venv/bin/activate
python -m bin.install
