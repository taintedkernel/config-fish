# fish darwin GNU *utils config #

# set PATHs
if [ (uname) = "Darwin" ]
    set CORE_PATH "/usr/local/opt/coreutils/libexec/gnubin"
    set FIND_PATH "/usr/local/opt/findutils/libexec/gnubin"
    set TAR_PATH "/usr/local/opt/gnu-tar/libexec/gnubin"
    set SED_PATH "/usr/local/opt/gnu-sed/libexec/gnubin"
    set EXTRA_PATHS "/usr/local/opt/gettext/bin" "/usr/local/opt/gnu-getopt/bin"
    set UTIL_PATHS $EXTRA_PATHS $SED_PATH $TAR_PATH $FIND_PATH $CORE_PATH

    # Man is broken if we tinker with MANPATH,
    # by default it's empty
    for M in (manpath | string split ":")
        set MANPATH $M $MANPATH
    end

    # Dynamically configure missing PATHs
    for P in $UTIL_PATHS
        if not contains "$P" $PATH
            if [ -d "$P" ]
                # Give priority to new path 
                set PATH $P $PATH

                # Configure MANPATH if necessary
                if string match -q "*gnubin" $P
                    set MANPATH (string replace "gnubin" "gnuman" $P) $MANPATH
                end
            end
        end
    end

end

