# # Convert results to .tif ----
#
# library(gdalUtils)
# library(stringr)
#
# dir_path_to_translate = "./terrain/out_products/"
# files_short = list.files(path = dir_path_to_translate, pattern = ".sdat$", full.names = F)
# files_as_tif = str_replace(files_short, ".sdat$", ".tif")
# existing_files = c(
#   list.files(
#     path = "./terrain/derivatives",
#     pattern = ".tif$",
#     full.names = F,
#     recursive = T
#   ) %>% strex::str_after_first('/'),
#   list.files(
#     path = "./terrain/derivatives",
#     pattern = ".tif$",
#     full.names = F
#   )
# )
#
# existing_files = existing_files[!is.na(existing_files)]
#
# '%!in%' = function(x,y)!('%in%'(x,y))
#
# files_to_translate = files_as_tif[files_as_tif %!in% existing_files] %>%
#   str_replace(".tif", '.sdat')
#
# files_for_translation = file.path(paste0(dir_path_to_translate,files_to_translate))
#
# batch_gdal_translate(
#   infiles = files_for_translation,
#   outdir = "./terrain/derivatives",
#   outsuffix = ".tif"
# )
