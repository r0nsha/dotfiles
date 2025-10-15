#! /usr/bin/env fish

# Extracts and Patches the amazing Berkeley Mono font

if test (count $argv) -ne 1
    echo "Usage: scripts/patch_berkeley_mono.fish <zip>"
    exit 1
end

set zip_path $argv[1]

if not test -f $zip_path
    echo "File not found: $zip_path"
    exit 1
end

set original_path (pwd)

rm -rf /tmp/original /tmp/patched

cd (realpath (dirname $zip_path))
yes | unzip $zip_path
cp 251015*/TX-02-* /tmp/original
cd /tmp
mkdir patched

if not test -d nerd-fonts
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
end

cd nerd-fonts

# Mono
docker run --rm \
    -v /tmp/original:/in \
    -v /tmp/patched:/out \
    nerdfonts/patcher \
    --complete

# Propo
docker run --rm \
    -v /tmp/original:/in \
    -v /tmp/patched:/out \
    nerdfonts/patcher \
    --complete \
    --variable-width-glyphs

if test (uname) = Darwin
    set system_fonts /Library/Fonts
else
    set system_fonts ~/.local/share/fonts
end

mkdir -p $system_fonts
yes | cp /tmp/patched/* $system_fonts

cd $original_path
