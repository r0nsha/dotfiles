set wallpaper '%%wallpaper%%'

set background '%%background%%'
set foreground '%%foreground%%'
set cursor '%%cursor%%'
set border '%%border%%'

set color0 '%%color0.hex%%'
set color1 '%%color1.hex%%'
set color2 '%%color2.hex%%'
set color3 '%%color3.hex%%'
set color4 '%%color4.hex%%'
set color5 '%%color5.hex%%'
set color6 '%%color6.hex%%'
set color7 '%%color7.hex%%'
set color8 '%%color8.hex%%'
set color9 '%%color9.hex%%'
set color10 '%%color10.hex%%'
set color11 '%%color11.hex%%'
set color12 '%%color12.hex%%'
set color13 '%%color13.hex%%'
set color14 '%%color14.hex%%'
set color15 '%%color15.hex%%'

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $color13
set -g fish_color_keyword $color14
set -g fish_color_quote $color13
set -g fish_color_redirection $foreground
set -g fish_color_end $color15
set -g fish_color_option $color13
set -g fish_color_error $color10
set -g fish_color_param $color11
set -g fish_color_comment $color6
set -g fish_color_selection --background=$color14
set -g fish_color_search_match --background=$color14
set -g fish_color_operator $color12
set -g fish_color_escape $color6
set -g fish_color_autosuggestion $color14

# Completion Pager Colors
set -g fish_pager_color_progress $color12
set -g fish_pager_color_prefix $color13
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $color12
set -g fish_pager_color_selected_background --background=$color14

# FZF colors
export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --color fg:7,bg:0,hl:1,fg+:232,bg+:1,hl+:255
    --color info:7,prompt:2,spinner:1,pointer:232,marker:1
"

# Fix LS_COLORS being unreadable.
export LS_COLORS="$LS_COLORS:su=30;41:ow=30;42:st=30;44:"
