# fish config #

# set PATH
set PATHS "$HOME/bin" "$HOME/Library/Python/2.7/bin"
for p in $PATHS
    if not contains "$p" $PATH
        if [ -d "$p" ]
            set PATH $PATH $p
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

# unfuck BSD defaults #
set -x BLOCKSIZE 1024

### load powerline ###
set fish_function_path $fish_function_path "$HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/fish/"
powerline-setup

