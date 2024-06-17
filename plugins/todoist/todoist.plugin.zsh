# todoist plugin

function todoist-close() {
    local task
    local todoist_ids
    task=$(todoist --color l | fzf) &&
        todoist_ids=$(echo $task | awk '{print $1;}') &&
        echo close ${task} &&
        todoist close $todoist_ids
}
