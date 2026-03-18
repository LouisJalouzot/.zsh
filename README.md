# Installation

```bash
chsh -s $(which zsh)
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

### Tmux Configuration

The `.tmux.conf` is symlinked to `~/.tmux.conf`. TPM discovers and installs plugins from the standard config locations (`~/.tmux.conf` or `$XDG_CONFIG_HOME/tmux/tmux.conf`), so this symlink ensures plugins are properly initialized on startup.

### Prompt Customization

This setup uses **Powerlevel10k** with a dynamic background color based on the machine's hostname. This helps in visually identifying which machine you are currently logged into.

- **Automatic Hashing**: Most hostnames will automatically generate a unique, consistent color.
- **Manual Overrides**: You can force specific colors for certain machines by editing the `case` statement at the top of the anonymous function in [.p10k.zsh](.p10k.zsh#L29).
- **Current Overrides**:
    - `p14sg6`: Uses default Powerlevel10k colors.
