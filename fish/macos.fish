# Homebrew
if test (uname -s) = Darwin
    set -l machine (uname -m)
    set -l HOMEBREW_PREFIX (if test $machine = "arm64"
	    # On ARM macOS
	    echo /opt/homebrew
	else 
	    # On Intel macOS
	    echo /usr/local
	end
	)

    eval $HOMEBREW_PREFIX/bin/brew shellenv &> /dev/null
end
