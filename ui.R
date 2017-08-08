library(shiny)

shinyUI(fluidPage(
  titlePanel("Flavors of Music"),
  
  sidebarPanel(
    sliderInput("energySlider", "Energy:", min = 0, max = 1.0, value = c(0, 1.0), step = 0.1, dragRange = TRUE),
    actionButton("recommendButton", "Recommend!")
  ),
  mainPanel(
    tableOutput("recommendTable")
  )
  
)
)
