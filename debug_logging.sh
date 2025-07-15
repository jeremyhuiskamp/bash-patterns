#!/usr/bin/env bash

# This is more applicable to really large scripts, especially if
# you didn't write them.  Maybe they exit silently and you can't
# figure out why.
#
# By setting up PS4, you can get a relatively detailed trace of
# what has happened.  It's not the easiest to read, but it's much
# better than just looking at source code.
#
# References:
# https://stackoverflow.com/questions/17804007/how-to-show-line-number-when-executing-bash-script
# https://web.archive.org/web/20230401201759/https://wiki.bash-hackers.org/scripting/debuggingtips#use_shell_debug_output
#
# TODO: more example of what it looks like

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
