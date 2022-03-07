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

# system / core utils #
alias sf='source ~/.config/fish/conf.d/*'
alias cfc='cd ~/.config/fish/conf.d/'

alias ..='cd ..'
alias ...='cd ..; and cd ..'
alias ....='cd ..; and cd ..; and cd ..'

alias l='ls'
alias ll='ls -l'
alias llt='ls -lt'
alias lrt='ls -lrt'
alias la='ls -A'
alias lal='ls -lA'
alias lla='ls -lA'
alias lalt='ls -lAt'
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

# sudo !!
function sudo --description 'Run command using sudo (use !! for last command)'
	if test (count $argv) -gt 0
		switch $argv[1]
		case '!!'
			if test (count $argv) -gt 1
				set cmd "command sudo $history[1] $argv[2..-1]"
			else
				set cmd "command sudo $history[1]"
			end
		case '*'
			set cmd "command sudo $argv"
		end
	else
		set cmd "command sudo fish"
	end
	eval $cmd
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
# Exclude useless fs types (mostly from k8s)
alias df='df -mT -x overlay -x tmpfs'

# du with depth and defaults
function dud --description "du depth w/arg"
    if [ (count $argv) -lt 1 ]
        set depth 1
    else
        set depth $argv[1]
    end
    du -d $depth
end

# Show only useful fs types (similar to df)
alias mnt='mount -t ext4,xfs,zfs,vfat,cifs,nfs,nfs4'

# Platform/utils specific settings
# Only GNU du supports '-S' for separate-dirs
if [ (uname) = "Darwin" ]
    if [ (which du) = "/usr/local/opt/coreutils/libexec/gnubin/du" ]
        alias duds='du -S -d 1'
    end
else
    alias duds='du -S -d 1'
end

# systemctl, our favorite #
abbr -a scst 'systemctl start'
abbr -a scrs 'systemctl restart'
abbr -a scus 'systemctl status'
abbr -a scop 'systemctl stop'

# journalctl #
abbr -a jcs 'journalctl -u'
abbr -a jck 'journalctl -k'

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

# helper function to invoke ack for an expression
# will ignore lines commented out (single line #-style)
# also accepts arbitrary arguments that get passed on
function aic --description "ack ignore comments"
    if [ (count $argv) -gt 1 ]
        set split (string split -r -m1 -- " " "$argv")
        if [ $status -ne 0 ]
            echo "Unable to parse"
            return
        end
        set args $split[1]
        set pattern $split[2]
    else
        set pattern $argv
    end
    ack $args "^[^#]*$pattern"
end

# helper function to invoke ack with Go files
# and ignore the vendor folder
function aiv --description "ack ignore vendor folder"
    if [ (count $argv) -lt 1 ]
        echo "Need pattern/string to match"
        return
    end
    ack $argv --go --ignore-dir=vendor/
end

# ssh #
alias sal='eval (ssh-agent -c)'

# git #
# Use abbr instead of alias to allow tab completion
abbr -a gcl 'git clone'
abbr -a gco 'git checkout'
abbr -a gcob 'git checkout -b'
abbr -a gbr 'git branch'
abbr -a gbra 'git branch -a'
abbr -a gbrd 'git branch -d'
abbr -a gst 'git status'
abbr -a gls 'git ls-tree -r --name-only --full-name HEAD'
abbr -a glsp 'git ls-tree -r --name-only --full-name'
abbr -a gdi 'git diff'
abbr -a gdio 'git diff HEAD~1'
abbr -a gdi. 'git diff .'
abbr -a gdic 'git diff --cached'
abbr -a gdit 'git difftool'
abbr -a gdit. 'git difftool .'
abbr -a gditc 'git difftool --cached'
abbr -a ga 'git add'
abbr -a gau 'git add -u'
abbr -a gaa 'git add -A'
abbr -a glog 'git glog'
abbr -a glp 'git log -p'
abbr -a glpf 'git log -p --follow --'
abbr -a gci 'git commit'
abbr -a gcim 'git commit -m'
abbr -a gcia 'git commit --amend'
abbr -a grm 'git remote'
abbr -a grmv 'git remote -v'
abbr -a glf 'git pull --ff-only'

