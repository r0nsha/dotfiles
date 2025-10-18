#!/usr/bin/env fish

if not pgrep wired
    wired & disown
    return
end

wired $argv
