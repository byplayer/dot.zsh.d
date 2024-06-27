# todoist plugin

function todoist-close() {
    local task
    local todoist_ids
    task=$(todoist --color list | fzf) &&
        todoist_ids=$(echo $task | awk '{print $1;}') &&
        echo close ${task} &&
        todoist close $todoist_ids
}

function todoist-today-close() {
    local task
    local todoist_ids
    task=$(todoist --color list --filter '(overdue | today)' | fzf) &&
        todoist_ids=$(echo $task | awk '{print $1;}') &&
        echo close ${task} &&
        todoist close $todoist_ids
}
