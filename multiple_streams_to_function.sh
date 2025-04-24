#!/usr/bin/env bash

set -euo pipefail

# suppose you have a function that needs to do this:
# - read from two apis (or files)
# - process each result in some pipeline
# - combine the result in some way and print it out
hard_to_test() {
  # Ignore that these are trivial pipelines processing the same url.
  # Imagine that they're different urls, and have more complex processing.
  local foo
  foo="$(curl 'https://httpbun.com/get?foo=bar' | jq -r .args.foo)"

  local qux
  qux="$(curl 'https://httpbun.com/get?qux=baz' | jq -r .args.qux)"

  echo "$foo / $qux"
}

# This is hard to test because you probably don't control
# the content of the url being requested.
# If you were just processing one stream, you could pipe it
# into the function, but we don't have two stdins.
#
# Instead, open new file descriptors and have the function
# read them:
easier_to_test() {
  local foo
  foo="$(<&3 jq -r .args.foo)"

  local qux
  qux="$(<&4 jq -r .args.qux)"

  echo "$foo / $qux"
}

# To call this in a test, send some hardcoded data:
__test_two_streams() {
  local got

  # NB: do it in a sub-shell, so that we don't collide
  # numbers 3 and 4 with other things, and so that they
  # get closed again immediately.
  got="$(
    exec 3<<< '{
        "args": {
          "foo": "bar"
        }
      }'
    exec 4<<< '{
        "args": {
          "qux": "baz"
        }
      }'
    easier_to_test
  )"

  local expected="bar / baz xxx intentional failure"
  diff -u -L exp -L got <(echo "$expected") <(echo "$got")
}

# And you can call it similarly from your real code:
main() {
  (
    exec 3< <(curl -sS 'https://httpbun.com/get?foo=bar')
    exec 4< <(curl -sS 'https://httpbun.com/get?qux=baz')
    easier_to_test
  )
}

# Disadvantages
# - it's unconventional and a bit difficult to read
# - commands feeding into the streams run in the background
#   and therefore failures are hard to detect
#
# Alternatives
# - as a function argument, pass in a command to eval to
#   produce each stream of data
#   - pretty obscure, bash is not a functional programming language
# - pipe one stream to stdin, only open a new fd for subsequent streams
# - read all the data into variables and pass to the function in memory
#   - this is probably most realistic, unless you have too much data

if [[ "${1:-}" == "self-test" ]]; then
  __test_two_streams
else
  main "$@"
fi

