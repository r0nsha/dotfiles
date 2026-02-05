function _tide_item_jj
    if not command -sq jj; or not jj root --quiet &>/dev/null
        return 1
    end

    set jj_status (jj log -r@ -n1 --no-graph --color always -T '
    separate(" ",
        bookmarks.map(|x| truncate_end(10, x.name(), "…")).join(" "),
        tags.map(|x| truncate_end(10, x.name(), "…")).join(" "),
        change_id.shortest(8),
        surround("\"","\"",
            if(
                description.first_line().substr(0, 20).starts_with(description.first_line()),
                description.first_line().substr(0, 20),
                description.first_line().substr(0, 19).trim() ++ "…"
            )
        ),
        if(diff.stat().total_added() > 0, label("diff added", "+" ++ diff.stat().total_added())) ++
        if(diff.stat().total_removed() > 0, label("diff removed", "-" ++ diff.stat().total_removed())),
        if(conflict, label("conflict", "(conflict)")),
        if(divergent, label("divergent", "(divergent)")),
        if(hidden, label("hidden", "(hidden)")),
    )' | string trim)
    _tide_print_item jj $tide_jj_icon' ' "$jj_status"
end
