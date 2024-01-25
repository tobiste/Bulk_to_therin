tbl <- read.delim("C:/td/Working/table", sep = ":", header  = F) |>
  tidyr::separate(V2, into = c("IN", "OUT"), "=", remove = TRUE) |>
  dplyr::select(-V1)



dplyr::filter(tbl,
       grepl("sill", IN) | grepl("sill", OUT)
       ) |>
  dplyr::filter(!(grepl("sill", IN) & grepl("sill", OUT)))
