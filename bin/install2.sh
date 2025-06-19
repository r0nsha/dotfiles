#!/usr/bin/env bash

script_dir=$(dirname "$0")
venv_dir=$script_dir/.venv

if [ ! -d "$venv_dir" ]; then
    echo settings up venv...
    python3 -m venv $script_dir/.venv
fi

source $script_dir/.venv/bin/activate
python -m bin.install
# sudo $(printenv VIRTUAL_ENV)/bin/python3 -m bin.install
