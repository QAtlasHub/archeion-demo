#!/usr/bin/env bash
# Reproduce this Archeion record. Generated — review before running.
set -euo pipefail
git checkout 6811af372c18c972caf95d6324bbd6b5b9afd8ae
julia --project=. -e 'using Pkg; Pkg.instantiate()'
