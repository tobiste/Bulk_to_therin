ui <-
  navbarPage("TD helpers", collapsible = TRUE, inverse = TRUE,

    tabPanel(
      "THERIN Generator",
      fluidPage(

        # App title ----
        titlePanel(
          # "therin generator"),
          # headerPanel(
          h3(
            "THERIN Generator",
            h4("Converts bulk compositions in wt.% to molar compositions that can be pasted into therin file for THERIAK DOMINO"),
            h6("T. Stephan (January 2024)")
          )
        ),
        sidebarLayout(
          sidebarPanel(
            fileInput("file1", "Choose xlsx file",
              accept = c(".xlsx")
            ),
            helpText(
              "Table arranged as oxides in columns and samples in rows.",
              "First column must be the sample label(s).",
              "Column headers must be named as Al2O3, SiO2, etc.",
              "Note: Only able to consider total Fe compositions."
            ),

            # checkboxInput("norm_dry", "Normalize to dry conditions", value = FALSE),

            numericInput("DL", "Detection limit factor", value = 2 / 3),

            # checkboxInput("iron", "Total iron = Fe2O3", value = TRUE),


            textInput("system", "System", value = "MnNCKFMASHT"),
            numericInput("O", "Oxygen", value = NA, min = 0, max = 100),
            helpText('Leave blank for "?".'),
            numericInput("H", "Water", value = 80, min = 0, max = 100),
            numericInput("round", "Precision", value = 4, min = 0, max = 10),
            textInput("sample", "Sample", value = "Enter sample name..."),
            helpText("Leave blank to convert all samples in file."),
          ),
          mainPanel(
            h3("THERIN (mol)"),
            verbatimTextOutput("therin", placeholder = TRUE),
            h3("Compositions (wt.%)"),
            dataTableOutput("file2")
          )
        )
      )
    ),




    tabPanel("GUZZLER Filter",
             fluidPage(
               titlePanel(
                 # "therin generator"),
                 # headerPanel(
                 h3(
                   "GUZZLER table filter",
                   h4("Extracts a mineral from the GUZZLER reaction table"),
                   h6("T. Stephan (January 2024)")
                 )
               ),
               sidebarLayout(
                 sidebarPanel(
                   fileInput("file2", "Choose table file"),
                   textInput("mineral", "Mineral", value = "Enter mineral...")
                 ),
               mainPanel(
                 h3("TABLE file"),
                 tableOutput("therin")
               )
               )
             )
             )
    )
