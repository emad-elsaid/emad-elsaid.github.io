During working in the terminal I would like to search all files in the current directory for a string. a command like `ag` or `ripgrip` or even `grep` can do that. 

The problem is that if I want to extend the search string I have to run the command again. 

If I combined `fzf` (fuzzy selector) with `ag` so that everytime I type it restarts `ag` and searches again. I would get an interactive search that always restarts while typing. 

I also managed to select one of the result and open it in my editor. so the end result allows me to search quickly for anything in my home directory and open the match in my editor at the correct line and column.

```shell
fzf --bind "change:reload:ag --color-line-number --color-match --column {q} || true" --ansi | awk -F ':' '{ print "+" $2 ":" $3, $1 }' | xargs $EDITOR
```

I have `awk` converting the `filepath:line:col` format to emacs format `+line:col filepath`. if your editor doesn't need that you can remove it.

I also attached that to Hydra `space+/` so instead of typing the script name I can press `space+/`, search, enter to jump to the match in my editor. it's surprisingly fast

```csv
/,Search,fzf --bind "change:reload:ag --color-line-number --color-match --column {q} || true" --ansi | awk -F ':' '{ print "+" $2 ":" $3, $1 }' | xargs $EDITOR
```