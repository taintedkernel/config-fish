# fish aliases - public
# fish implementation of my .bashrc.public

### aliases ###
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

alias l.='ls -d .*'

alias c='clear'
alias f='find'
alias h='history'

alias rm='rm -i'

alias sl='less -R'
alias less='less -R'

alias t='tail'
alias tf='tail -f'
alias tF='tail -F'

alias df='df -m'
alias ds='du -k --max-depth=1'
alias dss='du -Sk --max-depth=1'

# grep #
alias g='grep'
alias gi='grep -i'
alias gr='grep -R'
alias gir='grep -iR'

alias gv='grep -v'
alias giv='grep -iv'
alias girv='grep -ivR'

alias gcnc="egrep -v '^\w*#|^\w*\$'"
alias gsvn="grep -v '\.svn'"

alias grep='grep --color'
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

# Platform-specific stuff #
if [ (uname) = "Darwin" ]
    # If using BSD, change defaults from GNU
    if [ (which du) = "/usr/local/opt/coreutils/libexec/gnubin/du" ]
        alias du='du -k'
        alias ds='du -k -d 1'
        functions -e dss
    end

    # If we've installed GNU coreutils with brew, configure
    # This requires PATH to be modified to set coreutils to default 'ls'
    # TODO: Detect brew coreutils, findutils, etc & configure PATH/MANPATH automatically
    if [ (which ls) = "/usr/local/opt/coreutils/libexec/gnubin/ls" ]
        alias ls='ls --color'
    end
end

# git #
function gcr
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

alias gco='git checkout'
alias gbr='git branch'
alias gbra='git branch -a'
alias gst='git status'
alias gdi='git diff'
alias gdic='git diff --cached'
alias gdit='git diftool'
alias gditc='git diftool --cached'
alias ga='git add'
alias gau='git add -u'
alias glog='git glog'
alias gci='git commit'
alias gcim='git commit -m'
alias grm='git remote'
alias grmv='git remote -v'
alias glom='git pull origin master'
alias gsom='git push origin master'
alias gcr='gcr'
alias cgr='gcr'

# Helper function to git push with temporary permissions,
# in case you don't want to leave the unlocked key in your keyring
function gsomv
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
function ta
    tmux ls >/dev/null
    if [ $status -ne 0 ]
        return
    end
    if [ (tmux ls | wc -l) -eq 1 ]
        tmux attach
    else if [ $argv = "" ]
        echo "[error] no session specified!"
        echo "Current sessions:"
        tmux ls
    else
        tmux attach -t $argv
    end
end

function tda
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
    alias acs='apt-cache search'
    alias agi='sudo apt-get install'
end
if [ -x "/usr/bin/yum" ]
    alias ys='sudo yum search'
    alias yi='sudo yum install'
end


### other environment variables ###
# set TERM
if [ $TERM = "xterm" -o $COLORTERM = "gnome-terminal" ]
    set -x TERM xterm-256color
end

# add $HOME/bin to PATH
# http://stackoverflow.com/questions/1396066/detect-if-users-path-has-a-specific-directory-in-it
if not contains $HOME/bin $PATH
    set PATH $HOME/bin $PATH
end

# editor
set -x EDITOR vim


# unfuck BSD defaults #
set -x BLOCKSIZE 1024
