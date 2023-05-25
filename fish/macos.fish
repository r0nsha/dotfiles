# Homebrew
switch (uname)
    case Darwin
        set -l machine (uname -m)

        switch (uname -m)
            case arm64
                set HOMEBREW_PREFIX /opt/homebrew
            case '*'
                set HOMEBREW_PREFIX /usr/local
        end

        eval $HOMEBREW_PREFIX/bin/brew shellenv &>/dev/null
end
