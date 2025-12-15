#!/bin/zsh
# TODO: switch to https://github.com/starship/starship

# Zsh config directory (same location as this file)
ZDOTDIR="${${(%):-%N}:A:h}"

# Plugin directory
[[ ! -d "${ZDOTDIR}/plugins" ]] && mkdir -p "${ZDOTDIR}/plugins"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme"
fi

# Source zsh_unplugged
source "${ZDOTDIR}/.zsh_unplugged"

# Plugins list
repos=(
  "romkatv/powerlevel10k"
  # "axieax/zsh-starship"
  "zdharma-continuum/fast-syntax-highlighting"
  "zsh-users/zsh-history-substring-search"
  "zsh-users/zsh-autosuggestions"
)

# Load plugins
plugin-load $repos

# zsh-history-substring-search configuration
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Load Environment Modules if available
[[ -s "/usr/share/Modules/init/zsh" ]] && source /usr/share/Modules/init/zsh

# Source API keys if available
[[ -f "${HOME}/.api_keys" ]] && source "${HOME}/.api_keys"

# Set WORDCHARS to exclude "/"
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|`@'

# Bind keys for history substring search
bindkey "^[[1;3A" history-substring-search-up # Alt+Up
bindkey "^[[1;3B" history-substring-search-down # Alt+Down

# Key bindings
bindkey '^H' backward-kill-word # Ctrl+Backspace
bindkey '^[[3;5~' kill-word # Ctrl+Delete
bindkey '^[[1;3C' forward-word # Ctrl+Right
bindkey '^[[1;3D' backward-word # Ctrl+Left
bindkey '^[[1;5C' forward-word # Ctrl+Right
bindkey '^[[1;5D' backward-word # Ctrl+Left

# Custom aliases
alias t=tmux
alias ta="tmux attach"
alias tl="tmux ls"
alias sm="squeue --me"
alias wsync="wandb sync --sync-all"
alias ll="ls -laFh --color=auto"
alias c=clear
alias restart-plasmashell="systemctl --user restart plasma-plasmashell"
alias rebuild="sudo sh -c 'nixos-rebuild switch |& nom'"
alias rebuildU="sudo sh -c 'nixos-rebuild switch --upgrade |& nom'"
alias gc="sudo sh -c 'nix-collect-garbage --delete-older-than 7d |& nom'"

# Mounts for local machine
alias mount-robust="sshfs -o follow_symlinks,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3"
alias mount-unicog="mount-robust unicog:/data/ljalouzot ~/data/unicog"
alias mount-jz="mount-robust jz-karavela:/linkhome/rech/genscp01/uml34gj ~/data/jz"
alias mount-coml="mount-robust oberon:/scratch2/ljalouzot ~/data/coml"
alias mount-nautilus="mount-robust nautilus:/neurospin/tmp/ljalouzot ~/data/nautilus"

# JZ specific config
if [[ "$(whoami)" == "uml34gj" ]]; then
  export UV_HTTP_TIMEOUT=36000
  export TRANSFORMERS_OFFLINE=1 # job will try to fetch from cache instead of trying to download

  # Switch between projects (ex switch ioj)
  switch() {
    if [ -z "$1" ]; then
      echo "Usage: switch <environment_name>"
      return 1
    fi
    eval $(idrenv -d $1)
  }

  # Set default SLURM default options
  export SBATCH_ACCOUNT=ioj@cpu
  export SLURM_ACCOUNT=ioj@cpu
  export SBATCH_CPUS_PER_TASK=2
  export SLURM_CPUS_PER_TASK=2
  export SBATCH_PARTITION=cpu_p1,prepost,visu,compil,compil_h100
  export SLURM_PARTITION=cpu_p1,prepost,visu,compil,compil_h100
  export SBATCH_HINT=nomultithread
  export SLURM_HINT=nomultithread
  export SBATCH_TIMELIMIT=2:00:00
  export SLURM_TIMELIMIT=2:00:00

  # Aliases for running interactive jobs
  function run_cpu() {
    srun --qos=qos_cpu-dev "$@" -D "$(pwd)" --pty zsh -i
  }
  alias run_h100="srun --gres=gpu:1 --constraint=h100 --cpus-per-task=24 --account=ioj@h100 --partition=gpu_p6 --qos=qos_gpu_h100-dev --time=2:00:00 -D \$(pwd) --pty zsh -i"
fi

# Custom functions
function check_and_handle_venv() {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    if [[ -d ./.venv ]]; then
      echo "📦 Activating virtual environment in $(pwd)/.venv"
      . .venv/bin/activate
    fi
  else
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]]; then
      echo "🔌 Deactivating virtual environment from $VIRTUAL_ENV"
      deactivate
    fi
  fi
}

# Check for virtual environment at login
check_and_handle_venv

# Overload cd to check for virtual environment changes
function cd() {
  builtin cd "$@"
  check_and_handle_venv
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
