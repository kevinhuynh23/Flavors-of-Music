library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("sandstone"),
  titlePanel("Flavors of Music"),
  
  sidebarPanel(
    selectizeInput("genres", "Genres*", choices = NULL),
    sliderInput("acousticSlider", "Acousticness:", min = 0, max = 1.0, value = c(0, 1.0), step = 0.1, dragRange = TRUE),
    sliderInput("danceSlider", "Danceability:", min = 0, max = 1.0, value = c(0, 1.0), step = 0.1, dragRange = TRUE),
    sliderInput("energySlider", "Energy:", min = 0, max = 1.0, value = c(0, 1.0), step = 0.1, dragRange = TRUE),
    sliderInput("popularSlider", "Popularity:", min = 0, max = 100, value = c(0, 100), step = 10, dragRange = TRUE),
    sliderInput("valenceSlider", "Valence:", min = 0, max = 1.0, value = c(0, 1.0), step = 0.1, dragRange = TRUE),
    actionButton("recommendButton", "Recommend!")
  ),
  mainPanel(
    verticalLayout(
      tags$div(id = "placeholder") 
    )
  )
  
)
)
