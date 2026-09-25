# Kondo screening in the symmetric Anderson model: NRG thermodynamics across U/Γ

### Kondo screening across U/Γ  [id: kondo]  [status: trial]
Symmetric Anderson model ($\varepsilon_d = -U/2$, flat band of half-width $D = 1$,
$\Gamma = 0.03$) solved by `WilsonNRG.thermodynamics`: Wilson's logarithmic
discretization with $\Lambda = 2$, U(1)×U(1) symmetry, an energy cut of 6 and 18 chain
sites, one run per $U/\Gamma$. Impurity quantities are the two-run difference (full minus
bath), as in Krishna-murthy, Wilkins & Wilson (1980).

**Scope.** One discretization, one truncation, one chain length. The lowest temperature
reached is set by the chain length, so the largest $U/\Gamma$ may not be screened within it.
Nothing here is z-averaged, and nothing is converged in $\Lambda$ or in the cut.


#### Entropy and susceptibility along the flow  [id: flow]
- [fig: flow_fig1] T χ_imp against T. A local moment sits at 1/4, the free orbital at 1/8; screening takes it to 0. The dotted line is Wilson's 0.0701.
  - code: `fchi`
  - asset: assets/figures/kondo/flow/flow_fig1.svg

| series | x | y |
| --- | --- | --- |
| U/Γ = 0.0 | 0.75 | 0.12286513400533591 |
| U/Γ = 0.0 | 0.0029296875 | 0.005236412405325075 |
| U/Γ = 2.0 | 0.75 | 0.12546917433453528 |
| U/Γ = 2.0 | 0.0029296875 | 0.010538342162021042 |
| U/Γ = 4.0 | 0.75 | 0.12807154189289202 |
| U/Γ = 4.0 | 0.375 | 0.12842428970464853 |
| U/Γ = 4.0 | 0.0029296875 | 0.0187525917744778 |
| U/Γ = 6.0 | 0.75 | 0.13066994390479028 |
| U/Γ = 6.0 | 0.13258252147247768 | 0.1379606216001697 |
| U/Γ = 6.0 | 0.0029296875 | 0.03433576635292812 |
| U/Γ = 8.0 | 0.75 | 0.13326210248881168 |
| U/Γ = 8.0 | 0.06629126073623884 | 0.15223616745672136 |
| U/Γ = 8.0 | 0.0029296875 | 0.05450687089464107 |
| 1/4, 1/8 | 1.0 | 0.25 |
| 1/4, 1/8 | 1.0 | 0.125 |
| 1/4, 1/8 |  | 0.125 |
| 0.0701 (T_K) | 1.0 | 0.0701 |
| 0.0701 (T_K) |  | 0.0701 |
_(18 of 94 rows; full data in the CSV asset)_
- [fig: flow_fig2] S_imp against T: ln 4 (free orbital) → ln 2 (local moment) → 0 (screened singlet).
  - code: `fs`
  - asset: assets/figures/kondo/flow/flow_fig2.svg

| series | x | y |
| --- | --- | --- |
| U/Γ = 0.0 | 0.75 | 1.3687335665626659 |
| U/Γ = 0.0 | 0.0029296875 | 0.06117899785916858 |
| U/Γ = 2.0 | 0.75 | 1.3685166450880266 |
| U/Γ = 2.0 | 0.0029296875 | 0.07048145383471827 |
| U/Γ = 4.0 | 0.75 | 1.3678664586890656 |
| U/Γ = 4.0 | 0.0029296875 | 0.09972876555384325 |
| U/Γ = 6.0 | 0.75 | 1.3667847380249079 |
| U/Γ = 6.0 | 0.0029296875 | 0.17542615721109733 |
| U/Γ = 8.0 | 0.75 | 1.3652743561775624 |
| U/Γ = 8.0 | 0.0029296875 | 0.27658536777451737 |
| ln 2, ln 4 | 1.0 | 0.6931471805599453 |
| ln 2, ln 4 | 1.0 | 1.3862943611198906 |
| ln 2, ln 4 |  | 1.3862943611198906 |
_(13 of 91 rows; full data in the CSV asset)_

#### The Kondo scale  [id: tk]
$T_K$ is read where $T\chi_{\rm imp}$ falls through 0.0701 (Wilson's definition) and
compared with Haldane's $T_K = \sqrt{U\Gamma/2}\,e^{-\pi U/8\Gamma + \pi\Gamma/2U}$,
which holds for $U \gg \Gamma$. The two definitions differ by an O(1) factor, so what
is asked is whether **the ratio stays constant** as $T_K$ falls. It does not: it drifts
from 0.96 at $U/\Gamma = 4$ to 1.25 at 8. Two causes are open and neither is tested
here — the $\Lambda = 2$ renormalisation of $\Gamma$, and reading $T_K$ near the end of
an 18-site chain at the largest $U/\Gamma$. At $U/\Gamma = 2$ the model is mixed-valent
and Haldane's form does not apply.


_T_K from the flow against the analytic scale_  [table: tk_tbl1]
| U/Γ | T_K (Wilson) | T_K (Haldane) | ratio | Tχ at lowest T | S at lowest T |
| --- | --- | --- | --- | --- | --- |
| 0.0 | — | — | — | 0.00524 | 0.0612 |
| 2.0 | 0.0228 | 0.03 | 0.76 | 0.0105 | 0.0705 |
| 4.0 | 0.0125 | 0.0131 | 0.96 | 0.0188 | 0.0997 |
| 6.0 | 0.00698 | 0.0064 | 1.09 | 0.0343 | 0.175 |
| 8.0 | 0.00394 | 0.00316 | 1.25 | 0.0545 | 0.277 |
