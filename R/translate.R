#' Batch convert resulting derivatives to GeoTIFF
#'
#' Assuming several derivatives have been computed, this function will map over
#' directory of resulting terrain derivatives and translate the files into TIFF
#' format if not yet existing. To translate a single file from SAGA to GeoTIFF
#' format better use \code{gdalUtils::gdal_translate()}.
#'
#' @details If the elevation file resulting from \code{elev_to_sgrd()} is
#'          present in the out_dir_to_translate, it will give a warning and will
#'          not convert the file to TIF, since the driver is corrupted.
#'          To refer to elevation data always use the original file.
#'
#' @param out_dir_to_translate directory containing outputs from
#'                             \code{elev_to_*()}. Resulting TIFF files will be
#'                             saved in this directory as well.
#' @param out_crs CRS information is lost within SAGA processes, it is therefore
#'                the need to reset it at the end of the process. Here one can
#'                give CRS information of the original elevation file used to
#'                create the derivatives. This can be obtained with
#'                \code{terra::crs(elev_filename)}. If the original elevation
#'                file does not have a CRS, then pass the corresponding CRS
#'                information as WKT, PROJ.4 or EPSG values.
#'
#' @importFrom gdalUtils gdal_translate remove_file_extension
#' @importFrom here here
#' @importFrom rlang is_empty
#' @importFrom strex str_after_first
#' @importFrom stringr str_replace
#' @importFrom foreach foreach %dopar%
#'
#' @export
terrain_to_tif = function(out_dir_to_translate, out_crs = NULL) {
  # Get filenames in .sdat format for the computed derivatives as a vector
  file_names_sdat = list.files(
    path = out_dir_to_translate,
    pattern = ".sdat$",
    full.names = F
  )

  # Create a vector with the names but with a .tif extension
  file_names_tif = str_replace(
    file_names_sdat,
    ".sdat$",
    ".tif"
  )

  # Check if there are .tif files with the same name already existing
  # in the directory
  existing_files = c(
    str_after_first(
      list.files(
        path = out_dir_to_translate,
        pattern = ".tif$",
        full.names = F,
        recursive = T
      ),
    '/'),
    list.files(
      path = out_dir_to_translate,
      pattern = ".tif$",
      full.names = F
    )
  )

  existing_files = existing_files[!is.na(existing_files)]

  files_to_translate = str_replace(
    file_names_tif[!(file_names_tif %in% existing_files)],
    ".tif", '.sdat'
  )

  files_for_translation = here(out_dir_to_translate, files_to_translate)

  ## From gdalUtils (deprecated package)
  ## https://github.com/gearslaboratory/gdalUtils/blame/master/R/batch_gdal_translate.R
  ## (c) Jonathan Asher Greenberg (\email{gdalUtils@@estarcion.net}), 2020

  batch_translate = function(infiles, outdir, outsuffix = "_conv.tif",
                             verbose=FALSE, ...) {
    # These are just to avoid errors in CRAN checks.
    infile = NULL
    outfile = NULL

    # Generate output names.
    outfiles = sapply(infiles,function(x,outsuffix,outdir=outdir)
    {
      outfilename = paste(remove_file_extension(basename(x)),outsuffix,sep="")
      outfilepath = normalizePath(file.path(outdir,outfilename),mustWork=FALSE)
    },outsuffix=outsuffix,outdir=outdir)

    outputs = foreach(infile=infiles,outfile=outfiles,.packages="gdalUtils") %dopar%
      {
        gdal_translate(src_dataset=infile,dst_dataset=outfile,verbose=verbose,...)
      }
  }
  if (!is_empty(files_for_translation)) {
    ## Setting parameters
    params = list(
      infiles = files_for_translation,
      outdir = out_dir_to_translate,
      outsuffix = ".tif",
      a_srs = if(!is.null(out_crs)) out_crs,
      verbose = TRUE
    )

    do.call(batch_translate, params[lengths(params) > 0])
    return(NA)
  } else {
    message("All files have been translated.")
    return(NA)
  }
}
