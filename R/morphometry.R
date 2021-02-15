#' Calculate derivatives from the Morphometry module
#'
#' @param elev_sgrd input, elevation raster data in SAGA format,
#'                  can be created with \code{elev_to_sgrd()}
#' @param out_dir output directory
#' @param prefix character prefix for output filenames
#' @param envir environment to get SAGA installation,
#'            can be set with \code{init_saga()}
#' @param ... ignored, check help page for possible outputs
#' @param aspect Aspect:
#'               the compass direction that a slope faces.
#'               Boolean, defaults to \code{FALSE}
#' @param ccros Crossectional Curvature:
#'              Boolean, defaults to \code{FALSE}
#' @param cgene Curvature (General Curvature):
#'              Boolean, defaults to \code{FALSE}
#' @param clong Longitudinal Curvature:
#'              Boolean, defaults to \code{FALSE}
#' @param cmaxi Maximum Curvature:
#'              Boolean, defaults to \code{FALSE}
#' @param cmini Minimum Curvature:
#'              Boolean, defaults to \code{FALSE}
#' @param cplan Plan Curvature:
#'              Boolean, defaults to \code{FALSE}
#' @param cprof Profile Curvature:
#'              Surface curvature in the direction of gradient
#'              Boolean, defaults to \code{FALSE}
#' @param cvidx Convergence Index:
#'              Calculates an index of convergence/divergence regarding to
#'              overland flow. By its meaning it is similar to plan or
#'              horizontal curvature, but gives much smoother results.
#'              The calculation uses the aspects of surrounding cells, i.e.
#'              it looks to which degree surrounding cells point to the center
#'              cell. The result is given as percentages, negative values
#'              correspond to convergent, positive to divergent flow
#'              conditions. Minus 100 would be like a peak of a cone (a),
#'              plus 100 a pit (c), and 0 an even slope (b).
#'              Boolean, defaults to \code{FALSE}
#' @param ddgrd Downslope distance gradient:
#'              describes wet areas by assuming water accumulation in flat
#'              areas is due to upslope, local and downslope topography.
#'              It is a quantitative estimation of the hydraulic gradient.
#'              Obtained by calculating the downhill distance when water loses
#'              a determined quantity of energy from precipitation.
#'              Boolean, defaults to \code{FALSE}
#' @param mbidx Mass Balance Index:
#'              Negative MBI values represent areas of net deposition such as
#'              depressions and floodplains; positive MBI values represent areas
#'              of net erosion such as hillslopes, and MBI values close to zero
#'              indicate areas where there is a balance between erosion and
#'              deposition such as low slopes and plain areas. High positive
#'              MBI values occur at convex terrain forms, like upper slopes and
#'              crests, while lower MBI values are associated with valley areas
#'              and concave zones at lower slopes. Balanced MBI values close to
#'              zero can be found in midslope zones and mean a location of no
#'              net loss or net accumulation of material.
#'              Boolean, defaults to \code{FALSE}
#' @param mdslp Midslope Position:
#'              Boolean, defaults to \code{FALSE}
#' @param nrhgt Normalized Height:
#'              Boolean, defaults to \code{FALSE}
#' @param slhgt Slope Height:
#'              Boolean, defaults to \code{FALSE}
#' @param slope Slope gradient:
#'              Reflects the maximal rate of change of elevation values.
#'              Boolean, defaults to \code{FALSE}
#' @param sthgt Standardized Height:
#'              Boolean, defaults to \code{FALSE}
#' @param textu Texture:
#'              This parameter emphasizes fine versus coarse expression of
#'              topographic spacing, or “grain”… Texture is calculated by
#'              extracting grid cells (here, informally, “pits” and “peaks”)
#'              that outline the distribution of valleys and ridges. It is
#'              defined by both relief (feature frequency) and spacing in the
#'              horizontal. Each grid cell value represents the relative
#'              frequency (in percent) of the number of pits and peaks within
#'              a radius of ten cells (Iwahashi and Pike, 2007. pp.412-413).
#'              It should be noted that it is not clear that the relative
#'              frequency is actually a percentage. According to Iwahashi and
#'              Pike (2007, p.30), To ensure statistically robust classes,
#'              thresholds for subdividing the images are arbitrarily set
#'              at mean values of frequency distributions of the input
#'              variables.
#'              Boolean, defaults to \code{FALSE}
#' @param tpidx Topographic Position Index:
#'              Measures the relative topographic position of the central point
#'              as the difference between the elevation at this point and the
#'              mean elevation within a predetermined neighbourhood. Using TPI,
#'              landscapes can be classified in slope position classes. TPI is
#'              only one of a vast array of morphometric properties based on
#'              neighbouring areas that can be useful in topographic and DEM
#'              analysis. Used for roughness determination. The lower the
#'              numbers are the lower areas in the landscape. The higher
#'              numbers are the higher areas in the landscape.
#'              Boolean, defaults to \code{FALSE}
#' @param tridx Terrain Ruggedness Index:
#'              Quantitative measure of topographic heterogeneity by
#'              calculating the sum change in elevation between a grid cell
#'              and its eight neighbor grid cells. This tool works with
#'              absolute values by squaring the differences between the target
#'              and neighbor cells, then taking the square root. Concave and
#'              convex shape areas could have similar values. The value of this
#'              metric will vary as a function of the size and complexity of
#'              the terrain used in the analysis. The closer you are to 0 the
#'              less rugged the terrain likely is. The bigger the number is,
#'              e.g. 105, then the terrain is likely to be more rugged.
#'              Boolean, defaults to \code{FALSE}
#' @param vldpt Valley Depth:
#'              Calculated as difference between the elevation and an
#'              interpolated ridge level. Ridge level interpolation uses the
#'              algorithm implemented in the 'Vertical Distance to Channel
#'              Network' tool.
#'              Boolean, defaults to \code{FALSE}
#' @param units character, units for slope and aspect output
#'
#' @references Olaya, V. (2009). Basic land-surface parameters.
#'             In Developments in Soil Science (Vol. 33, Issue C).
#'             Elsevier Ltd. https://doi.org/10.1016/S0166-2481(08)00006-8
#' @references https://sourceforge.net/p/saga-gis/wiki/ta_morphometry_1/
#'
#' @importFrom here here
#' @importFrom RSAGA rsaga.slope.asp.curv rsaga.geoprocessor
#' @export
elev_to_morphometry = function(elev_sgrd, out_dir, prefix = '', envir, ...,
                               aspect = FALSE, ccros = FALSE, cgene = FALSE,
                               clong = FALSE, cmaxi = FALSE, cmini = FALSE,
                               cplan = FALSE, cprof = FALSE, cvidx = FALSE,
                               ddgrd = FALSE, mbidx = FALSE, mdslp = FALSE,
                               nrhgt = FALSE, slhgt = FALSE, slope = FALSE,
                               sthgt = FALSE, textu = FALSE, tpidx = FALSE,
                               tridx = FALSE, vldpt = FALSE, units = "degrees") {

  # Slope, aspect, curvature - Module 0
  module_0_params_set = list(
    out.aspect = if (aspect) here(out_dir, paste0(prefix, "aspect.sgrd")),
    out.ccros = if (ccros) here(out_dir, paste0(prefix, "ccros.sgrd")),
    out.cgene = if (cgene) here(out_dir, paste0(prefix, "cgene.sgrd")),
    out.clong = if (clong) here(out_dir, paste0(prefix, "clong.sgrd")),
    out.cmaxi = if (cmaxi) here(out_dir, paste0(prefix, "cmaxi.sgrd")),
    out.cmini = if (cmini) here(out_dir, paste0(prefix, "cmini.sgrd")),
    out.cplan = if (cplan) here(out_dir, paste0(prefix, "cplan.sgrd")),
    out.cprof = if (cprof) here(out_dir, paste0(prefix, "cprof.sgrd")),
    out.slope = if (slope) here(out_dir, paste0(prefix, "slope.sgrd"))
  )

  module_0_params = module_0_params_set[lengths(module_0_params_set) > 0]

  if (length(module_0_params) > 0) {
    more_params = list(
      in.dem = elev_sgrd,
      unit.slope = units,
      unit.aspect = units,
      env = envir
    )
    params = append(more_params, module_0_params)
    do.call(rsaga.slope.asp.curv, params)
  }

  # Convergence Index - Module 1
  if (cvidx) {
    rsaga.geoprocessor(
      'ta_morphometry', 1,
      list(
        ELEVATION = elev_sgrd,
        RESULT = here(out_dir, paste0(prefix, "cvidx.sgrd")),
        METHOD = 1,
        NEIGHBOURS = 1
      ),
      env = envir
    )
  }

  # Downslope Distance Gradient - Module 9
  if (ddgrd) {
    rsaga.geoprocessor(
      'ta_morphometry', 9,
      list(
        DEM = elev_sgrd,
        GRADIENT = here(out_dir, paste0(prefix, "ddgrd.sgrd")),
        OUTPUT = 2
      ),
      env = envir
    )
  }

  # Mass Balance Index - Module 10
  if (ddgrd) {
    rsaga.geoprocessor(
      'ta_morphometry', 10,
      list(
        DEM = elev_sgrd,
        MBI = here(out_dir, paste0(prefix, "mbidx.sgrd"))
      ),
      env = envir
    )
  }

  # Relative Heights and Slope Positions - Module 14
  module_14_params_set = list(
   HO = if (slhgt) here(out_dir, paste0(prefix, "shlgt.sgrd")),
   HU = if (vldpt) here(out_dir, paste0(prefix, "vldpt.sgrd")),
   NH = if (nrhgt) here(out_dir, paste0(prefix, "nrhgt.sgrd")),
   SH = if (sthgt) here(out_dir, paste0(prefix, "sthgt.sgrd")),
   MS = if (mdslp) here(out_dir, paste0(prefix, "mdslp.sgrd"))
  )

  module_14_params = module_14_params_set[lengths(module_14_params_set) > 0]

  if (length(module_14_params) > 0) {
      params = append(list(DEM = elev_sgrd), module_14_params)
      rsaga.geoprocessor('ta_morphometry', 14, params, env = envir)
  }

  # Terrain Ruggedness Index (TRI) - Module 16
  if (tridx) {
    rsaga.geoprocessor(
      'ta_morphometry', 16,
      list(
        DEM = elev_sgrd,
        TRI = here(out_dir, paste0(prefix, "tridx.sgrd"))
      ),
      env = envir
    )
  }

  # Topographic Position Index (TPI) - Module 18
  if (tpidx) {
    rsaga.geoprocessor(
      'ta_morphometry', 18,
      list(
        DEM = elev_sgrd,
        TPI = here(out_dir, paste0(prefix, "tpidx.sgrd")),
        RADIUS_MIN=0,
        RADIUS_MAX=20
      ),
      env = envir
    )
  }

  # Terrain Surface Texture - Module 20
  if (textu) {
    rsaga.geoprocessor(
      'ta_morphometry', 20,
      list(
        DEM = elev_sgrd,
        TEXTURE = here(out_dir, paste0(prefix, "textu.sgrd"))
      ),
      env = envir
    )
  }
}
