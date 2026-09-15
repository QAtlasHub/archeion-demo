#!/usr/bin/env bash
# Reproduce this Archeion record. Generated — review before running.
set -euo pipefail
git checkout 340c965b8c3a8fab38857671a410ecfe13107c31
julia --project=. -e 'using Pkg; Pkg.instantiate()'
