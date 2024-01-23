ui <- fluidPage(

  # App title ----
  titlePanel("therin generator"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose xlsx file',
                accept = c(".xlsx")),

      #checkboxInput("norm_dry", "Normalize to dry conditions", value = FALSE),

      numericInput("DL", "Detection limit factor", value = 2/3),

      textInput("sample", "Sample", value = "Enter sample name..."),

      selectInput("system", "System", choices = list(
        "CMASH", "NASH", "KASH", "NCMASH", "NCFMASH", "NFMASH", "KFMASH", "MnKFMASH", "MnNCKFMASH", "MnNCKFMASHT", "MnCKFMASH", "MnCKFMASHT"),
        selected  = "MnNCKFMASHT"),

      numericInput("O", "Oxygen", value = NA, min = 0, max = 100),

      numericInput("H", "Water", value = 80, min = 0, max = 100),

      numericInput("round", "Precision", value = 4, min = 0, max = 10)
    ),

    mainPanel(
      tableOutput('file2'),
      verbatimTextOutput("therin")
    )
    )
  )


