#!/usr/bin/env bash

# For normal behaviour:
# $ selftesting.sh
#
# To self-test:
# $ selftesting.sh self-test
#
# Put all complicated logic in functions that have no side-effects.
# Create a `main` function that triggers any i/o required to
# feed the complicated logic and call the `main` function if no
# arguments are passed to trigger self-testing.
#
# Testing functions should exit with a non-0 code after printing
# a report, causing the script to exit.
#
# No test method should ever trigger any side-effects.
#
# Use `diff` to compare strings.

set -euo pipefail

complicated_logic() {
  local input1="$1"
  local input2="$2"

  echo "$input2->$input1"
}

__test_complicated_logic() {
  # NB: expected to fail for demo purposes:
  local expected="a->b"
  local got
  got="$(complicated_logic a b)"

  # diff is a very handy general purpose string
  # equality check tool. If there is a difference,
  # it exits non-0 and shows what the difference
  # was.
  echo comparing complicated_logic on a b
  diff -u --label expected --label got <(echo "$expected") <(echo "$got")
}

__self_test() {
  # find and run all functions beginning with __test
  declare -F | sed -n 's/declare -f //p' | grep -E '^__test' | \
    while read -r testfn; do
      "$testfn"
    done
}

main() {
  local input1="some io"
  local input2="some other io"
  complicated_logic "$input1" "$input2"
}

if [[ "${1:-}" == "self-test" ]]; then
  __self_test
else
  main "$@"
fi

