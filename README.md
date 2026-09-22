# archeion-demo

An [Archeion](https://github.com/QAtlasHub/Archeion.jl) registry: one directory per record,
each holding a `record.toml`, the rendered result, and the provenance needed to reproduce it.

`index.html` is the catalogue and is regenerated from the tree (`Archeion.reindex`); nothing
in it is edited by hand. A record directory may also hold sidecars (notes, an annotation
store, a PDF): a deposit removes only the files a previous deposit wrote.

## The registry/1 layout (draft)

`SPEC.md` defines a successor layout, under `projects/` and `records/`. It is a draft, and the
Archeion 0.3 layout above (`demo/`, `index.html`) stays until the new format has its own build.

- `records/2026/2026-09-15-logistic-map-r_4aehb2y5/` is `demo/logistic` converted by hand. Its
  `entry.toml` says what the conversion could not keep, and claims only that the report can be read.
- `julia tools/validate.jl .` checks the registry against `SPEC.md`, with the standard library only.
- `julia tools/selftest.jl` breaks copies of the registry one way at a time and requires the
  validator to catch each break.
