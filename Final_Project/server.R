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
library(ggplot2)
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
      playlist <- select(playlist, track.name, track.id)
    # playlist <- select(playlist, track.name, track.album.name, track.album.release_date, track.popularity, )
    # colnames(playlist)[colnames(playlist)=="track.name"] <- "Track"
    # colnames(playlist)[colnames(playlist)=="track.album.name"] <- "Album"
    # colnames(playlist)[colnames(playlist)=="track.album.release_date"] <- "Date Released"
    # colnames(playlist)[colnames(playlist)=="track.popularity"] <- "Track Popularity"
    
    # Get audio features for each song.
     track_features <- get_track_audio_features(playlist$track.id)
     colnames(track_features)[colnames(track_features)== "id"] <- "track.id"
     testt <- right_join(playlist, track_features, by = "track.id")
     
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
  
  output$tempoChart <- renderPlot({
    testt <- chosen_playlist()
    plot <- ggplot(data = testt) +
      stat_bin(aes(x = tempo), binwidth = 5)
    print(plot)
  })

  avgTempo <- reactive ({
    testt <- chosen_playlist()
    avg <- round(mean(testt$tempo),1)
  })
  
  output$tempoText <- renderText({
    paste("Average tempo among songs in playlist:", avgTempo())
  })
  
  output$keyPie <- renderPlot ({
    testt <- chosen_playlist()
    ee <- c(0:12)
    keys <- as.data.frame(table(testt$key))
    letterValues <- c("C","C#/Db","D","D#/Eb","E","E#/Fb","F","F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B")
    newKeys <- transform(keys, Key = letterValues[match(keys$Var1, ee)])
    bp <- ggplot(newKeys, aes(x = "", y = Freq, fill = Key, label = Freq)) +
      geom_bar(width = 1, stat = "identity") + scale_colour_gradient(low = "#B22222", high = "#FF0000") #color scale doesn't seem to work
    pie <- bp + coord_polar("y", start = 0) 
    
    print(pie)
  })
  
  custom_playlist <- reactive ({
    chosen_code <- input$customPlaylist
    playlist <- get_playlist(chosen_code)
    playlist <- data.frame(playlist[['tracks']][['items']], stringsAsFactors = FALSE)
    
    # Seperates only need columns to be used and displayed.
    playlist <- select(playlist, track.name, track.id)
    # playlist <- select(playlist, track.name, track.album.name, track.album.release_date, track.popularity, )
    # colnames(playlist)[colnames(playlist)=="track.name"] <- "Track"
    # colnames(playlist)[colnames(playlist)=="track.album.name"] <- "Album"
    # colnames(playlist)[colnames(playlist)=="track.album.release_date"] <- "Date Released"
    # colnames(playlist)[colnames(playlist)=="track.popularity"] <- "Track Popularity"
    
    # Get audio features for each song.
    track_features <- get_track_audio_features(playlist$track.id)
    colnames(track_features)[colnames(track_features)== "id"] <- "track.id"
    testt <- right_join(playlist, track_features, by = "track.id")
  }) 
  
  output$distTable1 <- renderTable({
    chosen_playlist()
  })
  
})
