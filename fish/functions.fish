function warn
    printf "\r\033[2K  [\033[0;33mWARN\033[0m] $argv[1]\n"
end

function source_if_exists
    if test -r $argv[1]
        source $argv[1]
    end
end

function binary_exists
    if not command -v -q $argv[1]
        warn "missing binary: $argv[1]"
    end
end

function ensure_tools
    for tool in zoxide exa fd rg gh
        if not command -v -q $tool
            warn "missing tool: $tool"
        end
    end
    # TODO: install tools if not already installed
    # https://remarkablemark.org/blog/2020/10/31/bash-check-mac/
end
