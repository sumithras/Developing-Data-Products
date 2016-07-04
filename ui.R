library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel("Car mileage analysis using linear regression"),
    sidebarPanel(
      titlePanel("Select factors:"),
      checkboxInput("cyl", "Cylinders (cyl)", TRUE),
      checkboxInput("disp", "Displacement (disp)", FALSE),
      checkboxInput("hp", "Gross horsepower (hp)", FALSE),
      checkboxInput("drat", "Rear axle ratio (drat)", FALSE),
      checkboxInput("wt", "Weight (wt)", FALSE),
      checkboxInput("am", "Transmission (0 = automatic, 1 = manual) (am)", FALSE),
      checkboxInput("qsec", "1/4 mile time (qsec)", FALSE),
      checkboxInput("gear", "Number of forward gears (gear)", FALSE),
      checkboxInput("carb", "Number of carburetors (carb)", FALSE)
    ),
                      
    mainPanel(
      h3(textOutput("caption")),
      tabsetPanel(type = "tabs", 
        tabPanel("Regression model", 
                 verbatimTextOutput("fit"),
                 plotOutput("mpgResidualPlot")
        ),
        tabPanel("PairsPlot", plotOutput("mpgPairsPlot"))
      )
    )
  )
)
