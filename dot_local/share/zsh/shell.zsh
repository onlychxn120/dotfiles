# If not running interactively, don't do anything
[[ ! -o interactive ]] && return

# History
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
HISTFILE=~/.zsh_history
HISTSIZE=32768
SAVEHIST="${HISTSIZE}"

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache

# Colored completion
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Ensure command hashing is off for mise
unsetopt HASH_CMDS

# Readline-style input config (replaces bash readline inputrc)

# menu-select / menu-complete-backward widgets live in zsh/complist
zmodload zsh/complist

# History search with arrow keys
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[[C" forward-char
bindkey "^[[D" backward-char

# Menu completion with Tab / Shift-Tab
bindkey "^I" menu-select
bindkey "^[[Z" reverse-menu-complete

# Zsh options (equivalent of readline settings)
setopt CASE_GLOB
setopt MARK_DIRS
setopt LIST_TYPES
setopt AUTO_MENU
setopt MENU_COMPLETE
setopt GLOB_DOTS
setopt NO_LIST_BEEP
