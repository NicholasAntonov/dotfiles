# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/hyper/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#################################################
#                options                        #
#################################################

# make cd push the old directory onto the directory stack.
setopt auto_pushd

# don't push the same dir twice.
setopt pushd_ignore_dups

# avoid "beep"ing
setopt nobeep

# use zsh style word splitting
setopt noshwordsplit

#################################################
#                exports                        #
#################################################

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR should open in terminal
export VISUAL="emacsclient -c"                  # $VISUAL opens in GUI
#export VISUAL="emacsclient -c -a emacs"        # $VISUAL opens in GUI with non-daemon as alternate

export TZ=America/New_York

export LAB="nantonov@linux-lab.cs.stevens.edu"

export NAME="Nicholas Antonov"
export EMAIL="nicholas.antonov@gmail.com"


#################################################
#                aliases                        #
#################################################

alias et="emacsclient -t"
alias ec="emacsclient -c"
alias en="emacs -nw"

alias tb="nc termbin.com 9999"
alias rec="cd ~/recordings; arecord -f dat -r 60000 -D hw:0,0"

alias info='info --vi-keys'

alias ll="ls -lh --group-directories-first --color"
alias la="ls -lha --group-directories-first --color"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias donotdisturb='killall -SIGUSR1 dunst'
alias disturb='killall -SIGUSR2 dunst'


#################################################
#                 macros                        #
#################################################

function cl {
    cd "$1"
    ls -l
}

function extract {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        if [ -f "$1" ] ; then
            NAME=${1%.*}
            #mkdir $NAME && cd $NAME
            case "$1" in
                *.tar.bz2)   tar xvjf ./"$1"    ;;
                *.tar.gz)    tar xvzf ./"$1"    ;;
                *.tar.xz)    tar xvJf ./"$1"    ;;
                *.lzma)      unlzma ./"$1"      ;;
                *.bz2)       bunzip2 ./"$1"     ;;
                *.rar)       unrar x -ad ./"$1" ;;
                *.gz)        gunzip ./"$1"      ;;
                *.tar)       tar xvf ./"$1"     ;;
                *.tbz2)      tar xvjf ./"$1"    ;;
                *.tgz)       tar xvzf ./"$1"    ;;
                *.zip)       unzip ./"$1"       ;;
                *.Z)         uncompress ./"$1"  ;;
                *.7z)        7z x ./"$1"        ;;
                *.xz)        unxz ./"$1"        ;;
                *.exe)       cabextract ./"$1"  ;;
                *)           echo "extract: '$1' - unknown archive method" ;;
            esac
        else
            echo "'$1' - file does not exist"
        fi
    fi
}


# Navigate with `up [#]`.
function up {
    local n="$1"
    if [[ -n "$n" && ! "$n" =~ ^[1-9][0-9]*$ ]]; then
        echo "positive integer expected" >&2; return 1
    fi
    cd $(yes ../ | head -$n | tr -d '\n')
}

# Create a new directory and enter it
function md() {
    mkdir -p $1 && cd $1;
}

# Determine size of a file or total size of a directory
function fs() {
	  if du -b /dev/null > /dev/null 2>&1; then
		    local arg=-sbh;
	  else
		    local arg=-sh;
	  fi
	  if [[ -n "$@" ]]; then
		    du $arg -- "$@";
	  else
		    du $arg .[^.]* ./*;
	  fi;
}

function currvol {
    pactl list |
    grep "Volume:" |
    head -n 3 |
    tail -n 1 |
    sed 's/.*\s\([0-9]\+\)\%.*/\1/'
}

function volchange {
    local n="$1"

    local current=`currvol`

    pactl -- set-sink-volume 1 $(($n + $current))%
}


#################################################
#                 antigen                       #
#################################################

DEFAULT_USER="hyper"

source ~/dotfiles/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle pip
antigen bundle npm
antigen bundle lein

antigen bundle colored-man-pages
antigen bundle colorize

antigen bundle copydir
antigen bundle copyfile
# Search google from cli
antigen bundle web-search

antigen bundle nyan

antigen bundle command-not-found

# ZSH port of Fish shell's history search feature.
antigen bundle zsh-users/zsh-history-substring-search
# nicoulaj's moar completion files for zsh
antigen bundle zsh-users/zsh-completions src
antigen bundle TBSliver/zsh-plugin-tmux-simple
antigen bundle sharat87/zsh-vim-mode
# I dont think this is currently working
antigen bundle marzocchi/zsh-notify
antigen bundle rupa/z
antigen bundle Tarrasch/zsh-bd
# Must be last bundle
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme agnoster

antigen apply

#################################################
#                 Applications                  #
#################################################

## NVM
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh" > /dev/null 2> /dev/null || true


# OPAM configuration
. /home/hyper/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

#################################################
#                 startup                       #
#################################################

