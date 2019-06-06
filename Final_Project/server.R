#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#

library(shiny)
library(dplyr)
library(stringr)
library(spotifyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(DT)
source('ui.R')
source('access_token.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # URL info for links to repo and documentation
  repoUrl <- a("GitHub Repo", href="https://github.com/ryanzlee/info_201_group_project")
  spotifyrUrl <- a("Spotifyr Documentation", href="https://www.rdocumentation.org/packages/spotifyr/versions/1.0.0")
  
  ############### REACTIVE ELEMENTS #################
    # Creates reactive data frame for selected Top 50s Chart Country
    chosen_playlist <- reactive({
      # Retrieves playlist dataframe using Spotify API codes
      chosen_code <- playlist_codes[playlist_codes$Country == input$Country, "Code"]
      if(chosen_code == "-") {
        chosen_code <-  input$customPlaylist
      }
      
      playlist <- get_playlist(chosen_code)
      playlist <- data.frame(playlist[['tracks']][['items']], stringsAsFactors = FALSE)
      
      # Seperates only need columns to be used and displayed.
      playlist <- select(playlist, track.name, track.id, track.album.name, track.album.release_date, track.popularity)
      
      # Get audio features for each song.
       track_features <- get_track_audio_features(playlist$track.id)
       colnames(track_features)[colnames(track_features)== "id"] <- "track.id"
       testt <- right_join(playlist, track_features, by = "track.id")
       
    })
    
    # Reactive gathers data frame of audio features for certain track
    chosen_song <- reactive({
    playlist_df <- chosen_playlist()
    song_data <- playlist_df[playlist_df$track.name == input$x_var, ]
    wanted_song_data <- song_data %>% select(danceability, energy, speechiness, acousticness,
                                             instrumentalness, liveness, valence)
    refined_song <- wanted_song_data %>% gather(key = "Features", value = "Amount")
    refined_song
  })
   
    # Reactive that calculates average tempo of playlist
    avgTempo <- reactive ({
      testt <- chosen_playlist()
      avg <- round(mean(testt$tempo),1)
    })
    
    # Calculates the average length of chosen playlist
    avgLength <- reactive ({
      testt <- chosen_playlist()
      avg <- round(mean(testt$duration_ms)/1000,1)
    })
  
  ############### RENDERS ###############
  ### Text ###
    # Outputs text for average tempo
    output$tempoText <- renderText({
      paste("Average Tempo: (beat/min)", avgTempo())
    })
    
    # Outputs average song length of chosen playlist
    output$lengthText <- renderText({
      paste("Average Song Length (s):", avgLength())
    })
  
  ### Plot ###
    # Creates plotly of tempo frequencies in playlist
    output$tempoChart <- renderPlotly({
      testt <- chosen_playlist()
      plot <- ggplot(data = testt) +
        stat_bin(aes(x = tempo), binwidth = 5) +
        ggtitle("Tempo (beats/minute) Frequencies in Playlist")
      
      ggplotly(plot)
    })
    
    # Creates pie chart of key frequencies in playlist
    output$keyPie <- renderPlot ({
      testt <- chosen_playlist()
      ee <- c(0:12)
      keys <- as.data.frame(table(testt$key))
      letterValues <- c("C","C#/Db","D","D#/Eb","E","E#/Fb","F","F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B")
      newKeys <- transform(keys, Key = letterValues[match(keys$Var1, ee)])
      bp <- ggplot(newKeys, aes(x = "", y = Freq, fill = Key, label = Freq)) +
        geom_bar(width = 1, stat = "identity") 
      pie <- bp +
        coord_polar("y", start = 0) +
        ggtitle("Key Frequencies in Playlist")
      pie
    })
    
    # Creates plotly histogram of song length frequencies in playlist
    output$lengthChart <- renderPlotly({
      testt <- chosen_playlist()
      #colnames(testt)[colnames(testt)=="duration_ms"] <- "length"
      testt <- mutate(testt, length = (duration_ms)/1000)
      times <- ggplot(data = testt) +
        stat_bin(aes(x = length), binwidth = 10) + 
        ggtitle("Frequencies of Different Songs Lengths (s) in Playlist")
      ggplotly(times) 
    })
    
    # Creates histogram for danceability features for chosen track
    output$dance_plot <- renderPlot({
      refined_song <- chosen_song()
      ggplot(data = refined_song, aes(x = Features, y = Amount)) +
        geom_bar(stat = "identity") +
        labs(x = "Audio Features", y = "Amount")
    }) 
    
    # Creates plot of a song's portion of total time on album
    output$bargraph <- renderPlot({
      album_data <- data.frame(get_album_tracks(input$AlbumId), stringsAsFactors = FALSE)
      album_data <- album_data %>% select(name,duration_ms) %>% mutate(Length = duration_ms/60000)
      ggplot(album_data, aes(x="",y = Length, fill = name)) +geom_bar(stat = "identity")+ coord_polar("y") +
        scale_color_brewer(palette="Dark2") + ggtitle("Plot of length of every song in the album") + 
        labs(y="Percentage of each song in the whole album",fill = "Name of the songs")
    })
  
  ### Table ###
    # Creates Data table of songs within given playlist
    output$distTable1 <- DT::renderDataTable({
      playlist <- chosen_playlist()
      colnames(playlist)[colnames(playlist)=="track.name"] <- "Track"
      colnames(playlist)[colnames(playlist)=="track.album.name"] <- "Album"
      colnames(playlist)[colnames(playlist)=="track.album.release_date"] <- "Released"
      colnames(playlist)[colnames(playlist)=="track.popularity"] <- "Track Popularity"
      filteredTable <- select(playlist, Track, Album, Released)
    })
  
  ### UI ###
    # Creates dropdown for songs to select from for audio features
    output$dropdown <- renderUI ({
      selectInput(
        "x_var",
        label = "Choose a Song",
        choices = c(chosen_playlist()$track.name)
      )
      
    })
    
    # Creates hyperlink for github repo
    output$repoTab <- renderUI({
      tagList("Github Repository:", repoUrl)
    })
    
    # Creates hyperlink for Spotifyr documentation
    output$docTab <- renderUI({
      tagList("Spotifyr Documentation:", spotifyrUrl) 
    })
})
