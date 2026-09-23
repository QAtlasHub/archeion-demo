# Compute, report and deposit the Lorenz record: the largest Lyapunov exponent as ρ is swept
# through the onset of chaos.
#
#     julia --project=<env> scripts/lorenz.jl
#
# The physics is DynamicalModels.jl's (a public package, sotashimozono/DynamicalModels.jl); this
# study exists so the catalogue holds a record whose numbers a real package produced, from a sweep
# stored in a DataVault, read once and hashed by Pinax, and deposited with the table of what was
# read. `<env>` needs ParamIO, DataVault, SweepRunner, Pinax, Plots, Archeion and DynamicalModels.

using ParamIO, DataVault, SweepRunner, Pinax, Plots, Archeion
using DynamicalModels
ENV["GKSwstype"] = "100"
gr()

const REPO = dirname(@__DIR__)
const STUDY = joinpath(REPO, "study", "lorenz")
const CONFIG = joinpath(STUDY, "config.toml")
const BINDING = joinpath(REPO, ".registry", "bindings", "lorenz.toml")
const TITLE = "The Lorenz system: the largest Lyapunov exponent across ρ"

# One parameter point: the largest Lyapunov exponent at this ρ, from the same starting state.
function work(key)
    rho = key.params["model.rho"]
    model = Lorenz(; σ=10.0, ρ=rho, β=8 / 3)
    λ = lyapunov_exponent(model, [1.0, 1.0, 1.0], 0.1; warmup=2000, n_iterations=6000)
    return Dict{String,Any}("rho" => rho, "lambda_max" => λ)
end

function recipe(pairs)
    d = sort([p[2] for p in pairs]; by=x -> x["rho"])
    rhos = [x["rho"] for x in d]
    lam = [x["lambda_max"] for x in d]
    fig = plot(
        rhos,
        lam;
        marker=:circle,
        ms=3,
        lw=1.4,
        legend=false,
        xlabel="ρ",
        ylabel="λ₁",
        size=(640, 340),
    )
    hline!(fig, [0.0]; ls=:dash, lw=1, color=:black)
    @page :lorenz "The Lorenz system across ρ" status = :trial begin
        @desc md"""
        $\dot x = \sigma(y-x)$, $\dot y = x(\rho - z) - y$, $\dot z = xy - \beta z$ with
        $\sigma = 10$ and $\beta = 8/3$. The largest Lyapunov exponent $\lambda_1$ comes from one
        trajectory per $\rho$ after a warm-up, through `DynamicalModels.lyapunov_exponent`.
        Where $\lambda_1 > 0$ nearby trajectories separate: the system is chaotic. The textbook
        onset for these $\sigma, \beta$ is near $\rho \approx 24.74$.
        """
        @section :sweep "Largest Lyapunov exponent" begin
            @figure fig caption = "λ₁ against ρ; the dashed line is λ₁ = 0"
            @table [
                [string(r), string(round(l; digits=4)), l > 0 ? "chaotic" : "not chaotic"] for
                (r, l) in zip(rhos, lam)
            ] header = ["ρ", "λ₁", "verdict"] caption = "one trajectory per ρ"
        end
    end
    return nothing
end

function main()
    vault = DataVault.Vault(CONFIG; run="sweep", outdir=joinpath(STUDY, "out"))
    keys = ParamIO.expand(ParamIO.load(CONFIG))
    res = SweepRunner.run!(work, vault, keys; opts=RunOpts(; workers=:sequential))
    @info "swept" computed = res.done skipped = res.skipped failed = res.err
    published = Archeion.publish(
        vault,
        recipe;
        binding=BINDING,
        title=TITLE,
        out=joinpath(STUDY, "out", "report", "lorenz"),
        status=:trial,
        source_repo=REPO,
        study="sweep",
        tags=["example", "chaos", "lyapunov", "DynamicalModels.jl"],
        question="Where does the Lorenz system become chaotic as ρ is raised?",
        remote=:local,
    )
    @info "published" points = published.n record = published.record revision = published.rev
    return nothing
end

isinteractive() || main()
