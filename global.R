library(shiny)
library(dplyr)


identify_oxide <- function(x) {
  x_split <- stringr::str_split(x, "(?<=.)(?=[A-Z])", simplify = TRUE) |> as.vector()


  elements <- gsub("[0-9]+", "", x_split)
  numbers <- stringr::str_extract(x_split, "[0-9]+")

  data.frame(M1 = elements[1], n1 = numbers[1], M2 = elements[2], n2 = numbers[2]) |>
    dplyr::mutate(
      n1 = ifelse(is.na(n1), 1L, as.integer(n1)),
      n2 = ifelse(is.na(n2), 1L, as.integer(n2))
    )
}


molecular_weight <- function(x) {
  elements <- identify_oxide(x)
  elements$n1 * PeriodicTable::mass(elements$M1) + elements$n2 * PeriodicTable::mass(elements$M2)
}

wt_to_molwt <- function(x){
  d <- data.frame("oxides" = names(x), "wt" = x)
  f <- cbind(t(sapply(d$oxides, identify_oxide)))[, 2]
  (d$wt / sapply(d$oxides, molecular_weight) * 100) * as.numeric(f)
}

# Whole Rock data to Mol wt. % in Theriak-Domino Input format "THERIN"
WR_to_TD <- function(x,
                     # system = c("MnNCKFMASHT", "CMASH", "NASH", "KASH", "NCMASH", "NCFMASH", "NFMASH", "KFMASH", "MnKFMASH", "MnNCKFMASH", "MnCKFMASH", "MnNCKFMASHT", "MnCKFMASHT"),
                     system,
                     H = NULL, O = NULL, round = 4, cmt = NULL){
  #system <- match.arg(system)

  y <- wt_to_molwt(x) |>
    round(round)
  comp <- "0  "

  # if(system == "MnNCKFMASHT"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")CA(", y["CaO"], ")NA(", y["Na2O"], ")K(", y["K2O"], ")TI(", y["TiO2"], ")" )
  # }
  # if(system == "MnKFMASHT"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")K(", y["K2O"], ")TI(", y["TiO2"], ")" )
  # }
  # if(system == "MnKFMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")K(", y["K2O"], ")" )
  # }
  # if(system == "MnCKFMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")CA(", y["CaO"], ")K(", y["K2O"], ")" )
  # }
  # if(system == "MnCKFMASHT"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")CA(", y["CaO"], ")K(", y["K2O"], ")TI(", y["TiO2"], ")" )
  # }
  # if(system == "MnNCKFMASHT"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")CA(", y["CaO"], ")NA(", y["Na2O"], ")K(", y["K2O"], ")TI(", y["TiO2"], ")" )
  # }
  # if(system == "MnNCKFMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")CA(", y["CaO"], ")NA(", y["Na2O"], ")K(", y["K2O"], ")" )
  # }
  # if(system == "NCMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")MG(", y["MgO"], ")CA(", y["CaO"], ")NA(", y["Na2O"], ")")
  # }
  # if(system == "CMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")MG(", y["MgO"], ")CA(", y["CaO"], ")")
  # }
  # if(system == "NASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")NA(", y["Na2O"], ")")
  # }
  # if(system == "KASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")K(", y["K2O"], ")")
  # }
  # if(system == "NCFMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")CA(", y["CaO"], ")NA(", y["Na2O"], ")")
  # }
  # if(system == "NFMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")NA(", y["Na2O"], ")")
  # }
  # if(system == "KFMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")K(", y["K2O"], ")")
  # }
  # if(system == "MnNCKFMASHT"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")FE(", y["FeO"], ")MG(", y["MgO"], ")MN(", y["MnO"], ")CA(", y["CaO"], ")NA(", y["Na2O"], ")K(", y["K2O"], ")TI(", y["TiO2"], ")" )
  # }
  # if(system == "NCMASH"){
  #   comp <- paste0(
  #     "SI(", y["SiO2"], ")AL(", y["Al2O3"], ")MG(", y["MgO"], ")CA(", y["CaO"], ")NA(", y["Na2O"], ")")
  # }
  if(grepl("S", system)){
    comp <- paste0(comp, "SI(", y["SiO2"], ")")
  }
  if(grepl("A", system)){
    comp <- paste0(comp, "AL(", y["Al2O3"], ")")
  }
  if(grepl("F", system)){
    comp <- paste0(comp, "FE(", y["FeO"], ")")
  }
  if(grepl("M", system)){
    comp <- paste0(comp, "MG(", y["MgO"], ")")
  }
  if(grepl("Mn", system)){
    comp <- paste0(comp, "Mn(", y["MnO"], ")")
  }
  if(grepl("C", system)){
    comp <- paste0(comp, "CA(", y["CaO"], ")")
  }
  if(grepl("N", system)){
    comp <- paste0(comp, "NA(", y["Na2O"], ")")
  }
  if(grepl("K", system)){
    comp <- paste0(comp, "K(", y["K2O"], ")")
  }
  if(grepl("T", system)){
    comp <- paste0(comp, "TI(", y["TiO2"], ")")
  }

  if(!is.null(H)){
    comp <- paste0(comp, "H(", H, ")")
  }
  if(!is.null(O)){
    comp <- paste0(comp, "O(", O, ")")
  }
  if(!is.null(cmt)){
    comp <- paste0(comp, "  *  ", cmt, "  ", system)
  }
  comp
}

