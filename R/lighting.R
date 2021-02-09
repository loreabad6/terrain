#' Calculate derivatives from the Lighting module
#'
#' @param elev_sgrd input, elevation raster data in SAGA format,
#'                  can be created with \code{elev_to_sgrd()}
#' @param out_dir output directory
#' @param prefix character prefix for output filenames
#' @param env environment to get SAGA installation,
#'            can be set with \code{init_saga()}
#' @param shade boolean, defaults to \code{FALSE}
#' @param visky boolean, defaults to \code{FALSE}
#' @param svfct boolean, defaults to \code{FALSE}
#' @param posop boolean, defaults to \code{FALSE}
#' @param negop boolean, defaults to \code{FALSE}
#'
#' @importFrom here here
#' @importFrom RSAGA rsaga.geoprocessor
#' @export
elev_to_lighting = function(elev_sgrd, out_dir,
                            prefix = '', env = env, ...,
                            negop = FALSE, posop = FALSE, shade = FALSE,
                            svfct = FALSE, visky = FALSE) {
  # Hillshade - Module 0
  if (shade) {
    rsaga.geoprocessor(
      'ta_lighting', 0,
      list(
        ELEVATION = elev_sgrd,
        SHADE = here(out_dir, paste0(prefix, "shade", ".sgrd"))
      ),
      env = env
    )
  }

  # Sky View Factor - Module 3
  module_3_params = list(
    if (svfct) SVF = here(out_dir, paste0(prefix, "svfct", ".sgrd")),
    if (visky) VISIBLE = here(out_dir, paste0(prefix, "visky", ".sgrd"))
  )

  if (length(module_3_parms[lengths(module_3_parms) > 0]) > 0) {
    params = append(
      list(DEM = elev_sgrd, METHOD = 1, DLEVEL = 3),
      module_3_params
    )
    rsaga.geoprocessor('ta_lighting', 3, params, env = env)
  }

  # Topographic Openness - Module 5
  module_5_params = list(
    if (posop) POS = here(out_dir, paste0(prefix, "posop", ".sgrd")),
    if (negop) NEG = here(out_dir, paste0(prefix, "negop", ".sgrd"))
  )

  if (length(module_5_parms[lengths(module_5_parms) > 0]) > 0) {
    params = append(
      list(DEM = elev_sgrd, METHOD = 0, DLEVEL = 3),
      module_5_params
    )
    rsaga.geoprocessor('ta_lighting', 5, params, env = env)
  }
}