function gmbr --description "find git main/master default branch"
    which git >/dev/null 2>&1
    if [ $status -ne 0 ]
        return
    end
    set GIT_ROOT (git rev-parse --show-toplevel ^/dev/null)
    if [ "$GIT_ROOT" = "" ]
        return
    end
    ls "$GIT_ROOT/.git/refs/heads/main" >/dev/null 2>&1
    if [ $status -eq 0 ]
        echo "main"
    end
    ls "$GIT_ROOT/.git/refs/heads/master" >/dev/null 2>&1
    if [ $status -eq 0 ]
        echo "master"
    end
end

# This only works for aliases where the branch name can be the last argument
function git-helper
    set DEFAULT (gmbr)
    if test "$DEFAULT" = ""
        echo "unable to determine default branch"
        return
    end
    echo "git $argv[1] $DEFAULT $argv[2]" | bash
end

function gdim --description "git diff main/master"
    git-helper "diff"
end

function gcom --description "git checkout main/master"
    git-helper "checkout"
end

function glom --description "git pull origin main/master"
    git-helper "pull origin"
end

function glomf --description "git ff pull origin main/master"
    git-helper "pull origin" "--ff-only"
end

function glomr --description "git rebase pull origin main/master"
    git-helper "pull origin" "--rebase"
end

function gsom --description "git push origin main/master"
    git-helper "push origin"
end

function grbm --description "git rebase main/master"
    git-helper "rebase"
end

# TODO: Add ability to diff between previous commits rather
# then just HEAD, eg: git diff HEAD~2 HEAD~1
function gdih --description "git diff HEAD"
    which git >/dev/null 2>&1
    if [ $status -ne 0 ]
        echo "git not found!"
        return
    end
    if [ "$argv" = "" ]
        set argv "1"
    end
    git diff HEAD~$argv ^/dev/null
end

function gcr --description "change dir to git root"
    which git >/dev/null 2>&1
    if [ $status -ne 0 ]
        echo "git not found!"
        return
    end
    set GIT_ROOT (git rev-parse --show-toplevel ^/dev/null)
    if [ $status -eq 0 ]
        cd $GIT_ROOT
    else
        echo "not in a git repo!"
    end
end

# TODO: This should take arguments
function gsob --description "git push origin <current branch>"
    set GIT_BR (git rev-parse --abbrev-ref HEAD ^/dev/null)
    if [ $status -ne 0 ]
        echo "[error] unable to find git branch, aborting"
        return
    else if [ "$GIT_BR" = "HEAD" ]
        echo "[error] detached HEAD, will not push"
        return
    end
    echo -n "Pushing $GIT_BR to origin"
	if [ "$argv" != "" ]
		echo -n " (with $argv)"
	end
	echo "..."
    git push origin $GIT_BR $argv
end

function gcb --description "git cleanup branch"
    set GIT_BR (git rev-parse --abbrev-ref HEAD ^/dev/null)
    if [ $status -ne 0 ]
        echo "[error] unable to find git branch, aborting"
        return
    else if [ "$GIT_BR" = "HEAD" ]
        echo "[error] detached HEAD, will not update"
        return
    else if [ "$GIT_BR" = "master" -a "$argv" = "" ]
        echo "[error] master branch currently checked-out; cannot clean, aborting"
        return
    end
    git checkout master ;and git pull origin master --ff-only ;and git branch -d $GIT_BR
end

