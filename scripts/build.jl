# Build the model registry for QAtlasHub/archeion-demo.
#
# The content is deliberately generic (a logistic map and a damped oscillator): this page exists to
# show what a RECORD and a CATALOGUE look like, so nothing here should come from a study.

using Archeion, Pinax, Plots
gr()

const OUT = mktempdir()
const REG = joinpath(homedir(), "registry-demo")
const REPO = "https://github.com/QAtlasHub/archeion-demo.git"

logistic(r, x) = r * x * (1 - x)

function orbit(r; n = 60, x0 = 0.2)
    xs = Vector{Float64}(undef, n)
    x = x0
    for i in 1:n
        x = logistic(r, x)
        xs[i] = x
    end
    return xs
end

function bifurcation(; rs = range(2.5, 4.0; length = 600), skip = 300, keep = 80)
    R = Float64[]
    X = Float64[]
    for r in rs
        x = 0.2
        for _ in 1:skip
            x = logistic(r, x)
        end
        for _ in 1:keep
            x = logistic(r, x)
            push!(R, r)
            push!(X, x)
        end
    end
    return R, X
end

fig_orbits() = plot(
    [orbit(r) for r in (2.9, 3.3, 3.55, 3.9)];
    labels = ["r = 2.9" "r = 3.3" "r = 3.55" "r = 3.9"],
    xlabel = "n", ylabel = "xₙ", lw = 1.2, size = (560, 320),
)

# 48_000 points is a raster, not a vector drawing: as an SVG this figure was 6.3 MB. Pinax embeds a
# file-path figure as-is, so save a PNG and hand it the path. The two line plots stay Plots objects,
# so they keep the CSV of what they plot.
function fig_bifurcation()
    R, X = bifurcation()
    p = scatter(
        R, X; ms = 0.4, msw = 0, color = :black, legend = false,
        xlabel = "r", ylabel = "x", size = (840, 480), dpi = 140,
    )
    path = joinpath(mktempdir(), "bifurcation.png")
    savefig(p, path)
    return path
end

fig_decay() = plot(
    0:0.01:12, t -> exp(-0.35t) * cos(3t);
    xlabel = "t", ylabel = "x(t)", legend = false, lw = 1.4, size = (560, 320),
)

@pinaxsetup title = "The logistic map, as a model record"

@page :logistic "The logistic map" begin
    @desc md"""
    The map $x_{n+1} = r\,x_n(1-x_n)$ on $[0,1]$. This page exists to show what a record looks
    like: a figure carries the code that drew it and the numbers behind it, so the catalogue is
    readable by a person and by a program.
    """

    @section :orbits "Orbits" begin
        @desc md"Four orbits from $x_0 = 0.2$, through the period doubling into chaos."
        @figure fig_orbits()
        @caption "Fixed point, 2-cycle, 4-cycle, chaos"
    end

    @section :bifurcation "Bifurcation" begin
        @desc md"The attractor as $r$ sweeps $[2.5, 4]$; the accumulation point is near $r \approx 3.5699$."
        @figure fig_bifurcation()
        @caption "600 values of r, 80 iterates each after 300 discarded (a raster: 48_000 points)"
        @table [
            ["2.9", "fixed point"],
            ["3.3", "2-cycle"],
            ["3.55", "4-cycle"],
            ["3.9", "chaotic"],
        ] header = ["r", "behaviour"] caption = "Where each orbit above sits"
    end
end

@page :oscillator "A damped oscillator" begin
    @desc md"A second page, so the catalogue shows what a multi-page record looks like."
    @section :decay "Decay" begin
        @desc md"$x(t) = e^{-\gamma t}\cos(\omega t)$ with $\gamma = 0.35$, $\omega = 3$."
        @figure fig_decay()
        @caption "Envelope and carrier"
    end
end

render(; out = OUT)
# The machine face. Without it the record is a picture a program cannot read, and the registry
# dashboard counts it under "no machine face" — which is how this line came to be missing.
render(; theme = :agent, out = joinpath(OUT, "agent"))

isdir(REG) || Archeion.create_registry(REG; name = "archeion-demo", repo = REPO,
    description = "A model Archeion registry: one record, rendered by Pinax and deposited here.")

res = Archeion.deposit(
    OUT;
    project = "demo",
    source = "logistic",
    srcdir = REG,               # the registry carries the script that builds it: scripts/build.jl
    title = "The logistic map, as a model record",
    summary = "A generic record, here to show the format: figures with their data, a table, math, and a repro bundle.",
    root = REG,
    tags = ["example", "chaos"],
)
println("deposited: ", res.dir)
println("commit:    ", res.commit)
println("index:     ", res.index)
