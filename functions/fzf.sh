#!/usr/bin/env bash
# Must be sourced, not executed
# This one still has a couple quirks i'm figuring out

shopt -s extglob  # enable extended globbing

# Commands that should launch files directly
fzf_launch_pattern="nano|vim|less|cat|more"

_generate_fzf_candidates() {
    local token="$1"
    local dir_prefix base

    # Remove leading './' for searching
    [[ "$token" == ./* ]] && token="${token#./}"

    # Determine directory and base
    if [[ "$token" == */* ]]; then
        dir_prefix="${token%/*}"
        dir_prefix="${dir_prefix:-.}"
        base="${token##*/}"
    else
        dir_prefix="."
        base="$token"
    fi

    # Files & directories
    find "$dir_prefix" -mindepth 1 2>/dev/null | while read -r f; do
        rel="${f#$dir_prefix/}"  # strip prefix for display
        if [[ "$rel" == "$base"* ]]; then
            echo "$f:::${rel}"
        fi
    done

    # Commands
    compgen -c "$base" | sed "s|\(.*\)|\1::\1|"
    compgen -b "$base" | sed "s|\(.*\)|\1::\1|"
    compgen -a "$base" | sed "s|\(.*\)|\1::\1|"
    compgen -A function "$base" | sed "s|\(.*\)|\1::\1|"
    compgen -v "$base" | sed "s|\(.*\)|\$\1::\$\1|"
}

fzf_menu_complete() {
    local cur_word token_for_fzf selected
    local line_prefix line_suffix replacement
    local full_path first_token existing_args files_to_open

    # Capture current line and cursor
    line_prefix="${READLINE_LINE:0:READLINE_POINT}"
    line_suffix="${READLINE_LINE:READLINE_POINT}"

    # First token is command
    first_token="${READLINE_LINE%% *}"

    # Everything after first token (trim leading spaces)
    existing_args="${READLINE_LINE#"$first_token"}"
    existing_args="${existing_args#"${existing_args%%[![:space:]]*}"}"

    # Current token under cursor
    cur_word="${line_prefix##* }"
    token_for_fzf="$cur_word"
    [[ "$token_for_fzf" == ./* ]] && token_for_fzf="${token_for_fzf#./}"

    # Call FZF with multi-selection
    selected=$(_generate_fzf_candidates "$token_for_fzf" | \
        fzf --height 40% --reverse --prompt="fzf> " --exact \
            --query="$token_for_fzf" --multi --with-nth=2 --delimiter=":::") || return

    [[ -z $selected ]] && return

    # Initialize
    replacement=""
    files_to_open=()

    while IFS= read -r line; do
        full_path="${line%%:::*}"

        # Append / if directory
        [[ -d "$full_path" ]] && full_path="${full_path}/"

        # Prepend './' if relative to PWD
        if [[ "$full_path" != /* && "$full_path" != ./* ]]; then
            [[ -e "$PWD/$full_path" ]] && full_path="./$full_path"
        fi

        # Add to launch array if command matches pattern
        if [[ "$first_token" == @($fzf_launch_pattern) ]]; then
            files_to_open+=("$full_path")
        else
            replacement+="$full_path "
        fi
    done <<< "$selected"

    # Launch command if applicable
    if [[ ${#files_to_open[@]} -gt 0 ]]; then
        cmd_line="$first_token $existing_args ${files_to_open[*]}"
        history -s "$cmd_line"
        history -a

        READLINE_LINE=""
        READLINE_POINT=0
        "$first_token" $existing_args "${files_to_open[@]}"
        return
    fi

    # Otherwise, replace current token at cursor
    line_prefix="${line_prefix%$cur_word}"
    READLINE_LINE="${line_prefix}${replacement}${line_suffix}"
    READLINE_POINT=$(( ${#line_prefix} + ${#replacement} ))
}
bind -x '"\e[Z": fzf_menu_complete' # bind to shift+tab
