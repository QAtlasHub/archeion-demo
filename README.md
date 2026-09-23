# archeion-demo

A model registry in the `registry/1` format, whose definition is `SPEC.md` in
[Archeion.jl](https://github.com/QAtlasHub/Archeion.jl); `registry.toml` names the Archeion version
this registry is checked and built with. The content is deliberately generic — a logistic map and
a damped oscillator — so that the page shows what a record and a catalogue look like, not a study.

The catalogue is served at https://qatlashub.github.io/archeion-demo/. It is built from the tree on
every push to `master` and is never committed.

- `records/2026/logistic-map/` is one of the two records. Its first revision was converted by hand
  from the Archeion 0.3 layout; the later ones were deposited by `scripts/build.jl` through
  `.registry/bindings/logistic.toml`. The directory is named, not numbered: identity is the `uuid`
  inside `record.toml`, and `registry.toml` maps one to the other (`registry/2`, SPEC §2.1).
- `julia -m Archeion validate .` checks the registry; `julia -m Archeion build .` writes the
  catalogue to `_site/`, with relative links only, so it can be served from any directory,
  forwarded over SSH, or opened with `file://`.
- Every revision can be checked without any tool: `sha256sum -c SHA256SUMS` inside its directory.

The Archeion 0.3 layout this repository started in (`demo/`, a committed `index.html`) is in the
git history, and on the `gh-pages` branch that used to serve it.

Merge into `master` with a merge commit, not a squash: revisions name commits of this repository
as their source, and a squash drops those commits from history. `provenance/spec-v1` keeps the
ones that PR #1's squash dropped.
