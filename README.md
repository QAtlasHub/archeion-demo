# archeion-demo

An [Archeion](https://github.com/QAtlasHub/Archeion.jl) registry: one directory per record,
each holding a `record.toml`, the rendered result, and the provenance needed to reproduce it.

`index.html` is the catalogue and is regenerated from the tree (`Archeion.reindex`); nothing
in it is edited by hand. A record directory may also hold sidecars (notes, an annotation
store, a PDF): a deposit removes only the files a previous deposit wrote.

## The registry/1 layout (draft)

The records under `projects/` and `records/` follow `registry/1`, whose format is `SPEC.md` in
[Archeion.jl](https://github.com/QAtlasHub/Archeion.jl); `registry.toml` names the version this
registry is checked with. The Archeion 0.3 layout above (`demo/`, `index.html`) stays until the
Pages site is switched to the new build.

- `records/2026/2026-09-15-logistic-map-r_4aehb2y5/` is `demo/logistic`: its first revision was
  converted by hand, and the later ones were deposited by `scripts/build.jl` through
  `.registry/bindings/logistic.toml`.
- `julia -m Archeion validate .` checks the registry; `julia -m Archeion build .` writes the
  catalogue to `_site/` (not committed), with relative links only, so it can be served from any
  directory, forwarded over SSH, or opened with `file://`.
