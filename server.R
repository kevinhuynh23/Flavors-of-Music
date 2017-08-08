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
    query.params <- list(min_acousticness = input$acousticSlider[1],
                         max_acousticness = input$acousticSlider[2],
                         min_danceability = input$danceSlider[1],
                         max_danceability = input$danceSlider[2],
                         min_energy = input$energySlider[1],
                         max_energy = input$energySlider[2],
                         min_popularity = input$popularSlider[1],
                         max_popularity = input$popularSlider[2],
                         min_valence = input$valenceSlider[1],
                         max_valence = input$valenceSlider[2]
                         )
    response <- GET(base.uri, query.params, add_headers(Authorization = paste0("Bearer ", token)))
    recommended.playlist <- fromJSON(content(response, "text"))
    return(recommended.playlist)
  })
  

})
