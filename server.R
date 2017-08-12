library(shiny)
library(httr)
library(jsonlite)
library(XML)
library(dplyr)
source("apikeys.R")

base.uri <- "https://api.spotify.com/v1/recommendations"
base.widget.uri <- "https://open.spotify.com/embed?uri="

# Spotify client credential authorization
response <- POST("https://accounts.spotify.com/api/token", 
                 accept_json(),
                 authenticate(client.id, client.secret), 
                 body = list(grant_type = "client_credentials"),
                 encode = "form",
                 verbose()
)
token <- content(response)$access_token

# Retrieving list of available genres
response <- GET("https://api.spotify.com/v1/recommendations/available-genre-seeds",
                add_headers(Authorization = paste0("Bearer ", token)))
genres <- fromJSON(content(response, "text"))$genres %>% 
  as.list()

shinyServer(function(input, output, session) {
  
  # Update genres selectize input with retrieved genres
  updateSelectizeInput(session, "genres", choices = genres, options = list(maxOptions = 5))
  
  # Update and store parameters as they are being changed
  query.params <- reactive({
    params <- list(seed_genres = input$genres,
                   min_acousticness = input$acousticSlider[1],
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
    return(params)
  })
  
  # Get songs based on user parameters and dynamically create spotify widgets for them
  observeEvent(input$recommendButton, {
    req(input$genres)  # requires genre selection
    
    removeUI(selector = "#placeholder p", multiple = TRUE)  # Removes all previous Spotify widgets
    
    response <- GET(base.uri,
                    accept_json(),
                    query = query.params(),
                    add_headers(Authorization = paste0("Bearer ", token)),
                    encode = "form",
                    verbose()
    )
    recommendations.object <- fromJSON(content(response, "text"))
    songs <- as.data.frame(recommendations.object)  # Dataframe of recommended songs
    
    for(i in 1:nrow(songs)) {  # Loops through number of songs and adds widgets for all
      song <- songs[i, ]
      source.uri <- URLencode(song$tracks.uri, reserved = TRUE)
      source.uri <- paste0(base.widget.uri, source.uri)
      widget <- tags$p(htmlOutput("widget",
                                    container = tags$iframe,
                                    src = source.uri,
                                    width = "250",
                                    height = "330",
                                    frameborder = "0",
                                    allowTransparency = TRUE
      ),
      id = "widget"
      )
      insertUI(selector = "#placeholder", where = "beforeEnd", ui = widget)
    }
  })
  
  
  
  
  
})
