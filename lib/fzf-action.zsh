export FZF_ACTION_EDITOR='code'

bindkey '^gr' fzf-action-git-branches-all
bindkey '^gb' fzf-action-git-branches
bindkey '^gf' fzf-action-git-files
bindkey '^gw' fzf-action-git-worktree

# _fzf-format-worktree-entry - Format a worktree entry for display
# Arguments:
#   $1 - path: Full path to the worktree
#   $2 - branch: Branch name (empty for detached HEAD)
#   $3 - commit: Commit hash (40 characters)
# Returns:
#   Formatted string: "dirname [branch] hash|path"
# Exit codes:
#   0 - Success
function _fzf-format-worktree-entry() {
    local path="$1" branch="$2" commit="$3"
    local dir_name="${path:t}"
    local branch_display="${branch:+[$branch]}"
    branch_display="${branch_display:-[(detached)]}"
    echo "$dir_name $branch_display ${commit:0:8}|$path"
}

# fzf-action-git-worktree-get-candidates - Generate formatted worktree candidates for fzf
# Parses git worktree list --porcelain output and formats entries for display.
# Validates worktree data and skips invalid entries with warnings.
# Returns:
#   One candidate per line in format: "dirname [branch] hash|path"
# Exit codes:
#   0 - Success (at least one worktree found)
#   1 - Error (not in git repo or no worktrees)
function fzf-action-git-worktree-get-candidates() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print "Error: Not in a git repository"
        return 1
    fi

    local worktree_list="$(git worktree list --porcelain 2>/dev/null)"
    if [[ -z "$worktree_list" ]]; then
        print "Error: No worktrees found"
        return 1
    fi

    # Parse git worktree list --porcelain output
    local -a display_entries
    local current_path current_commit current_branch

    while IFS= read -r line; do
        case "$line" in
            worktree\ *)
                current_path="${line#worktree }"
                # Validate path is not empty
                if [[ -z "$current_path" ]]; then
                    print "Warning: Invalid porcelain output - empty worktree path"
                    continue
                fi
                ;;
            HEAD\ *)
                current_commit="${line#HEAD }"
                # Validate commit hash format (should be 40 hex chars)
                if [[ ! "$current_commit" =~ ^[0-9a-f]{40}$ ]]; then
                    print "Warning: Invalid commit hash format: $current_commit"
                fi
                ;;
            branch\ *)
                current_branch="${line#branch refs/heads/}"
                ;;
            "")
                # Validate we have minimum required fields before adding entry
                if [[ -n "$current_path" && -n "$current_commit" ]]; then
                    display_entries+=("$(_fzf-format-worktree-entry "$current_path" "$current_branch" "$current_commit")")
                elif [[ -n "$current_path" ]]; then
                    print "Warning: Skipping worktree with missing commit: $current_path"
                fi
                current_path=""
                current_commit=""
                current_branch=""
                ;;
        esac
    done <<< "$worktree_list"

    # Handle last entry if output doesn't end with empty line
    if [[ -n "$current_path" && -n "$current_commit" ]]; then
        display_entries+=("$(_fzf-format-worktree-entry "$current_path" "$current_branch" "$current_commit")")
    elif [[ -n "$current_path" ]]; then
        print "Warning: Skipping incomplete worktree entry: $current_path"
    fi

    printf '%s\n' "${display_entries[@]}"
}

# fzf-action-git-worktree-extract-path - Extract worktree path from formatted display string
# Arguments:
#   $1 - Formatted display string from fzf selection
# Returns:
#   The full path to the worktree (everything after the '|' delimiter)
# Exit codes:
#   0 - Success
function fzf-action-git-worktree-extract-path() {
    echo "${1##*|}"
}

# fzf-action-git-worktree-cd - Change directory to selected worktree
# ZLE widget action that generates a 'cd' command to navigate to the worktree.
# Arguments:
#   $1 - Formatted worktree entry from fzf selection
# Side effects:
#   Sets BUFFER and executes the command via zle accept-line
# Exit codes:
#   0 - Success
function fzf-action-git-worktree-cd() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"

    if [[ -d "$worktree_path" ]]; then
        BUFFER="cd ${(q)worktree_path}"
    else
        print "Error: Worktree path not found: $worktree_path"
        BUFFER=""
    fi
    zle accept-line
}

