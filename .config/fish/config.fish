# fish config #

# clear out any existing abbreviations #
# https://fishshell.com/docs/current/commands.html#abbr
#if status --is-interactive
#    set -g fish_user_abbreviations
#end

# set PATH
# TODO: Add Linux Python path
# TODO: Set /usr/local/ as higher priority, necessary for OS/X homebrew and pip
set PATHS "$HOME/bin" "$HOME/.local/bin" "$HOME/Library/Python/2.7/bin" "$HOME/Library/Python/3.6/bin" "$HOME/Library/Python/3.7/bin" "/snap/bin"
for P in $PATHS
    if not contains "$P" $PATH
        if [ -d "$P" ]
            set PATH $PATH $P
        end
    end
end

# add higher-priority PATHs
# Necessary due to very odd protobuf/grpc issue
set PATHS "$HOME/sandbox/go/bin"
for P in $PATHS
    if not contains "$P" $PATH
        if [ -d "$P" ]
            set PATH $P $PATH
        end
    end
end

#### environment variables ###
# set TERM
if [ "$TERM" = "xterm" -o "$COLORTERM" = "gnome-terminal" ]
    set -x TERM xterm-256color
end

# editor
set -x EDITOR vim

# unfuck POSIX/BSD defaults #
set -x BLOCKSIZE 1024

# force SHELL
if [ -x "/usr/bin/fish" ]
    set -xg SHELL /usr/bin/fish
end
if [ -x "/usr/local/bin/fish" ]
    set -xg SHELL /usr/local/bin/fish
end

#
# load virtualfish #
# http://virtualfish.readthedocs.io/en/latest/index.html
#
# located here instead of in conf.d due to
# requirement of invoking after PATH modifications
#
eval (python -m virtualfish ^/dev/null)

# disable automatic setting of fish_prompt in virtualenv, powerline handles this
set -xg VIRTUAL_ENV_DISABLE_PROMPT true

# load powerline #
# give priority to python 3.x and exit early
set POWERLINE_BASES "$HOME/.local/lib/python3.8/" "$HOME/Library/Python/3.7/lib/python/" "$HOME/.local/lib/python2.7/" "$HOME/Library/Python/2.7/lib/python/"
set PL_FISH "site-packages/powerline/bindings/fish/"

for P in $POWERLINE_BASES
    set POWERLINE_PATH "$P/$PL_FISH"
    if [ -d "$POWERLINE_PATH" ]
        set fish_function_path $fish_function_path $POWERLINE_PATH
        break
    end
end

pgrep -f powerline-daemon >/dev/null
if [ $status -ne 0 ]
    powerline-daemon -q &
end

type -q powerline-setup
if [ $status -eq 0 ]
    powerline-setup
end

