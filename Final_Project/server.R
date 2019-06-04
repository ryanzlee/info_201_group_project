#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(stringr)
library(spotifyr)
library(tidyr)
source('ui.R')
source('access_token.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # Creates data frame for selected Top 50s Chart Country
  chosen_playlist <- reactive({
    # Retrieves playlist dataframe using Spotify API codes
    chosen_code <- playlist_codes[playlist_codes$Country == input$Country, ]
    playlist <- get_playlist(chosen_code$Code)
    playlist <- data.frame(playlist[['tracks']][['items']], stringsAsFactors = FALSE)
    
    # Seperates only need columns to be used and displayed.
    playlist <- select(playlist, track.name, track.album.name, track.album.release_date, track.popularity)
    colnames(playlist)[colnames(playlist)=="track.name"] <- "Track"
    colnames(playlist)[colnames(playlist)=="track.album.name"] <- "Album"
    colnames(playlist)[colnames(playlist)=="track.album.release_date"] <- "Date Released"
    colnames(playlist)[colnames(playlist)=="track.popularity"] <- "Track Popularity"
    
    playlist
  })
  
  artist_names <- reactive({
    chosen_code <- playlist_codes[playlist_codes$Country == input$Country, ]
    playlist <- get_playlist(chosen_code$Code)
    for (i in 1:50) {
      playlist <- data.frame(playlist[['tracks']][['items']][['track.artists']][[i]], stringsAsFactors = FALSE)
      name_holder <- ''
      artist_names <- ''
      for (j in 1:nrow(playlist)) {
        name_holder <- playlist[j, playlist$name]
        artist_names <- cat(artist_names, name_holder)
      }
    }
    
  })
  
  output$infoText1 <- renderText(
    paste("This visulization shows info of the top 50 Chart from different countries.\n
          The current date is: ", Sys.Date())
  )
  
  output$distTable1 <- renderTable({
    chosen_playlist()
  })
  
})
