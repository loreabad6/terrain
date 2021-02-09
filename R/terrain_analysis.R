#' Calculate derivatives from the Terrain Analysis module
#'
#' @param elev_sgrd input, elevation raster data in SAGA format,
#'                  can be created with \code{elev_to_sgrd()}
#' @param out_dir output directory
#' @param prefix character prefix for output filenames
#' @param env environment to get SAGA installation,
#'            can be set with \code{init_saga()}
#' @param ... ignored, check help page for possible outputs
#' @param lsfct boolean, defaults to \code{FALSE}
#' @param flow boolean, defaults to \code{FALSE}
#' @param spcar boolean, defaults to \code{FALSE} When \code{TRUE},
#'              then \code{flow} should also be \code{TRUE}
#' @param twidx boolean, defaults to \code{FALSE}
#'
#' @importFrom here here
#' @importFrom RSAGA rsaga.geoprocessor
#' @export
elev_to_terrain_analysis = function(elev_sgrd, out_dir,
                                    prefix = '', env = env, ...,
                                    lsfct = FALSE, flow = FALSE,
                                    spcar = FALSE, twidx = FALSE) {
  # LS Factor (One Step)
  if (lsfct) {
    rsaga.geoprocessor(
      'terrain_analysis',
      'LS Factor (One Step)',
      list(
        DEM = elev_sgrd,
        LS_FACTOR = here(out_dir, paste0(prefix, "lsfct", ".sgrd")),
        LS_METHOD = 0,
        PREPROCESSING = 2,
        MINSLOPE = 0.0001
      ),
      env = env
    )
  }

  # Topographic Wetness Index (One Step)
  if (twidx) {
    rsaga.geoprocessor(
      'terrain_analysis',
      'Topographic Wetness Index (One Step)',
      list(
        DEM = elev_sgrd,
        TWI = here(out_dir, paste0(prefix, "twidx", ".sgrd")),
        FLOW_METHOD = 0
      ),
      env = env
    )
  }

  # Flow Accumulation (One Step)
  if (flow) {
    if (!spcar) stop("Both flow and spcar should be set to TRUE", call. = FALSE)
    rsaga.geoprocessor(
      'terrain_analysis',
      'Flow Accumulation (One Step)',
      list(
        DEM = elev_sgrd,
        TCA = here(out_dir, paste0(prefix, "flow", ".sgrd")),
        SCA = here(out_dir, paste0(prefix, "spcar", ".sgrd")),
        PREPROCESSING = 0,
        FLOW_ROUTING = 0
      ),
      env = env
    )
  }
}
