#!/usr/bin/env bash

install_fonts() {
	case "$MACHINE" in
	linux) local fonts=$HOME/.local/share/fonts ;;
	macos) local fonts=/Library/Fonts ;;
	*) ;;
	esac

	mkdir -p $fonts

	local fonts_base_url=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0
	local font=Iosevka
	local font_term=IosevkaTerm
	local font_zip=$DOWNLOADS/$font.zip
	local font_term_zip=$DOWNLOADS/$font_term.zip

	# Check if fonts are already installed
	if [[ $(ls "$fonts" | grep -c "${font// /}NerdFont") -gt 0 &&
	$(ls "$fonts" | grep -c "${font_term// /}NerdFont") -gt 0 ]]; then
		success "fonts already installed, skipping"
		return
	fi

	running "downloading $font and $font_term from $fonts_base_url..."
	wget -nv -O $font_zip $fonts_base_url/$font.zip &
	wget -nv -O $font_term_zip $fonts_base_url/$font_term.zip &
	wait

	running "installing $font and $font_term in $fonts..."
	unzip -q -o $font_zip '*.ttf' -d $fonts &
	unzip -q -o $font_term_zip '*.ttf' -d $fonts &
	wait

	success "fonts installed"
}

install_fonts
