library(shiny)
library(datasets)

mtcarsData <- mtcars
mtcarsData$am <- factor(mtcarsData$am, labels = c("Automatic", "Manual"))

shinyServer(function(input, output) {
  
  formulaText <- reactive({
    validate(
      need(
        input$cyl ||
          input$disp ||
          input$hp ||
          input$drat ||
          input$wt ||
          input$am ||
          input$qsec ||
          input$gear ||
          input$carb,
        "No factors selected! Please select atleast 1 factor.")
    )
    paste("mpg~",
      substr(
        paste(ifelse(input$cyl,"+cyl",""),
          ifelse(input$disp,"+disp",""),
          ifelse(input$hp,"+hp",""),
          ifelse(input$drat,"+drat",""),
          ifelse(input$wt,"+wt",""),
          ifelse(input$am,"+am",""),
          ifelse(input$qsec,"+qsec",""),
          ifelse(input$gear,"+gear",""),
          ifelse(input$carb,"+carb",""),
          sep = ""
        ), 2, 1000
      ), sep = ""
    )
  })
  
  fit <- reactive({
    lm(as.formula(formulaText()), data=mtcarsData)
  })
  
  output$caption <- renderText({
    paste("Formula:", formulaText())
  })
  
  output$mpgPairsPlot <- renderPlot({
    panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
    {
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      r <- abs(cor(x, y))
      txt <- format(c(r, 0.123456789), digits = digits)[1]
      txt <- paste0(prefix, txt)
      if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
      text(0.5, 0.5, txt, cex = cex.cor * r)
    }
    pairs(as.formula(formulaText()), data = mtcarsData, lower.panel = panel.smooth, upper.panel = panel.cor)
  })
  
  output$fit <- renderPrint({
    summary(fit())
  })
  
  output$mpgResidualPlot <- renderPlot({
    x <- fit()$residuals
    h <- hist(x, breaks = 10, col = "red", xlab = "Residuals", main = "Histogram with Normal Curve")
    xfit <- seq(min(x), max(x), length = 40)
    yfit <- dnorm(xfit, mean = mean(x), sd = sd(x))
    yfit <- yfit * diff(h$mids[1:2]) * length(x)
    lines(xfit, yfit, col = "blue", lwd = 2)
  })
  
})
