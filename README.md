# Installation

```bash
git clone https://github.com/LouisJalouzot/.zsh.git ~/.zsh
ln -s ~/.zsh/.zshrc ~/.zshrc
ln -s ~/.zsh/.tmux.conf ~/.tmux.conf
source ~/.zshrc
```

## Plugins

This setup uses a minimal unplugged loader that clones plugins into `~/.zsh/plugins`.

- zsh-autosuggestions
	- Shows ghost-text suggestions based on history as you type.
	- Accept suggestion: Right Arrow or End. Dismiss: Ctrl+C or keep typing.

- History Substring Search
	- Type a substring and navigate matching history entries with:
		- Alt+Up: previous match
		- Alt+Down: next match

- z (directory jumping via frequency)
	- Jump to frequently/recently used directories by partial name:
		- `z foo` → cd to the most frequent directory matching “foo”.
		- `z foo bar` → match both “foo” and “bar” in path segments.
		- `z -l foo` → list matches and their scores without cd.
		- `z -t foo` → prefer most recently accessed matches.
		- `z -r foo` → prefer most frequently accessed matches.

## Notes

- To update or force a clean re-install of all plugins:

    ```bash
    rm -rf ~/.zsh/plugins
    source ~/.zshrc
    ```