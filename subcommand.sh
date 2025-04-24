#!/usr/bin/env bash

# Create multiple functions with a __ prefix
# and select which one to execute with the
# first parameter to the script:
#
# $ subcommand.sh foo
# doing foo
# $ subcommand.sh bar
# doing bar
# $ subcommand.sh somethingelse
# available sub-commands:
#  - bar
#  - foo

__foo() {
  echo doing foo
}

__bar() {
  echo doing bar
}

CMD=${1:-}
shift || true
if [[ $(type -t "__${CMD}") == function ]]; then
  # if subcommand exists, call it with the rest of the args
  "__${CMD}" "$@"
else
  # else, list all the available subcommands.
  echo -e "available sub-commands:\n$(declare -F | sed -n "s/declare -f __/ - /p")"
fi

