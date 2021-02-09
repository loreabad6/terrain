#' Convert elevation data into SAGA format
#'
#' @param elev_filename filename in disk of the elevation raster data
#' @param out_filename output filename, defaults to \code{[elev_filename].sgrd}
#' @param crs if elevation raster has no CRS, specify which to use, in proj format
#' @param overwrite boolean, default to TRUE, should the output file be overwritten?
#'
#' @importFrom raster raster crs writeRaster
#'
#' @export
elev_to_sgrd = function(elev_filename, out_filename = NA, crs = NULL, overwrite = TRUE) {
  # Load elevation data into R with raster
  elev = raster(elev_filename)
  # If crs is present, add information to elevation data
  if (!is.null(crs)) crs(elev) = crs
  # If crs is not set but elevation data has no crs, create a warning
  if (is.na(crs(elev))) warning("Input data has no CRS.", call. = FALSE)
  # Set the output filename if not given. Defaults to the same path and name of input data
  # with an .sgrd extension
  out_filename = if (is.na(out_filename)) sub('.[^.]*$', '', elev_filename)
  # Write raster to disk
  writeRaster(
    elev, out_filename, format = 'SAGA',
    overwrite = overwrite, NAflag = 0, prj = TRUE
  )
}
