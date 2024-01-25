server <- function(input, output) {
  load_file <- reactive({
    inFile <- input$file1

    if (is.null(inFile)) {
      return(NULL)
    } else {
      data <- readxl::read_excel(inFile$datapath) |>
        dplyr::rename(Sample = 1)

      data_corr <- dplyr::select(data, -Sample) %>%
        dplyr::mutate_all(
          function(x) {
            ifelse(x %in% c("<0.002", "<0.01", "<5", "<0.5", "<0.1", "<0.02", "<0.005", "<1", "<2", "<0.05", "<0.001", "<0.2"), # set DL to DL/2 (Farnham et al., 2002)
              as.numeric(gsub("<", "", x)) * input$DL,
              as.numeric(x)
            )
          }
        )
      data <- data.frame(Sample = data$Sample, data_corr)
      if(is.null(data$FeO)){
        data <- mutate(data, FeO = 0)
      }
      if(is.null(data$Fe2O3)){
        data <- mutate(data, Fe2O3 = 0)
      }
          # if(input$norm_dry) data <- norm_dry(data)
      return(data)
    }
  })

  output$file2 <- renderDataTable({
    load_file()
  })

  sample_select <- reactive({
    data <- load_file()
    if (!is.null(data)) {
      choosen_one <- input$sample
      if (choosen_one == "Enter sample name...") {
        NULL
      } else {
        dplyr::filter(
          data,
          Sample == input$sample
        )
      }
    } else {
      NULL
    }
  })

  therin_gen2 <- reactive({
    data <- sample_select()

    if (!is.null(data)) {
      # colnames <- colnames(data)[, 2:ncol(data)]
      sample <- data |>
        dplyr::mutate(FeO = FeO + Fe2O3) |>  # only consider total iron
        dplyr::select("SiO2", "Al2O3", "FeO", "CaO", "MgO", "Na2O", "K2O", "Cr2O3", "TiO2", "MnO", "P2O5", "SrO", "BaO") |>
        t() |>
        c()
      names(sample) <- c("SiO2", "Al2O3", "FeO", "CaO", "MgO", "Na2O", "K2O", "Cr2O3", "TiO2", "MnO", "P2O5", "SrO", "BaO")

      O <- input$O
      if (is.na(O)) {
        O <- "?"
      }

      WR_to_TD(sample, system = input$system, H = input$H, O = O, round = input$round, cmt = input$sample)
    } else {
      return(NULL)
    }
  })

  therin_gen <- reactive({
    all_data <- load_file()
    if (!is.null(all_data)) {
      text <- character()
      for(i in all_data$Sample){
        data <- all_data |> filter(Sample == i)
      # colnames <- colnames(data)[, 2:ncol(data)]
      sample <- data |>
        dplyr::mutate(FeO = FeO + Fe2O3) |>  # only consider total iron
        dplyr::select("SiO2", "Al2O3", "FeO", "CaO", "MgO", "Na2O", "K2O", "Cr2O3", "TiO2", "MnO", "P2O5", "SrO", "BaO") |>
        t() |>
        c()
      names(sample) <- c("SiO2", "Al2O3", "FeO", "CaO", "MgO", "Na2O", "K2O", "Cr2O3", "TiO2", "MnO", "P2O5", "SrO", "BaO")

      O <- input$O
      if (is.na(O)) {
        O <- "?"
      }

      text <- paste(text, WR_to_TD(sample, system = input$system, H = input$H, O = O, round = input$round, cmt = i), "\n")
      }
      text
    } else {
      return(NULL)
    }
  })


  output$therin <- renderText({
    if( input$sample %in% c("Enter sample name...", "") ){
      therin_gen()
    } else {
      therin_gen2()
    }
  })
}
