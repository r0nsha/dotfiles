#!/usr/bin/env fish

# Control mako notifications

if not pgrep mako
    mako & disown
    return
end

switch $argv[1]
    case '--drop'
        switch $argv[2]
            case 'latest'
                makoctl dismiss
            case 'all'
                makoctl dismiss --all
            case '*'
                makoctl dismiss
        end
    case '*'
        # Default to dismissing latest
        makoctl dismiss
end
