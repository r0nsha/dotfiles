# Homebrew
switch (uname)
    case Darwin
        set -l machine (uname -m)

        if [ test $machine = arm64 ]
            # On ARM macOS
            set HOMEBREW_PREFIX /opt/homebrew
        else
            # On Intel macOS
            set HOMEBREW_PREFIX /usr/local
        end

        eval $HOMEBREW_PREFIX/bin/brew shellenv &>/dev/null
end
