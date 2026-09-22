# selftest.jl — show that validate.jl catches what SPEC.md forbids.
#
#     julia tools/selftest.jl
#
# A validator that passes a good registry proves little: this copies the registry, breaks it one way
# at a time, and requires the validator to name each break. Standard library only.

include(joinpath(@__DIR__, "validate.jl"))

const ROOT = dirname(@__DIR__)
const REC = only(readdir(joinpath(ROOT, "records", "2026"); join = true))
const REV = only(readdir(joinpath(REC, "revisions"); join = true))

failures = String[]

# Run `mutate!` on a fresh copy of the registry; require an error (or warning, or summary line)
# containing `expect`.
function case(mutate!, name, expect; where = :errors)
    tmp = mktempdir()
    for d in ("projects", "records")
        cp(joinpath(ROOT, d), joinpath(tmp, d))
    end
    rec = joinpath(tmp, relpath(REC, ROOT))
    rev = joinpath(tmp, relpath(REV, ROOT))
    mutate!(tmp, rec, rev)
    r, summary = validate(tmp)
    lines = where === :errors ? r.errors : where === :warnings ? r.warnings : summary
    hit = expect === nothing ? isempty(r.errors) : any(l -> occursin(expect, l), lines)
    println(hit ? "  pass  " : "  FAIL  ", name)
    hit || (push!(failures, name); foreach(l -> println("          ", l), vcat(r.errors, r.warnings)))
    rm(tmp; recursive = true)
end

edit!(path, from, to) = write(path, replace(read(path, String), from => to; count = 1))
entry(rev) = joinpath(rev, "entry.toml")

println("validate.jl against deliberately broken copies:")

case("the registry as committed has no errors", nothing) do root, rec, rev end

case("a changed payload byte", "does not match its sha256") do root, rec, rev
    edit!(joinpath(rev, "gallery", "index.html"), "<html", "<HTML")
end
case("a file added to a frozen revision", "not listed in SHA256SUMS") do root, rec, rev
    write(joinpath(rev, "gallery", "extra.txt"), "late")
end
case("a revision without SHA256SUMS", "the revision is incomplete") do root, rec, rev
    rm(joinpath(rev, "SHA256SUMS"))
end
case("names equal once lower-cased", "only in case") do root, rec, rev
    write(joinpath(rev, "gallery", "Index.html"), "")
end
case("a colon in a file name", "`:` in a path") do root, rec, rev
    write(joinpath(rev, "gallery", "a:b.txt"), "")
end
case("a non-ASCII file name", "outside ASCII") do root, rec, rev
    write(joinpath(rev, "gallery", "é.txt"), "")
end
case("entry.toml naming another record", "`id.record`") do root, rec, rev
    edit!(entry(rev), "record = \"r_4aehb2y5\"", "record = \"r_00000000\"")
end
case("a completion state in a revision", "not what is computed") do root, rec, rev
    open(entry(rev), "a") do io
        print(io, "\n[extra]\ncompleted = 70\n")
    end
end
case("a short commit", "40 hexadecimal") do root, rec, rev
    edit!(entry(rev), "340c965b8c3a8fab38857671a410ecfe13107c31", "340c965")
end
case("time.frozen disagreeing with the directory", "does not match the directory's time") do root, rec, rev
    edit!(entry(rev), "frozen = 2026-09-15T07:19:40Z", "frozen = 2026-09-15T07:19:41Z")
end
case("a time without Z", "has no `Z`") do root, rec, rev
    edit!(entry(rev), "frozen = 2026-09-15T07:19:40Z", "frozen = 2026-09-15T07:19:40")
end
case("a time with an offset", "offset other than Z") do root, rec, rev
    edit!(entry(rev), "frozen = 2026-09-15T07:19:40Z", "frozen = 2026-09-15T16:19:40+09:00")
end
case("a parent that is not a revision of this record", "is not another revision") do root, rec, rev
    edit!(entry(rev), "parents = []", "parents = [\"20260101T000000Z-0000\"]")
end
case("a preservation level claimed rather than earned", "earned by events") do root, rec, rev
    edit!(entry(rev), "level = \"read\"", "level = \"render\"")
end
case("one record id in two directories", "is also used by") do root, rec, rev
    cp(rec, joinpath(dirname(rec), replace(basename(rec), "logistic-map" => "copy")))
end
case("a record whose project does not exist", "is not in projects/") do root, rec, rev
    rm(joinpath(root, "projects", "p_z7ne42dt.toml"))
end

# §7.1 is checked through the summary: which revision is current.
function second_revision!(rec, rev; parent)
    new = joinpath(dirname(rev), "20260916T000000Z-2222")
    cp(rev, new)
    edit!(entry(new), "rev = \"20260915T071940Z-3ve4\"", "rev = \"20260916T000000Z-2222\"")
    edit!(entry(new), "frozen = 2026-09-15T07:19:40Z", "frozen = 2026-09-16T00:00:00Z")
    parent && edit!(entry(new), "parents = []", "parents = [\"20260915T071940Z-3ve4\"]")
    sums = joinpath(new, "SHA256SUMS")
    lines = [endswith(l, "  entry.toml") ?
             bytes2hex(open(sha256, entry(new))) * "  entry.toml" : l for l in eachline(sums)]
    write(sums, join(lines, "\n") * "\n")
