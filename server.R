library(shiny)
library(httr)
library(jsonlite)
library(XML)
source("apikeys.R")

base.uri <- "https://api.spotify.com/v1/recommendations"

response <- POST("https://accounts.spotify.com/api/token", 
                 accept_json(),
                 authenticate(client.id, client.secret), 
                 body = list(grant_type = "client_credentials"),
                 encode = "form",
                 verbose()
                 )
token <- content(response)$access_token



shinyServer(function(input, output) {
  songs <- reactive({
    energy.min <- input$energySlider[1]
    energy.max <- input$energySlider[2]
    query.params <- list(min_energy = energy.min, max_energy = energy.max)
    response <- GET(base.uri, query.params, add_headers(Authorization = paste0("Bearer ", token)))
    recommended.playlist <- fromJSON(content(response, "text"))
    return(recommended.playlist)
  })

})
