#' Convert elevation data into SAGA format
#'
#' @param elev_filename filename in disk of the elevation raster data
#' @param out_filename output filename, defaults to \code{[elev_filename].sgrd}
#' @param crs_elev if elevation raster has no CRS, specify which to use, in proj format
#' @param overwrite boolean, default to TRUE, should the output file be overwritten?
#'
#' @importFrom raster raster crs<- crs writeRaster
#'
#' @export
elev_to_sgrd = function(elev_filename, out_filename = NA,
                        crs_elev = NA, overwrite = TRUE) {
  # Load elevation data into R with raster
  elev = raster(elev_filename)
  # If crs info is given, add information to elevation data
  # if (!is.na(crs_elev)) crs(elev) = crs_elev else crs(elev) = crs(elev)
  # If crs is not set but elevation data has no crs, create a warning
  if (is.na(crs(elev))) warning("Input data has no CRS.", call. = FALSE)
  # Set the output filename if not given. Defaults to the same path and name of input data
  # with an .sgrd extension
  if (is.na(out_filename)) out_filename =  sub('.[^.]*$', '', elev_filename)
  # Write raster to disk
  writeRaster(
    elev, out_filename, format = 'SAGA',
    overwrite = overwrite, NAflag = 0, prj = TRUE
  )
}