end
function event!(rec, kind, rev; anchor = nothing)
    mkpath(joinpath(rec, "events"))
    a = anchor === nothing ? "" : "anchor = \"$anchor\"\n"
    write(joinpath(rec, "events", "20260917T000000Z-loc-$(String(rand('a':'h', 4))).toml"),
          "spec = \"registry/1\"\nkind = \"$kind\"\nat = 2026-09-17T00:00:00Z\n" *
          "[subject]\nrecord = \"r_4aehb2y5\"\nrev = \"$rev\"\n$a")
end

case("a revision with its parent: the child is current", "current 20260916T000000Z-2222";
     where = :summary) do root, rec, rev
    second_revision!(rec, rev; parent = true)
end
case("two revisions, neither the parent of the other: a conflict", "in conflict";
     where = :summary) do root, rec, rev
    second_revision!(rec, rev; parent = false)
end
case("the only revision yanked: the record is withdrawn", "withdrawn";
     where = :summary) do root, rec, rev
    event!(rec, "yank", "20260915T071940Z-3ve4")
end
case("a comment on an auto-numbered anchor", "local to its revision";
     where = :warnings) do root, rec, rev
    event!(rec, "comment", "20260915T071940Z-3ve4"; anchor = "orbits_fig1")
end
case("an event for a revision that does not exist", "dangling"; where = :warnings) do root, rec, rev
    event!(rec, "comment", "20991231T000000Z-zzzz")
end

# ── build.jl ──────────────────────────────────────────────────────────────────────────────────

include(joinpath(@__DIR__, "build.jl"))

println("build.jl:")

function check(name, ok)
    println(ok ? "  pass  " : "  FAIL  ", name)
    ok || push!(failures, name)
end

# Build a copy after `mutate!`; hand the site directory (or the error) to `inspect`.
function build_case(mutate!, inspect)
    tmp = mktempdir()
    for d in ("projects", "records")
        cp(joinpath(ROOT, d), joinpath(tmp, d))
    end
    mutate!(tmp, joinpath(tmp, relpath(REC, ROOT)), joinpath(tmp, relpath(REV, ROOT)))
    result = try
        build(tmp)
    catch e
        e
    end
    inspect(tmp, result)
    rm(tmp; recursive = true)
end
recpage(root) = read(joinpath(root, "_site", relpath(REC, ROOT), "index.html"), String)

build_case((root, res) -> begin
    check("builds the registry as committed", res isa NamedTuple && res.records == 1)
    check("the report is reachable from the record page",
          isfile(joinpath(root, "_site", relpath(REV, ROOT), "gallery", "index.html")))
end) do root, rec, rev end

build_case((root, res) -> begin
    page = recpage(root)
    check("a second revision becomes the current one on the record page",
          occursin("current revision 20260916T000000Z-2222", page))
    check("a comment is shown, with its HTML escaped",
          occursin("&lt;script&gt;alert(1)&lt;/script&gt;", page) && !occursin("<script>alert", page))
end) do root, rec, rev
    second_revision!(rec, rev; parent = true)
    mkpath(joinpath(rec, "events"))
    write(joinpath(rec, "events", "20260917T000000Z-loc-aaaa.toml"),
          "spec = \"registry/1\"\nkind = \"comment\"\nat = 2026-09-17T00:00:00Z\n" *
          "text = \"<script>alert(1)</script>\"\n[subject]\nrecord = \"r_4aehb2y5\"\n")
end

build_case((root, res) -> begin
    check("a yanked only revision shows the record as withdrawn",
          occursin("withdrawn", recpage(root)) &&
          occursin("<b>1</b> withdrawn", read(joinpath(root, "_site", "index.html"), String)))
end) do root, rec, rev
    event!(rec, "yank", "20260915T071940Z-3ve4")
end

build_case((root, res) -> begin
    check("an invalid registry is not built", res isa ErrorException &&
          occursin("does not validate", res.msg) && !isdir(joinpath(root, "_site")))
end) do root, rec, rev
    rm(joinpath(rev, "SHA256SUMS"))
end

build_case((root, res) -> begin
    check("a directory build.jl did not write is not replaced", res isa ErrorException &&
          occursin("refusing to replace", res.msg) && isfile(joinpath(root, "_site", "mine.txt")))
end) do root, rec, rev
    mkpath(joinpath(root, "_site"))
    write(joinpath(root, "_site", "mine.txt"), "keep")
end

let site = mktempdir()
    write(joinpath(site, "index.html"), """<a href="missing.html">x</a><img src="/abs.png">""")
    bad = broken_links(site)
    check("a broken link and an absolute link in the output are both reported",
          length(bad) == 2 && any(occursin("does not exist", b) for b in bad) &&
          any(occursin("sub-path", b) for b in bad))
    rm(site; recursive = true)
end

println(isempty(failures) ? "all cases pass" : "$(length(failures)) case(s) failed")
exit(isempty(failures) ? 0 : 1)
