# fish aliases - public
# fish implementation of my .bashrc.public
#
# Many shortcuts are set using fish's abbr functionality.
# This allows for easy editing and tab-completion.
#
# However, aliases are still used in a few locations -
# mostly where defaults are wanted to be overwritten and
# don't want to be reminded or take up space on the CLI.
#


### aliases/abbrs ###
alias sf='source ~/.config/fish/conf.d/*'

alias ..='cd ..'
alias ...='cd ..; and cd ..'
alias ....='cd ..; and cd ..; and cd ..'

alias l='ls'
alias ll='ls -l'
alias lrt='ls -lrt'
alias la='ls -A'
alias lal='ls -lA'
alias lla='ls -lA'
alias lart='ls -lArt'

# Avoid wildcard expansion errors #
# https://fishshell.com/docs/current/index.html#expand
function l. --description "ls dotfiles"
    set dots .*
    if count $dots >/dev/null
        ls -d $dots
    end
end

# If we've installed GNU coreutils and set default, configure
if [ (uname) = "Darwin" ]
    if [ (which ls) = "/usr/local/opt/coreutils/libexec/gnubin/ls" ]
        alias ls='ls --color'
    end
end

alias c='clear'
alias f='find'
alias h='history'

alias rm='rm -i'

alias less='less -R'
alias sl='less'

alias t='tail'
alias tf='tail -f'
alias tF='tail -F'

# df in MiB, du in KiB
alias df='df -m'
alias du='du -k'

alias dud='du -d 1'

# Platform/utils specific settings
# Only GNU du supports '-S' for separate-dirs
if [ (uname) = "Darwin" ]
    if [ (which du) = "/usr/local/opt/coreutils/libexec/gnubin/du" ]
        alias duds='du -S -d 1'
    end
else
    alias duds='du -S -d 1'
end

# grep #
alias grep='grep --color=auto'

alias g='grep'
alias gi='grep -i'
alias gr='grep -R'
alias gir='grep -iR'

alias gv='grep -v'
alias giv='grep -iv'
alias girv='grep -ivR'

alias gcnc="egrep -v '^\w*#|^\w*\$'"
alias gsvn="grep -v '\.svn'"
# export GREP_OPTIONS='--color=auto'     # deprecated

# ack #
# TODO: install/configure ack with config mgmt?
alias a='ack'
alias ai='ack -i'
alias aq='ack -Q'
alias aiq='ack -iQ'

alias av='ack -v'
alias aiv='ack -iv'
alias aqv='ack -Qv'
alias aiqv='ack -iQv'

# git #
function gcr --description "change dir to git root"
    which git >/dev/null ^&1
    if [ $status -ne 0 ]
        echo "git not found!"
        return
    end
    set GIT_ROOT (git rev-parse --show-toplevel 2>/dev/null)
    if [ $status -eq 0 ]
        cd $GIT_ROOT
    else
        echo "not in a git repo!"
    end
end

# Use abbr instead of alias to allow tab completion
abbr -a gco='git checkout'
abbr -a gcob='git checkout -b'
abbr -a gbr='git branch'
abbr -a gbra='git branch -a'
abbr -a gst='git status'
abbr -a gdi='git diff'
abbr -a gdic='git diff --cached'
abbr -a gdit='git difftool'
abbr -a gditc='git difftool --cached'
abbr -a ga='git add'
abbr -a gau='git add -u'
abbr -a glog='git glog'
abbr -a gci='git commit'
abbr -a gcim='git commit -m'
abbr -a grm='git remote'
abbr -a grmv='git remote -v'
abbr -a glom='git pull origin master'
abbr -a gsom='git push origin master'
#abbr -a gcr='gcr'
#abbr -a cgr='gcr'

function gsob --description "git push origin <current branch>"
    set GIT_BR (git rev-parse --abbrev-ref HEAD ^/dev/null)
    if [ $status -ne 0 ]
        echo "[error] unable to find git branch, aborting"
        return
    else if [ "$GIT_BR" = "HEAD" ]
        echo "[error] detached HEAD, will not push"
        return
    end
    echo "Pushing $GIT_BR to origin..."
    git push origin $GIT_BR
end

# Helper function to git push with temporary permissions,
# in case you don't want to leave the unlocked key in your keyring
# We could alternatively could use GIT_SSH_COMMAND
#
# Assumes there is a correct key to match ~/.ssh/id_github*
function gsomk --description "git push origin master with temporary unlocked key"
    set KEY (ls -1 $HOME/.ssh/id_github* | grep -v '\.pub')
    ssh-add $KEY
    git push origin master
    ssh-add -d $KEY
end

# vcsh #
#function vs
#    which vcsh >/dev/null ^&1
#    if test $status -ne 0
#        echo "vcsh not found!"
#        return
#    end
#    vcsh $1 status
#end

# tmux #
# TODO: Switch this to abbr, or use --wraps to existing tmux completions
function ta --description "tmux attach"
    tmux ls >/dev/null
    if [ $status -ne 0 ]
        return
    end
    if [ (tmux ls | grep -v '(attached)' | wc -l) -eq 1 ]
        tmux attach
    else if [ "$argv" = "" ]
        echo "[error] no session specified, current sessions:"
        tmux ls
    else
        tmux attach -t $argv
    end
end

function tda --description "tmux detach & attach"
    tmux ls >/dev/null
    if [ $status -ne 0 ]
        return
    end
    if [ (tmux ls | wc -l) -eq 1 ]
        tmux detach
        tmux attach
    else if [ $argv = "" ]
        echo "[error] no session specified!"
        echo "Current sessions:"
        tmux ls
    else
        tmux detach -s $argv
        tmux attach -s $argv
    end
end

alias tls='tmux ls'
alias tns='tmux new-session -s'
alias td='tmux detach -s'

## distro-specific ##
# package manager #
if [ -x "/usr/bin/apt-get" ]
    abbr -a acs='apt-cache search'
    abbr -a agi='sudo apt-get install'
end
if [ -x "/usr/bin/yum" ]
    abbr -a ys='sudo yum search'
    abbr -a yi='sudo yum install'
end
if [ -x "/usr/local/bin/brew" ]
    abbr -a bi="brew install"
    abbr -a bs="brew search"
end


### non-system aliases/functions ###

# docker #

function dent --description "enter a docker container"
    CONTAINER=$argv
    docker exec -it $CONTAINER bash
end


### other functions ###

function glc --description "grab a line"
    if [ "$argv" -gt 0 ]
        cat - | tail -n+$argv | head -1
    else if [ "$argv" -lt 0 ]
        cat - | tail -n$argv | head -1
    end
end



