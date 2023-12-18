# Check for changes or updates to mr/vcsh repositories

set MR (which mr)
if [ "$status" = 0 -a -x "$MR" -a -f "$HOME/.mrconfig" -a (isatty) ]
    cd && mr status 2>/dev/null | awk 'BEGIN { repo = "" }
        /mr status:/ { if (count > 0) changes[repo] = count; repo = $3; count = 0; }
        / M / { count++ }
        END { if (length(changes) > 0) { print "Repositories with changes:";\
        for (repo in changes) { print " - " repo } } print "" }'
end
