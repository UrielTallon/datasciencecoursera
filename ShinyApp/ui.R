library(shiny)
library(lattice)
library(plotly)

shinyUI(
  fluidPage(
    theme = shinythemes::shinytheme("paper"),
    titlePanel("Wine Cultivars"),
    sidebarLayout(
      sidebarPanel(
        h4("Parameters:"),
        sliderInput("seed", "Set seed", min = 0, max = 200, value = 10, step = 1, round = TRUE),
        uiOutput("xvarSelect"),
        uiOutput("yvarSelect"),
        #numericInput("clusters", "Number of clusters", 2, min = 1, max = 10, step = 1),
        actionButton("draw", "Draw Plot"),
        hr(),
        h4("Accuracy:"),
        verbatimTextOutput("acc")
      ),
    mainPanel(
      plotlyOutput("thePlot")
    )
    )
  )
)