# Helper function to git push with temporary permissions,
# in case you don't want to leave the unlocked key in your keyring
# We could alternatively could use GIT_SSH_COMMAND
#
# Assumes there is a correct key to match ~/.ssh/id_github*
function gsomk --description "git push origin master with temporary unlocked key"
    set KEY (ls -1 $HOME/.ssh/id_github* | grep -v '\.pub')
    ssh-add -L | grep $KEY >/dev/null
    if [ $status -ne 0 ]
        ssh-add -t 600 $KEY
    end
    git push origin master
end

# vcsh #
abbr -a gstun 'git status -uno'
abbr -a vlu 'vcsh list-untracked -a'
abbr -a vlt 'vcsh list-tracked'

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

# TODO: Same as above
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
if [ -x "/usr/bin/apt" ]
    abbr -a acs 'apt search'
    abbr -a agi 'sudo apt install'
else if [ -x "/usr/bin/apt-get" ]
    abbr -a acs 'apt-cache search'
    abbr -a agi 'sudo apt-get install'
end
if [ -x "/usr/bin/yum" ]
    abbr -a ys 'sudo yum search'
    abbr -a yi 'sudo yum install'
end
if [ -x "/usr/local/bin/brew" ]
    abbr -a bi "brew install"
    abbr -a bs "brew search"
end

### non-system aliases/functions ###
# docker #
function dent --description "enter a docker container"
    set CONTAINER $argv
    docker exec -it $CONTAINER bash
end

# kubernetes #
abbr -a kc "kubectl"
abbr -a kcg "kubectl get"
abbr -a kcd "kubectl describe"
abbr -a kcr "kubectl delete"
abbr -a kca "kubectl apply"
abbr -a kcrp "kubectl delete po"
abbr -a kcrd "kubectl delete deploy"
abbr -a kcgp "kubectl get po"
abbr -a kcgs "kubectl get svc"
abbr -a kcgd "kubectl get deploy"
abbr -a kcga "kubectl get all"
abbr -a kcgi "kubectl get ingress"
abbr -a kcdp "kubectl describe po"
abbr -a kcds "kubectl describe svc"
abbr -a kcdd "kubectl describe deploy"
abbr -a kcl "kubectl logs"
abbr -a kce "kubectl edit"
abbr -a kced "kubectl edit deploy"
abbr -a kcec "kubectl edit configmap"
abbr -a kcx "kubectl exec"
abbr -a kcgpa "kubectl get po --all-namespaces"
abbr -a kcgaa "kubectl get all --all-namespaces"
abbr -a kns "kubens"
abbr -a kctx "kubectx"
abbr -a kcgc "kubectl config get-contexts"
abbr -a kcuc "kubectl config use-context"
abbr -a kcsn "kubectl config set-context --current --namespace"
abbr -a kcpn "kc_po_name"
abbr -a kcgpn "kc_get_po_by_name"
abbr -a kcln "kc_log_by_name"

# Might deprecate these since we are using actual shell completions now
# https://github.com/evanlucas/fish-kubectl-completions
function kc_po_name --description "kubernetes pod name"
    kubectl get pods -l "app=$argv" -o jsonpath="{.items[0].metadata.name}"
end

function kc_get_po_by_name --description "kubernetes get pod by name"
    kubectl get po (kc_po_name $argv)
end

function kc_log_by_name --description "kubernetes get pod by name"
    kubectl logs (kc_po_name $argv)
end

### other functions ###
function glc --description "grab a line"
    if [ "$argv" -gt 0 ]
        cat - | tail -n+$argv | head -1
    else if [ "$argv" -lt 0 ]
        cat - | tail -n$argv | head -1
    end
end

function dtp2u --description "convert time from pacific to UTC"
    set tz (date +%Z)
    echo -n "$argv $tz in UTC is "
    env TZ="UTC" date -d "TZ=\"America/Los_Angeles\" $argv"
end

function dtu2p --description "convert time from UTC to pacific"
    echo -n "$argv UTC in Pacific is "
    env TZ="America/Los_Angeles" date -d "TZ=\"UTC\" $argv"
end

