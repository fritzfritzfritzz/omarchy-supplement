#!/bin/bash

# Install Hunk diff reviewer for agent-authored changesets.
# The npm package is hunkdiff; the installed CLI is `hunk`.
if ! command -v npm &>/dev/null; then
  echo "npm is not installed. Install Node.js first, then rerun this script."
  exit 1
fi

npm install -g hunkdiff
