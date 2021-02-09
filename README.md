
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `terrain`: Utility Functions for Terrain Derivatives Calculations

<!-- badges: start -->
<!-- badges: end -->

The goal of `terrain` is to have a useful toolbox to calculate terrain
derivatives using RSAGA. The package is for my personal use, with
selected RSAGA terrain derivatives, and not meant to be comprehensive.
Several defaults are hard-coded.

For the package to work, there should be a local executable of the SAGA
software available.

It is not meant for CRAN, and hence most of the functions will write to
disk.

## Installation

You can install the package from GitHub with:

``` r
remotes::install_github("loreabad6/terrain")
```

## RSAGA selected terrain derivatives

A list of the selected RSAGA terrain derivatives follows below, refer to
function code documentation for a short description of each derivative.

<table>
<thead>
<tr>
<th style="text-align:left;">
Derivative
</th>
<th style="text-align:left;">
Output Name
</th>
</tr>
</thead>
<tbody>
<tr grouplength="1">
<td colspan="2" style="border-bottom: 1px solid;">
<strong>`elev_to_channels()`</strong>
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Vertical Distance To Channel Network
</td>
<td style="text-align:left;">
vdcnw
</td>
</tr>
<tr grouplength="4">
<td colspan="2" style="border-bottom: 1px solid;">
<strong>`elev_to_hydrology()`</strong>
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Melton Ruggedness Index
</td>
<td style="text-align:left;">
mridx
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
SAGA Wetness Index
</td>
<td style="text-align:left;">
sagaw
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Slope length
</td>
<td style="text-align:left;">
sllgt
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Stream Power Index
</td>
<td style="text-align:left;">
spidx
</td>
</tr>
<tr grouplength="5">
<td colspan="2" style="border-bottom: 1px solid;">
<strong>`elev_to_lighting()`</strong>
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Hillshade
</td>
<td style="text-align:left;">
shade
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Negative Openness
</td>
<td style="text-align:left;">
negop
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Positive Openness
</td>
<td style="text-align:left;">
posop
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Sky view factor
</td>
<td style="text-align:left;">
svfct
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Visible Sky
</td>
<td style="text-align:left;">
visky
</td>
</tr>
<tr grouplength="20">
<td colspan="2" style="border-bottom: 1px solid;">
<strong>`elev_to_morphometry()`</strong>
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Aspect
</td>
<td style="text-align:left;">
aspect
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Convergence Index
</td>
<td style="text-align:left;">
cvidx
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Crossectional Curvature
</td>
<td style="text-align:left;">
ccros
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Curvature (General Curvature)
</td>
<td style="text-align:left;">
cgene
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Downslope distance gradient
</td>
<td style="text-align:left;">
ddgrd
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Longitudinal Curvature
</td>
<td style="text-align:left;">
clong
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Mass Balance Index
</td>
<td style="text-align:left;">
mbidx
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Maximum Curvature
</td>
<td style="text-align:left;">
cmaxi
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Midslope position
</td>
<td style="text-align:left;">
mdslp
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Minimum Curvature
</td>
<td style="text-align:left;">
cmini
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Normalized Height
</td>
<td style="text-align:left;">
nrhgt
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Plan Curvature
</td>
<td style="text-align:left;">
cplan
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Profile Curvature
</td>
<td style="text-align:left;">
cprof
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Slope
</td>
<td style="text-align:left;">
slope
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Slope Height
</td>
<td style="text-align:left;">
slhgt
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Standardized Height
</td>
<td style="text-align:left;">
sthgt
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Terrain Ruggedness Index
</td>
<td style="text-align:left;">
tridx
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Texture
</td>
<td style="text-align:left;">
textu
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Topographic Position Index
</td>
<td style="text-align:left;">
tpidx
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Valley Depth
</td>
<td style="text-align:left;">
vldpt
</td>
</tr>
<tr grouplength="2">
<td colspan="2" style="border-bottom: 1px solid;">
<strong>`elev_to_terrain_analysis()`</strong>
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
LS Factor
</td>
<td style="text-align:left;">
lsfct
</td>
</tr>
<tr>
<td style="text-align:left; padding-left: 2em;" indentlevel="1">
Topographic Wetness Index
</td>
<td style="text-align:left;">
twidx
</td>
</tr>
</tbody>
</table>
