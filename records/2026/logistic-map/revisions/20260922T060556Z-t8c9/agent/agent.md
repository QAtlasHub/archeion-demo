# The logistic map, as a model record

### The logistic map  [id: logistic]
The map $x_{n+1} = r\,x_n(1-x_n)$ on $[0,1]$. This page exists to show what a record looks
like: a figure carries the code that drew it and the numbers behind it, so the catalogue is
readable by a person and by a program.


#### Orbits  [id: orbits]
Four orbits from $x_0 = 0.2$, through the period doubling into chaos.
- [fig: orbits_fig1] Fixed point, 2-cycle, 4-cycle, chaos
  - code: `fig_orbits()`
  - asset: assets/figures/logistic/orbits/orbits_fig1.svg

| series | x | y |
| --- | --- | --- |
| r = 2.9 | 1.0 | 0.46399999999999997 |
| r = 2.9 | 2.0 | 0.7212416 |
| r = 2.9 | 31.0 | 0.6524127088188063 |
| r = 2.9 | 32.0 | 0.65763406195249 |
| r = 2.9 | 60.0 | 0.6553017122858438 |
| r = 3.3 | 1.0 | 0.528 |
| r = 3.3 | 4.0 | 0.8239266326138736 |
| r = 3.3 | 5.0 | 0.4787360710553407 |
| r = 3.3 | 32.0 | 0.8236032832158181 |
| r = 3.3 | 33.0 | 0.4794270198034119 |
| r = 3.3 | 60.0 | 0.823603283206069 |
| r = 3.55 | 1.0 | 0.568 |
| r = 3.55 | 26.0 | 0.8872805955063953 |
| r = 3.55 | 27.0 | 0.3550487782219521 |
| r = 3.55 | 58.0 | 0.8873667058031404 |
| r = 3.55 | 59.0 | 0.3548119750850427 |
| r = 3.55 | 60.0 | 0.8126675528455927 |
| r = 3.9 | 1.0 | 0.6240000000000001 |
| r = 3.9 | 9.0 | 0.9742156868513789 |
| r = 3.9 | 10.0 | 0.09796598114189214 |
| r = 3.9 | 55.0 | 0.9726111395952336 |
| r = 3.9 | 56.0 | 0.10389097184892901 |
| r = 3.9 | 60.0 | 0.8814209848341189 |
_(23 of 240 rows; full data in the CSV asset)_

#### Bifurcation  [id: bifurcation]
The attractor as $r$ sweeps $[2.5, 4]$; the accumulation point is near $r \approx 3.5699$.
- [fig: bifurcation_fig1] 600 values of r, 80 iterates each after 300 discarded (a raster: 48_000 points)
  - code: `fig_bifurcation()`
  - asset: assets/figures/logistic/bifurcation/bifurcation_fig1.png

_Where each orbit above sits_  [table: bifurcation_tbl1]
| r | behaviour |
| --- | --- |
| 2.9 | fixed point |
| 3.3 | 2-cycle |
| 3.55 | 4-cycle |
| 3.9 | chaotic |

### A damped oscillator  [id: oscillator]
A second page, so the catalogue shows what a multi-page record looks like.

#### Decay  [id: decay]
$x(t) = e^{-\gamma t}\cos(\omega t)$ with $\gamma = 0.35$, $\omega = 3$.
- [fig: decay_fig1] Envelope and carrier
  - code: `fig_decay()`
  - asset: assets/figures/oscillator/decay/decay_fig1.svg

| series | x | y |
| --- | --- | --- |
| y1 | 0.0 | 1.0 |
| y1 | 1.01 | -0.6978581459440829 |
| y1 | 1.2 | -0.589212265594738 |
| y1 | 2.06 | 0.48367935685777463 |
| y1 | 2.4 | 0.26263166442548863 |
| y1 | 3.1 | -0.33527470948039756 |
| y1 | 3.6 | -0.05512246043537944 |
| y1 | 4.15 | 0.23240205819636064 |
| y1 | 5.2 | -0.16108237628206998 |
| y1 | 5.99 | 0.07833886542625856 |
| y1 | 6.24 | 0.1116466895584261 |
| y1 | 7.19 | -0.07368649781719644 |
| y1 | 7.29 | -0.07739318817463285 |
| y1 | 8.34 | 0.05364490394923791 |
| y1 | 8.4 | 0.052746198341901494 |
| y1 | 9.39 | -0.0371811754202073 |
| y1 | 9.6 | -0.03004564756433838 |
| y1 | 10.43 | 0.025772434453556686 |
| y1 | 10.8 | 0.012635439250213156 |
| y1 | 11.48 | -0.01786482946180235 |
| y1 | 12.0 | -0.0019188893380395144 |
_(21 of 1201 rows; full data in the CSV asset)_
