#' Convert elevation data into SAGA format
#'
#' @details Beware, this function will convert a TIF file into SAGA format,
#'          but for some reason, the output file loses its CRS and is not
#'          recognized properly by GDAL drivers. It will still work for
#'          calculating derivatives but the file should not be used directly
#'          for other purposes. Always refer to the original elevation file.
#'
#' @param elev_filename filename in disk of the elevation raster data
#' @param out_filename output filename, defaults to
#'                     \code{[elev_filename].sgrd}
#' @param overwrite boolean, default to TRUE, should the output file be
#'                  overwritten?
#'
#' @importFrom terra rast writeRaster
#'
#' @export
elev_to_sgrd = function(elev_filename, out_filename = NA,
                        overwrite = TRUE) {
  # Load elevation data into R with raster
  elev = rast(elev_filename)
  # Set the output filename if not given. Defaults to the same path and
  # name of input data with an .sgrd extension
  if (is.na(out_filename)) out_filename =  sub('.[^.]*$', '', elev_filename)
  # Write raster to disk
  writeRaster(
    elev, out_filename, filetype = 'SAGA',
    overwrite = overwrite, NAflag = 0
  )
}
