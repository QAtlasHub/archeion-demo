# archeion-demo

An [Archeion](https://github.com/QAtlasHub/Archeion.jl) registry: one directory per record,
each holding a `record.toml`, the rendered result, and the provenance needed to reproduce it.

`index.html` is the catalogue and is regenerated from the tree (`Archeion.reindex`); nothing
in it is edited by hand. A record directory may also hold sidecars (notes, an annotation
store, a PDF): a deposit removes only the files a previous deposit wrote.
