
alias ...="cd ..; and cd .."
alias ....="cd ..; and cd ..; and cd .."

alias l='ls'
alias ll='ls -l'
alias lrt='ls -lrt'

alias la='ls -A'
alias lal='ls -lA'
alias lart='ls -lArt'

alias l.='ls -d .*'

alias c='clear'
alias f='find'
alias h='history'

alias rm='rm -i'

alias t='tail'
alias tf='tail -f'
alias tF='tail -F'

alias df='df -m'
alias ds='du --max-depth=1'
alias dss='du -S --max-depth=1'

# grep #
alias g='grep'
alias gi='grep -i'
alias gr='grep -R'
alias gir='grep -iR'

alias gv='grep -v'
alias giv='grep -iv'
alias girv='grep -ivR'

# TODO: install/configure ack
alias grep='grep --color'
# export GREP_OPTIONS='--color=auto'     # deprecated

# git #
function gcr
    which git >/dev/null 2>&1
    if $status
        echo "git not found!"
        return
    end
    set GIT_ROOT (git rev-parse --show-toplevel 2>/dev/null)
    if $status
        cd $GIT_ROOT
    else
        echo "not in a git repo!"
    end
end

alias gco="git checkout"
alias gbr="git branch"
alias gst="git status"
alias gdi="git diff"
alias gdic="git diff --cached"
alias ga="git add"
alias glog="git log"
alias gci="git commit"
alias glom="git pull origin master"
alias gsom="git push origin master"
alias cgr="gcr"

# vcsh #
function vs
    which vcsh >/dev/null 2>&1
    if $status
        echo "vcsh not found!"
        return
    end
    vcsh $1 status
end

# tmux #
function tda
    tmux detach -s $argv
    tmux attach -t $argv
end

alias tns="tmux new-session -s"
alias ta="tmux attach -t"
alias td="tmux detach -s"

## distro-specific ##
# package manager #
if test -x "/usr/bin/apt-get"
    alias acs="apt-cache search"
    alias agi="sudo apt-get install"
end
if test -x "/usr/bin/yum"
    alias ys="sudo yum search"
    alias yi="sudo yum install"
end


