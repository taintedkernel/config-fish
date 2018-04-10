# fish config #

# clear out any existing abbreviations #
# https://fishshell.com/docs/current/commands.html#abbr
#if status --is-interactive
#    set -g fish_user_abbreviations
#end

# set PATH
# TODO: Add equivalent Linux path
set PATHS "$HOME/bin" "$HOME/Library/Python/2.7/bin"
for P in $PATHS
    if not contains "$P" $PATH
        if [ -d "$P" ]
            set PATH $PATH $P
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


### load powerline ###
# TODO: Add powerline path for Linux
set POWERLINE_PATH "$HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/fish/"
for P in $POWERLINE_PATH
    if [ -d "$P" ]
        set fish_function_path $fish_function_path $P
    end
end

type -q powerline-setup
if [ $status -eq 0 ]
    powerline-setup
end

