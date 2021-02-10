#' Calculate derivatives from the Terrain Analysis module
#'
#' @param elev_sgrd input, elevation raster data in SAGA format,
#'                  can be created with \code{elev_to_sgrd()}
#' @param out_dir output directory
#' @param prefix character prefix for output filenames
#' @param env environment to get SAGA installation,
#'            can be set with \code{init_saga()}
#' @param ... ignored, check help page for possible outputs
#' @param lsfct LS Factor:
#'              L is the slope length factor, representing the effect of slope
#'              length on erosion. It is the ratio of soil loss from the field
#'              slope length to that from a 72.6-foot (22.1-meter) length on
#'              the same soil type and gradient. Slope length is the distance
#'              from the origin of overland flow along its flow path to the
#'              location of either concentrated flow or deposition. S is the
#'              slope steepness. Represents the effect of slope steepness on
#'              erosion. Soil loss increases more rapidly with slope steepness
#'              than it does with slope length. L factor and S factor are
#'              usually considered together. LS factors = the slope length
#'              factor L computes the effect of slope length on erosion and
#'              the slope steepness factor S computes the effect of slope
#'              steepness on erosion. Values of both L and S equal 1 for the
#'              unit plot conditions of 72.6 ft length and 9 percent steepness.
#'              Values of L and S are relative and represent how erodible the
#'              particular slope length and steepness is relative to the 72.6 ft
#'              long, 9% steep unit plot. Thus some values of L and S are less
#'              than 1 and some values are greater than 1.
#'              Boolean, defaults to \code{FALSE}
#' @param spcar,flow Specific Catchment Area and Flow Accumulation:
#'                   SCA is A parameter of the tendency to receive water.
#'                   The contributing area (also known as basin area,
#'                   upslope area, or flow accumulation) deter-mines the size
#'                   of the upslope area (derived by the number of cells)
#'                   draining into a cell.
#'                   Boolean, defaults to \code{FALSE} When \code{TRUE},
#'                   then \code{flow} should also be \code{TRUE}
#' @param twidx Topographic Wetness Index:
#'              Describes the tendency of an area to accumulate water.
#'              Areas prone to water accumulation (large contributing drainage
#'              areas) and characterized by low slope angle will be linked to
#'              high TWI values. On the other hand, well-drained dry areas
#'              (steep slopes) are associated to low TWI values.
#'              Boolean, defaults to \code{FALSE}
#'
#' @references Mattivi, P., Franci, F., Lambertini, A. et al. TWI computation:
#'             a comparison of different open source GISs.
#'             Open geospatial data, softw. stand. 4, 6 (2019).
#'             https://doi.org/10.1186/s40965-019-0066-y
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
