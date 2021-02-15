#' Calculate derivatives from the Hidrology module
#'
#' @param elev_sgrd optional input, elevation raster data in SAGA format,
#'                  can be created with \code{elev_to_sgrd()}
#' @param slope_sgrd optional input, slope raster data in SAGA format,
#'                  can be created with \code{elev_to_morphometry(slope = TRUE)}
#' @param spcar_sgrd optional input, specific catchment area raster data in
#'                  SAGA format, can be created with
#'                  \code{elev_to_terrain_analysis(flow = TRUE, spcar = TRUE)}
#'                  Both options are needed since this is computed from the
#'                  Flow Accumulation (One Step) module
#' @param out_dir output directory
#' @param prefix character prefix for output filenames
#' @param env environment to get SAGA installation,
#'            can be set with \code{init_saga()}
#' @param ... ignored, check help page for possible outputs
#' @param mridx Melton Ruggedness Index:
#'              Simple flow accumulation related index, calculated as
#'              difference between maximum and minimum elevation in catchment
#'              area divided by square root of catchment area size. The
#'              calculation is performed for each grid cell, therefore minimum
#'              elevation is same as elevation at cell’s position. Due to the
#'              discrete character of a single maximum elevation, flow
#'              calculation is simply done with Deterministic 8.
#'              Boolean,defaults to \code{FALSE}
#' @param sagaw SAGA Wetness Index:
#'              Similar to the ‘Topographic Wetness Index’ (TWI),
#'              see \code{eval_to_terrain_analysis} but based on a modified
#'              catchment area calculation (‘Modified Catchment Area’),
#'              which does not think of the flow as very thin film. It predicts
#'              for cells situated in valley floors with a small vertical
#'              distance to a channel a more realistic, higher potential
#'              soil moisture compared to the standard TWI calculation.
#'              Boolean, defaults to \code{FALSE}
#' @param sllgt Slope Length:
#'              Measurement of the distance from the origin of overland flow
#'              along its flow path to the location of either concentrated flow
#'              or deposition.
#'              Boolean, defaults to \code{FALSE}
#' @param spidx Stream Power Index:
#'              Measure of the erosive power of flowing water. Calculated based
#'              upon slope and contributing area. SPI approximates locations
#'              where gullies might be more likely to form on the landscape.
#'              Needs \code{slope_sgrd} and \code{spcar_sgrd} parameters.
#'              Boolean, defaults to \code{FALSE}
#'
#' @importFrom here here
#' @importFrom RSAGA rsaga.geoprocessor
#' @export
elev_to_hidrology = function(elev_sgrd = NULL, slope_sgrd = NULL,
                             spcar_sgrd = NULL, out_dir, prefix = '',
                             env = env, ...,
                             mridx = FALSE, sagaw = FALSE,
                             sllgt = FALSE, spidx = FALSE) {

  # Slope Length - Module 7
  if (sllgt) {
    if (is.null(elev_sgrd)) {
      stop(
        "elev_sgrd parameter needed for calculating this derivative",
        call. = FALSE
      )
    }
    rsaga.geoprocessor(
      'ta_hydrology', 7,
      list(
        DEM = elev_sgrd,
        LENGTH = here(out_dir, paste0(prefix, "sllgt", ".sgrd"))
      ),
      env = env
    )
  }

  # SAGA Wetness Index - Module 15
  if (sagaw) {
    if (is.null(elev_sgrd)) {
      stop(
        "elev_sgrd parameter needed for calculating this derivative",
        call. = FALSE
      )
    }
    rsaga.geoprocessor(
      'ta_hydrology', 15,
      list(
        DEM = elev_sgrd,
        MRN = here(out_dir, paste0(prefix, "sagaw", ".sgrd"))
      ),
      env = env
    )
  }

  # Stream Power Index - Module 21
  if (spidx) {
    if (is.null(slope_sgrd) & is.null(spcar_sgrd)) {
      stop(
        "slope_sgrd and spcar_sgrd parameters needed for calculating this derivative",
        call. = FALSE
      )
    }
    rsaga.geoprocessor(
      'ta_hydrology', 21,
      list(
        SLOPE = slope_sgrd,
        AREA = spcar_sgrd,
        SPI = here(out_dir, paste0(prefix, "spidx", ".sgrd"))
      ),
      env = env
    )
  }

  # Melton Ruggedness Number - Module 23
  if (mridx) {
    if (is.null(elev_sgrd)) {
      stop(
        "elev_sgrd parameter needed for calculating this derivative",
        call. = FALSE
      )
    }
    rsaga.geoprocessor(
      'ta_hydrology', 23,
      list(
        DEM = elev_sgrd,
        MRN = here(out_dir, paste0(prefix, "mridx", ".sgrd"))
      ),
      env = env
    )
  }
}