# fzf-action-git-worktree-delete - Delete selected worktree
# ZLE widget action that removes a worktree after validation.
# Validates that the worktree is not current, exists, and has no uncommitted changes.
# Arguments:
#   $1 - Formatted worktree entry from fzf selection
# Side effects:
#   Sets BUFFER with 'git worktree remove' command and executes via zle accept-line
# Exit codes:
#   0 - Success
#   1 - Validation failed
function fzf-action-git-worktree-delete() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"

    if ! _fzf-validate-worktree "$worktree_path"; then
        BUFFER=""
        zle accept-line
        return 1
    fi

    BUFFER="git worktree remove -f ${(q)worktree_path}"
    zle accept-line
}

# fzf-action-git-worktree-delete-with-branch - Delete worktree and its associated branch
# ZLE widget action that removes a worktree and deletes the branch if attached.
# For detached HEAD worktrees, only removes the worktree.
# Arguments:
#   $1 - Formatted worktree entry from fzf selection
# Side effects:
#   Sets BUFFER with git commands and executes via zle accept-line
#   Prints note if no branch to delete (detached HEAD)
# Exit codes:
#   0 - Success
#   1 - Validation failed
function fzf-action-git-worktree-delete-with-branch() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"

    if ! _fzf-validate-worktree "$worktree_path"; then
        BUFFER=""
        zle accept-line
        return 1
    fi

    local branch_name="$(git -C "$worktree_path" branch --show-current 2>/dev/null)"
    if [[ -n "$branch_name" ]]; then
        BUFFER="git worktree remove -f ${(q)worktree_path} && git branch -d ${(q)branch_name}"
    else
        # Detached HEAD or error - only remove worktree
        print "Note: No branch to delete (detached HEAD or branch already deleted)"
        BUFFER="git worktree remove -f ${(q)worktree_path}"
    fi
    zle accept-line
}

# fzf-action-git-worktree-append - Append worktree path to command buffer
# ZLE widget action that inserts the worktree path at the current cursor position.
# Arguments:
#   $1 - Formatted worktree entry from fzf selection
# Side effects:
#   Appends path to BUFFER and resets the prompt
# Exit codes:
#   0 - Success
function fzf-action-git-worktree-append() {
    local worktree_path="$(fzf-action-git-worktree-extract-path "$1")"
    BUFFER="${BUFFER}${worktree_path}"
    zle reset-prompt
}

# fzf-action-git-worktree - Main git worktree selector with fzf
# ZLE widget that displays an fzf interface for git worktree management.
# Provides multiple actions: cd, append, delete, delete-all.
# Keybinding: ^gw
# Actions:
#   cd - Change directory to worktree
#   append - Append path to command buffer
#   delete - Remove worktree (with validation)
#   delete-all - Remove worktree and delete branch
# Exit codes:
#   0 - Success (action executed)
#   1 - Error (not in repo, no worktrees, or no selection)
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

# _fzf-validate-worktree - Validate worktree before deletion
# Checks multiple conditions to ensure safe worktree removal:
# - Not the current worktree
# - Path exists
# - No uncommitted changes (modified, staged)
# - No untracked files
# Arguments:
#   $1 - worktree_path: Full path to the worktree to validate
# Exit codes:
#   0 - Validation passed (safe to delete)
#   1 - Validation failed (prints error message)
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

    # Use git status --porcelain for efficient check of all changes in one call
    local status_output="$(git -C "$worktree_path" status --porcelain 2>/dev/null)"
    if [[ -n "$status_output" ]]; then
        # Check if there are any changes (modified, staged, or untracked)
        if echo "$status_output" | grep -q '^[MADRC]'; then
            print "Error: Uncommitted changes found in worktree: $worktree_path"
            return 1
        fi
        if echo "$status_output" | grep -q '^??'; then
            print "Error: Untracked files found in worktree: $worktree_path"
            return 1
        fi
    fi

    return 0
}

zle -N fzf-action-git-worktree
