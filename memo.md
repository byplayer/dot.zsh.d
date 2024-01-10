# zaw cheat sheet

- zaw
  - ^gz zaw
  - ^gb zaw-git-recent-all-branches
  - ^r zaw-history
  - ^gc zaw-cdr

# ansi 256 color list

```bash
for ((i = 0; i < 16; i++)); do
    for ((j = 0; j < 16; j++)); do
        hex=$(($i*16 + $j))
        printf '\e[38;5;%dm%03d\e[m ' $hex $hex
    done
    echo "";
done
```
