#!/usr/bin/env bash

# macOS stopped updating bash at version 3 and
# slowly, that language is diverging from the
# latest bash over time.
#
# Often, it's necessary to write scripts that run
# on a developer mac *and* on a linux machine of
# some sort (prod server, build pipelines, etc).
#
# Therefore, *don't* use /bin/bash since it's
# likely to be bash v3 on macOS.
#
# *Do* install newer versions of bash, eg, with
# brew.  Put the brew bin directory on your $PATH
# before /bin.
# 
# Invoke the script with `#!/usr/bin/env bash`
# to choose the first hit from your $PATH.
#
# If colleagues have not installed a later version
# of bash, this will fall back to /bin/bash, which
# might be good, or might be confusing.

# print the version and exit non-0 if it's version 3
echo "$BASH_VERSION" | tee /dev/stderr | grep -E -v -q '^3'
