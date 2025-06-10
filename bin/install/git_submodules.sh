#!/usr/bin/env bash

running "doing git things..."
chmod ug+x $DOTFILES/hooks/*
git submodule init
git submodule update --init --recursive
success "did all git things"
