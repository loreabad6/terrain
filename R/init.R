#' Initiate SAGA environment
#'
#' @description Initiates the SAGA environment before running any other RSAGA function.
#'              Assign the result of this function to an "env" object
#'              in the R Global Environment.
#'
#' @param path path to saga portable installation
#' @param modules path to saga modules, defaults to the tools directory in the SAGA path
#'
#' @importFrom RSAGA rsaga.env
#' @importFrom here here
#'
#' @export
init_saga = function(path, modules = NULL) {
  # Set modules directory
  modules = if (!is.null(modules)) here(path, "tools")
  # Set SAGA environment
  rsaga.env(path = path, modules = modules)
}
