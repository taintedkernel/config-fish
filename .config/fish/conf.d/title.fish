function fish_title
    set -q argv[1]; or set argv fish
    if test $argv = "fish"
        echo -n (whoami)@(prompt_hostname):(prompt_pwd)
    else
        echo -n $argv (whoami)@(prompt_hostname)
    end
end
