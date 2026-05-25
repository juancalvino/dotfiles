# Keep zsh cache files out of $HOME
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-${ZSH_VERSION}"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias oc=opencode

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/juanmanuelcalvino/.bun/_bun" ] && source "/Users/juanmanuelcalvino/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

zsh_keychain_export() {
  local var_name="$1"
  local service_name="$2"
  local secret_value

  secret_value="$(security find-generic-password -a "$USER" -s "$service_name" -w 2>/dev/null)" || return 0
  export "$var_name=$secret_value"
}

zsh_keychain_export GITLAB_OAUTH_CLIENT_ID "dev/zsh/gitlab/oauth-client-id"
zsh_keychain_export GITLAB_OAUTH_CLIENT_SECRET "dev/zsh/gitlab/oauth-client-secret"
zsh_keychain_export NPM_TOKEN "dev/zsh/gitlab/npm-token"
unset -f zsh_keychain_export

# Added by Antigravity
export PATH="/Users/juanmanuelcalvino/.antigravity/antigravity/bin:$PATH"

opencode_launcher() {
  local project_path="$1"
  local agent="$2"
  shift 2

  if [[ $# -gt 0 ]]; then
    opencode "$project_path" --agent "$agent" --prompt "$*"
  else
    opencode "$project_path" --agent "$agent"
  fi
}

vulcan_resolve_project_path() {
  local root="$HOME/Dev/vulcan"
  local project="$1"

  typeset -A vulcan_aliases
  vulcan_aliases=(
    rendering-engine "backend/rendering-engine-worker"
    rendering-engine-worker "backend/rendering-engine-worker"
    ruling-engine "backend/ruling-engine"
  )

  if [[ -n "${vulcan_aliases[$project]}" && -d "$root/${vulcan_aliases[$project]}" ]]; then
    print -r -- "$root/${vulcan_aliases[$project]}"
    return 0
  fi

  if [[ -d "$root/$project" ]]; then
    print -r -- "$root/$project"
    return 0
  fi

  local matches=("$root"/*/"$project"(N/))
  if (( ${#matches[@]} == 1 )); then
    print -r -- "$matches[1]"
    return 0
  fi

  return 1
}

professor() {
  opencode_launcher "$HOME/Agents/Professor" professor "$@"
}

agents() {
  local project_path="$HOME/Agents"

  builtin cd "$project_path" || return
  opencode_launcher "$project_path" gentle-orchestrator "$@"
}

legales() {
  opencode_launcher "$HOME/Agents/Legales" legales "$@"
}

president() {
  opencode_launcher "$HOME/Agents/President" president "$@"
}

vulcan() {
  local root="$HOME/Dev/vulcan"
  local target_path="$root"
  local project_candidate=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -p|--project)
        shift
        project_candidate="$1"
        if [[ -z "$project_candidate" ]]; then
          print -u2 -- "vulcan: faltó el nombre del proyecto para -p|--project"
          return 1
        fi
        shift
        ;;
      *)
        break
        ;;
    esac
  done

  if [[ -n "$project_candidate" ]]; then
    local resolved_path
    resolved_path="$(vulcan_resolve_project_path "$project_candidate")"

    if [[ -z "$resolved_path" ]]; then
      print -u2 -- "vulcan: proyecto no encontrado: $project_candidate"
      return 1
    fi

    target_path="$resolved_path"
  fi

  opencode_launcher "$target_path" gentle-orchestrator "$@"
}

