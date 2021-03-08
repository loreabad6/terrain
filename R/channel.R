#' Calculate derivatives from the Channel module
#'
#' @description The main goal of this function is to calculate the
#'              Vertical Distance to the Channel Network \code{vdcnw}
#'              parameter, so it will calculate first \code{chnet}.
#'              However, it can be used to only calculate the
#'              Channel Network as well.
#'
#' @param elev_sgrd input, elevation raster data in SAGA format,
#'                  can be created with \code{elev_to_sgrd()}
#' @param flow_sgrd input, can be generated with
#'                   \code{elev_to_terrain_analysis()}
#' @param out_dir output directory
#' @param prefix character prefix for output filenames
#' @param envir environment to get SAGA installation,
#'            can be set with \code{init_saga()}
#' @param ... ignored, check help page for possible outputs
#' @param chnet Channel Network:
#'              If a cell is part of a channel its value equals the channel
#'              order. Otherwise the cell is marked as no-data.
#'              Boolean, defaults to \code{TRUE}
#' @param vdcnw Vertical Distance to Channel Network:
#'              Altitude above the channel network.
#'              Boolean, defaults to \code{FALSE}
#' @param init_value Initiation flow accumulation value for
#'                   channel network computation. Defaults to 1000000
#' @param chnet_shp Calculate channel network in vector format
#'
#' @importFrom here here
#' @importFrom RSAGA rsaga.geoprocessor
#' @export
elev_to_channel = function(elev_sgrd, flow_sgrd,
                           out_dir, prefix = '', envir, ...,
                           chnet = TRUE, vdcnw = FALSE,
                           init_value = 1000000, chnet_shp = FALSE) {
  if (!chnet) stop("chnet is a fix output from this function", call. = FALSE)
  module_0_params_set = list(
    ELEVATION = elev_sgrd,
    INIT_GRID = flow_sgrd,
    CHNLNTWRK = here(out_dir, paste0(prefix, "chnet", ".sgrd")),
    INIT_VALUE = init_value,
    SHAPES = if (chnet_shp) here(out_dir, paste0(prefix, "chnet"))
  )

  module_0_params = module_0_params_set[lengths(module_0_params_set) > 0]

  rsaga.geoprocessor(
    'ta_channels', 0,
    module_0_params,
    env = envir
  )

  if (vdcnw) {
    rsaga.geoprocessor(
      'ta_channels', 3,
      list(
        ELEVATION = elev_sgrd,
        CHANNELS = here(out_dir, paste0(prefix, "chnet", ".sgrd")),
        DISTANCE = here(out_dir, paste0(prefix, "vdcnw", ".sgrd"))
      ),
      env = envir
    )
  }
}
