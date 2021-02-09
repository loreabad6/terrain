#' Calculate derivatives from the Morphometry module
#'
#' @param elev_sgrd input, elevation raster data in SAGA format,
#'                  can be created with \code{elev_to_sgrd()}
#' @param out_dir output directory
#' @param prefix character prefix for output filenames
#' @param env environment to get SAGA installation,
#'            can be set with \code{init_saga()}
#' @param ... ignored, check help page for possible outputs
#' @param aspect boolean, defaults to \code{FALSE}
#' @param ccros boolean, defaults to \code{FALSE}
#' @param cgene boolean, defaults to \code{FALSE}
#' @param clong boolean, defaults to \code{FALSE}
#' @param cmaxi boolean, defaults to \code{FALSE}
#' @param cmini boolean, defaults to \code{FALSE}
#' @param cplan boolean, defaults to \code{FALSE}
#' @param cprof boolean, defaults to \code{FALSE}
#' @param cvidx boolean, defaults to \code{FALSE}
#' @param ddgrd boolean, defaults to \code{FALSE}
#' @param mbidx boolean, defaults to \code{FALSE}
#' @param mdslp boolean, defaults to \code{FALSE}
#' @param nrhgt boolean, defaults to \code{FALSE}
#' @param slhgt boolean, defaults to \code{FALSE}
#' @param slope boolean, defaults to \code{FALSE}
#' @param sthgt boolean, defaults to \code{FALSE}
#' @param textu boolean, defaults to \code{FALSE}
#' @param tpidx boolean, defaults to \code{FALSE}
#' @param tridx boolean, defaults to \code{FALSE}
#' @param vldpt boolean, defaults to \code{FALSE}
#' @param units character, units for slope and aspect output
#'
#' @importFrom here here
#' @importFrom RSAGA rsaga.slope.asp.curv rsaga.geoprocessor
#' @export
elev_to_morphometry = function(elev_sgrd, out_dir, prefix = '', env = env, ...,
                               aspect = FALSE, ccros = FALSE, cgene = FALSE,
                               clong = FALSE, cmaxi = FALSE, cmini = FALSE,
                               cplan = FALSE, cprof = FALSE, cvidx = FALSE,
                               ddgrd = FALSE, mbidx = FALSE, mdslp = FALSE,
                               nrght = FALSE, slhgt = FALSE, slope = FALSE,
                               sthgt = FALSE, textu = FALSE, tpidx = FALSE,
                               tridx = FALSE, vldpt = FALSE, units = "degrees") {

  # Slope, aspect, curvature - Module 0
  module_0_params = list(
    if (aspect) out.aspect = here(out_dir, paste0(prefix, "aspect", ".sgrd")),
    if (ccros) out.ccros = here(out_dir, paste0(prefix, "ccros", ".sgrd")),
    if (cgene) out.cgene = here(out_dir, paste0(prefix, "cgene", ".sgrd")),
    if (clong) out.clong = here(out_dir, paste0(prefix, "clong", ".sgrd")),
    if (cmaxi) out.cmaxi = here(out_dir, paste0(prefix, "cmaxi", ".sgrd")),
    if (cmini) out.cmini = here(out_dir, paste0(prefix, "cmini", ".sgrd")),
    if (cplan) out.cplan = here(out_dir, paste0(prefix, "cplan", ".sgrd")),
    if (cprof) out.cprof = here(out_dir, paste0(prefix, "cprof", ".sgrd")),
    if (slope) out.slope = here(out_dir, paste0(prefix, "slope", ".sgrd"))
  )

  if (length(module_0_parms[lengths(module_0_parms) > 0]) > 0) {
    more_params = list(
      in.dem = elev_sgrd,
      unit.slope = units,
      unit.aspect = units
    )
    params = append(more_params, module_0_params)
    do.call(rsaga.slope.asp.curv, env = env, parms)
  }

  # Convergence Index - Module 1
  if (cvidx) {
    rsaga.geoprocessor(
      'ta_morphometry', 1,
      list(
        ELEVATION = elev_sgrd,
        RESULT = here(out_dir, paste0(prefix, "cvidx", ".sgrd")),
        METHOD = 1,
        NEIGHBOURS = 1
      ),
      env = env
    )
  }

  # Downslope Distance Gradient - Module 9
  if (ddgrd) {
    rsaga.geoprocessor(
      'ta_morphometry', 9,
      list(
        DEM = elev_sgrd,
        GRADIENT = here(out_dir, paste0(prefix, "ddgrd", ".sgrd")),
        OUTPUT = 2
      ),
      env = env
    )
  }

  # Mass Balance Index - Module 10
  if (ddgrd) {
    rsaga.geoprocessor(
      'ta_morphometry', 10,
      list(
        DEM = elev_sgrd,
        MBI = here(out_dir, paste0(prefix, "mbidx", ".sgrd")),
      ),
      env = env
    )
  }

  # Relative Heights and Slope Positions - Module 14
  module_14_params = list(
   if (slhgt) HO = here(out_dir, paste0(prefix, "shlgt", ".sgrd")),
   if (vldpt) HU = here(out_dir, paste0(prefix, "vldpt", ".sgrd")),
   if (nrhgt) NH = here(out_dir, paste0(prefix, "nrlgt", ".sgrd")),
   if (sthgt) SH = here(out_dir, paste0(prefix, "sthgt", ".sgrd")),
   if (mdslp) MS = here(out_dir, paste0(prefix, "mdslp", ".sgrd"))
  )

  if (length(module_14_parms[lengths(module_14_parms) > 0]) > 0) {
      params = append(list(DEM = elev_sgrd), module_14_params)
      rsaga.geoprocessor('ta_morphometry', 14, params, env = env)
  }

  # Terrain Ruggedness Index (TRI) - Module 16
  if (tridx) {
    rsaga.geoprocessor(
      'ta_morphometry', 16,
      list(
        DEM = elev_sgrd,
        TRI = here(out_dir, paste0(prefix, "tridx", ".sgrd"))
      ),
      env = env
    )
  }

  # Topographic Position Index (TPI) - Module 18
  if (tpidx) {
    rsaga.geoprocessor(
      'ta_morphometry', 18,
      list(
        DEM = elev_sgrd,
        TPI = here(out_dir, paste0(prefix, "tpidx", ".sgrd")),
        RADIUS_MIN=0,
        RADIUS_MAX=20
      ),
      env = env
    )
  }

  # Terrain Surface Texture - Module 20
  if (textu) {
    rsaga.geoprocessor(
      'ta_morphometry', 20,
      list(
        DEM = elev_sgrd,
        TEXTURE = here(out_dir, paste0(prefix, "textu", ".sgrd"))
      ),
      env = env
    )
  }
}
