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
set base_dir ~/tmp_nf_patch

rm -rf $base_dir
mkdir -p $base_dir

cd (realpath (dirname $zip_path))
yes | unzip $zip_path
cp -r 251*/TX-02-* $base_dir/in
cd $base_dir
mkdir $base_dir/out

# Mono
docker run --rm \
    -v $base_dir/in:/in \
    -v $base_dir/out:/out \
    nerdfonts/patcher \
    --complete

# Propo
docker run --rm \
    -v $base_dir/in:/in \
    -v $base_dir/out:/out \
    nerdfonts/patcher \
    --complete --variable-width-glyphs

if test (uname) = Darwin
    set system_fonts /Library/Fonts
else
    set system_fonts ~/.local/share/fonts
end

mkdir -p $system_fonts
yes | cp $base_dir/out/* $system_fonts

rm -rf $base_dir
cd $original_path
