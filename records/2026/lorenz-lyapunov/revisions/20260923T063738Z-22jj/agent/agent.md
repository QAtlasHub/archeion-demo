# The Lorenz system: the largest Lyapunov exponent across ρ

### The Lorenz system across ρ  [id: lorenz]  [status: trial]
$\dot x = \sigma(y-x)$, $\dot y = x(\rho - z) - y$, $\dot z = xy - \beta z$ with
$\sigma = 10$ and $\beta = 8/3$. The largest Lyapunov exponent $\lambda_1$ comes from one
trajectory per $\rho$ after a warm-up, through `DynamicalModels.lyapunov_exponent`.
Where $\lambda_1 > 0$ nearby trajectories separate: the system is chaotic. The textbook
onset for these $\sigma, \beta$ is near $\rho \approx 24.74$.


#### Largest Lyapunov exponent  [id: sweep]
- [fig: sweep_fig1] λ₁ against ρ; the dashed line is λ₁ = 0
  - code: `fig`
  - asset: assets/figures/lorenz/sweep/sweep_fig1.svg

| series | x | y |
| --- | --- | --- |
| y1 | 14.0 | -0.39482806576746504 |
| y1 | 16.0 | -0.30771039388554267 |
| y1 | 18.0 | -0.22799185558640583 |
| y1 | 20.0 | -0.15455204201711514 |
| y1 | 22.0 | -0.08641389193838844 |
| y1 | 24.0 | 0.7628192501792441 |
| y1 | 24.74 | 0.8072655655087094 |
| y1 | 26.0 | 0.8568037408021609 |
| y1 | 28.0 | 0.9029252414256069 |
| y1 | 30.0 | 0.9509739887184903 |
| y1 | 35.0 | 1.044859479173399 |
| y1 | 40.0 | 1.1314122118153696 |
| y2 | 1.0 | 0.0 |
| y2 | 2.0 | 0.0 |
| y2 |  | 0.0 |

_one trajectory per ρ_  [table: sweep_tbl1]
| ρ | λ₁ | verdict |
| --- | --- | --- |
| 14.0 | -0.3948 | not chaotic |
| 16.0 | -0.3077 | not chaotic |
| 18.0 | -0.228 | not chaotic |
| 20.0 | -0.1546 | not chaotic |
| 22.0 | -0.0864 | not chaotic |
| 24.0 | 0.7628 | chaotic |
| 24.74 | 0.8073 | chaotic |
| 26.0 | 0.8568 | chaotic |
| 28.0 | 0.9029 | chaotic |
| 30.0 | 0.951 | chaotic |
| 35.0 | 1.0449 | chaotic |
| 40.0 | 1.1314 | chaotic |
