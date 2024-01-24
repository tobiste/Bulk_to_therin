ui <- fluidPage(

  # App title ----
  titlePanel("therin generator"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose xlsx file',
                accept = c(".xlsx")),
      helpText("First row must contain sample label"),

      #checkboxInput("norm_dry", "Normalize to dry conditions", value = FALSE),

      numericInput("DL", "Detection limit factor", value = 2/3),

      checkboxInput("iron", "Total iron = Fe2O3", value = TRUE),
      helpText("Note: so far only able to consider total Fe compositions"),

      textInput("sample", "Sample", value = "Enter sample name..."),

      textInput("system", "System", value = "MnNCKFMASHT"),

      numericInput("O", "Oxygen", value = NA, min = 0, max = 100),
      helpText('If blank, it puts "?" for the O compositions'),

      numericInput("H", "Water", value = 80, min = 0, max = 100),

      numericInput("round", "Precision", value = 4, min = 0, max = 10)
    ),

    mainPanel(
      h3("THERIN (mol)"),
      verbatimTextOutput("therin", placeholder = TRUE),

      h3("Compositions (wt.%)"),
      dataTableOutput('file2')
    )
    )
  )


