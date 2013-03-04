
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

#
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx node brew github python virtualenvwrapper)
export PATH=$HOME/bin:./node_modules/.bin:/usr/local/share/npm/bin:/usr/local/share/python:$PATH
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source $HOME/.alias
source $HOME/.shenv #Not copied with sync-home
source virtualenvwrapper.sh
source $ZSH/oh-my-zsh.sh
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
