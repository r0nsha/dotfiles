#!/usr/bin/env fish

set remotes (jj git remote list)
set remote_count (count $remotes)

if test $remote_count = 0
    echo "No git remotes found"
    exit 1
end

if test $remote_count = 1
    set remote $remotes[1]
else
    set remote (echo $remotes | myfzf --prompt="Select remote: ")
end

set remote_url (echo $remote | string split ' ' | tail -n 1)
set bookmark (jj bookmark l -T 'name ++ "\n"' | uniq | myfzf --prompt="Select bookmark: ")

if test -z "$bookmark"
    exit 1
end

function open_pr_with_url
    set -l raw_url $argv[1]
    set -l bookmark $argv[2] # Assuming bookmark is passed as second argument

    # Remove .git suffix if present
    set raw_url (string replace --regex '\\.git$' '' $raw_url)

    # Convert SSH URL to HTTPS and detect platform
    set -l repo_url
    set -l host

    if string match --quiet --regex '^git@' $raw_url
        # Extract host and path from git@host:path
        set host (string replace --regex '^git@([^:]+):.*' '$1' $raw_url)
        set -l repo_path (string replace --regex '^git@[^:]+:(.+)$' '$1' $raw_url)
        set repo_url "https://$host/$repo_path"
    else
        # Extract host from https://host/path
        set host (string replace --regex 'https?://([^/]+).*' '$1' $raw_url)
        set repo_url $raw_url
    end

    # Construct the appropriate PR/MR URL based on the platform
    set -l pr_url

    if string match --quiet --regex gitlab $host
        # GitLab merge request URL
        set pr_url "$repo_url/-/merge_requests/new?merge_request[source_branch]=$bookmark"
    else if string match --quiet --regex '(gitea|forgejo)' $host
        # Gitea/Forgejo compare URL
        set pr_url "$repo_url/compare/$bookmark"
    else
        # Default to GitHub-style compare URL
        set pr_url "$repo_url/compare/$bookmark?expand=1"
    end

    # Open the URL using the appropriate command
    set -l open_cmd

    if test (uname) = Darwin
        set open_cmd open
    else if test (uname -o 2>/dev/null) = Msys
        set open_cmd start
    else
        set open_cmd xdg-open
    end

    # Open in background (detached)
    $open_cmd $pr_url &>/dev/null & disown

    echo "Opening PR for bookmark `$bookmark`"
end

open_pr_with_url $remote_url $bookmark
