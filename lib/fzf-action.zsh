export FZF_ACTION_EDITOR='code'

bindkey '^gr' fzf-action-git-branches-all
bindkey '^gb' fzf-action-git-branches
bindkey '^gf' fzf-action-git-files
bindkey '^gw' fzf-action-git-worktree

# Generate formatted worktree candidates for fzf
function fzf-action-git-worktree-get-candidates() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local worktree_list="$(git worktree list --porcelain 2>/dev/null)"
    if [[ -z "$worktree_list" ]]; then
        echo "Error: No worktrees found"
        return 1
    fi

    # Parse git worktree list --porcelain output
    local -a display_entries
    local current_path current_commit current_branch

    while IFS= read -r line; do
        case "$line" in
            worktree\ *)
                current_path="${line#worktree }"
                ;;
            HEAD\ *)
                current_commit="${line#HEAD }"
                ;;
            branch\ *)
                current_branch="${line#branch refs/heads/}"
                ;;
            "")
                if [[ -n "$current_path" ]]; then
                    local dir_name="${current_path:t}"
                    if [[ -n "$current_branch" ]]; then
                        display_entries+=("$dir_name [$current_branch] ${current_commit:0:8}|$current_path")
                    else
                        display_entries+=("$dir_name [(detached)] ${current_commit:0:8}|$current_path")
                    fi
                fi
                current_path=""
                current_commit=""
                current_branch=""
                ;;
        esac
    done <<< "$worktree_list"

    # Handle last entry if output doesn't end with empty line
    if [[ -n "$current_path" ]]; then
        local dir_name="${current_path:t}"
        if [[ -n "$current_branch" ]]; then
            display_entries+=("$dir_name [$current_branch] ${current_commit:0:8}|$current_path")
        else
            display_entries+=("$dir_name [(detached)] ${current_commit:0:8}|$current_path")
        fi
    fi

    printf '%s\n' "${display_entries[@]}"
}

# Extract worktree path from formatted display string
function fzf-action-git-worktree-extract-path() {
    echo "${1##*|}"
}

# Action: Change directory to worktree
function fzf-action-git-worktree-cd() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"

    if [[ -d "$worktree_path" ]]; then
        BUFFER="cd '$worktree_path'"
    else
        print "Error: Worktree path not found: $worktree_path"
        BUFFER=""
    fi
    zle accept-line
}

# Action: Delete worktree
function fzf-action-git-worktree-delete() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"

    if ! _fzf-validate-worktree "$worktree_path"; then
        BUFFER=""
        zle accept-line
        return 1
    fi

    BUFFER="git worktree remove -f '$worktree_path'"
    zle accept-line
}

# Action: Delete worktree and associated branch
function fzf-action-git-worktree-delete-with-branch() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"

    if ! _fzf-validate-worktree "$worktree_path"; then
        BUFFER=""
        zle accept-line
        return 1
    fi

    local branch_name="$(git -C "$worktree_path" branch --show-current 2>/dev/null)"
    if [[ -n "$branch_name" ]]; then
        BUFFER="git worktree remove -f '$worktree_path' && git branch -d '$branch_name'"
    else
        BUFFER="git worktree remove -f '$worktree_path'"
    fi
    zle accept-line
}

# Action: Append worktree path to buffer
function fzf-action-git-worktree-append() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"
    BUFFER="${BUFFER}${worktree_path}"
    zle reset-prompt
}

# Main function: Git worktree selector with fzf
function fzf-action-git-worktree() {
    local candidates="$(fzf-action-git-worktree-get-candidates 2>&1)"
    local result_code=$?

    if [[ $result_code -ne 0 ]] || [[ -z "$candidates" ]]; then
        if [[ -n "$candidates" ]]; then
            # Display error message without showing command
            print "$candidates"
            BUFFER=""
            zle accept-line
        fi
        return 1
    fi

    local -a actions=(
        fzf-action-git-worktree-cd
        fzf-action-git-worktree-append
        fzf-action-git-worktree-delete
        fzf-action-git-worktree-delete-with-branch
    )

    local -a action_descriptions=(
        "cd - Change directory to worktree"
        "append - Append path to command buffer"
        "delete - Remove worktree"
        "delete-all - Remove worktree and delete branch"
    )

    fzf-action-core "$candidates" "$(printf "%s\n" "${actions[@]}")" \
                    "$(printf "%s\n" "${action_descriptions[@]}")" 1
}

function _fzf-validate-worktree() {
    local worktree_path="$1"

    local current_worktree="$(git rev-parse --show-toplevel 2>/dev/null)"

    if [[ "$worktree_path" == "$current_worktree" ]]; then
        print "Error: Cannot delete current worktree: $worktree_path"
        return 1
    fi

    if [[ ! -d "$worktree_path" ]]; then
        print "Error: Worktree path not found: $worktree_path"
        return 1
    fi

    if ! git -C "$worktree_path" diff --quiet HEAD 2>/dev/null || ! git -C "$worktree_path" diff --quiet --cached 2>/dev/null; then
        print "Error: Uncommitted changes found in worktree: $worktree_path"
        return 1
    fi

    if [[ -n "$(git -C "$worktree_path" ls-files --others --exclude-standard 2>/dev/null)" ]]; then
        print "Error: Untracked files found in worktree: $worktree_path"
        return 1
    fi

    return 0
}

zle -N fzf-action-git-worktree
