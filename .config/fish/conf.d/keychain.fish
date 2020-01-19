# load SSH keys

# $SHELL needs to be set first, somehow not preserved from config.fish
if [ -x "/usr/bin/fish" ]
    set -x SHELL /usr/bin/fish
end
if [ -x "/usr/local/bin/fish" ]
    set -x SHELL /usr/local/bin/fish
end

if [ -x "/usr/bin/keychain" ]
    eval (keychain --eval --ignore-missing --inherit any --agents ssh id_eternal_rigel id_github id_unity id_github_personal_at_work)
end


