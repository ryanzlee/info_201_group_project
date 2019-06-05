#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)
library(DT)
source('access_token.R')

# Reads in Top 50 playlist for each country using csv file; Contains country and API code
playlist_codes <- read.csv('country_playlist_codes.csv', stringsAsFactors = FALSE)
country_list <- unique(playlist_codes$Country)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Application title
  theme = shinytheme("flatly"),
  titlePanel(title = "Statify"),
  
  # UI set up in tabsets each containing sidebar and main panel.
  # Contains different visualizations and widgets in each.
  tabsetPanel(
    tabPanel("Our Mission",
      fluidPage(
        fluidRow(
          column(5, offset = 5,
             h1("Statify")
          ),
          column(10, offset = 1,
             h1("An application for the stats-loving audiophile, designed for Spotify")
          )
        ),
        fluidRow(
          column(10, offset = 1,
            h3("This interactive application provides seemless integration of access
                and exploring of audio features for various tracks, albums, and playlist
                within Spotify. Utilizing Spotify's Web API in addition to the Spotifyr package
                in R, users are able to easily access a variety of information about audio
                features that Spotify keeps hidden.\n
                In this application users will be able to access playlist data, track data, and
                album data to obtain information about features such as danceability and tempo. \n
                When dealing with data of top charts, and song hits, an interesting question to explore
                is what makes a song popular among the population? The criteria is very subjective and
                vague, but studies have indicated that songs should feel somewhat familiar in a good way,
                but also unique enough to be new and exciting. Lyrically, it is often a plus point if the 
                song has themes that are relatable to many, like family, or forbidden love, etc. But all 
                all, what makes a song popular is very random, and up to some level of chance as well. 
                Exploring our data and visualizations, it is possible to find some patterns and correlation,
                but the terms are still very general!
            "),
            uiOutput("repoTab"),
            uiOutput("docTab")
           )
        )
      )
    ),
    tabPanel("Top 50 charts by Country", 
      fluidPage(
        fluidRow(
          column(10, offset = 1,
            titlePanel("Distributions of Track Tempo, Key and Length of Songs in Selected Playlist"),
            column(9, offset = 1,
               h4("\nThis tab shows the distibutions of track tempo, key, and length of songs in the
               selected playlist below. You may either choose one of the Top 50 Charts by country
               or find your with the search bar.")
            )
          )
        ),
        fluidRow(
          column(3,
            h2("\n\nInputs"),
            selectInput("Country",
              "Select a Country: (Choose Custom for Custom Playlist)",
              country_list),
            textInput("customPlaylist",
              "Enter ANY Playlist You Want (Paste Spotify URI Here)")
          ),
          column(9,
              tabsetPanel(
                tabPanel("Tempo",
                  column(9,
                    plotlyOutput("tempoChart")
                  ),
                  column(3,
                    h4("This visualization shows the frequency of different tempos(beats per min)
                        among the 50 songs within the playlist.\n"),
                    h3(textOutput("tempoText"))
                  )
                ),
                tabPanel("Key",
                  column(9,
                    plotOutput("keyPie")
                   ),
                  column(3,
                    h4("This pie chart displays the various keys and their frequency of being
                       used among the 50 songs in the playlist.")
                  )        
                ),
                tabPanel("Length",
                  column(9,
                    plotlyOutput("lengthChart")
                  ),
                  column(3,
                    h4("This bar chart shows the frequency of the different lengths of songs
                       from the chosen playlist."),
                    h3(textOutput("lengthText"))
                  )
                )
              )
          )
        ),
        fluidRow(
          column(12,
            DT::dataTableOutput("distTable1")
          )
        )
      )
    ),
    tabPanel("Danceability",
      fluidPage(
        fluidRow(
          column(8, offset = 3,
            titlePanel("Danceability and Various Factors of a Chosen Song")
          )
        ),
        fluidRow(
          column(4,
            uiOutput("dropdown"),
            p("This is an interactive plot that shows the danceability, energy, speechiness, 
              acousticness, instrumentalness, liveness, and valence of a chosen song.
              The songs are from the Top Global 2019 list."),
            tabsetPanel(
              tabPanel("Danceability",
                h4("How suitable a track is for dancing based on a combination of 
                   musical elements including tempo, rhythm stability, 
                   beat strength, and overall regularity. ")
              ),
              tabPanel("Energy",
                h4("Represents a perceptual measure of intensity and activity.")
              ),
              tabPanel("Speechiness",
                h4("Detects the presence of spoken words in a track.
                   The more exclusively speech-like the recording.")
              ),
              tabPanel("Acousticness",
                 h4("A confidence measure of whether a track is acoustic.")
              ),
              tabPanel("Instrumentalness",
                 h4("Represents a perceptual measure of intensity and activity.")
              ),
              tabPanel("Liveness",
                 h4("Detects the presence of an audience in the recording. Higher 
                    liveness values represent an increased probability that the 
                    track was performed live.")
              ),
              tabPanel("Valence",
                 h4("The musical positiveness conveyed by a track. Tracks with high
                    valence sound more positive (e.g. happy, cheerful, euphoric), 
                    while tracks with low valence sound more negative (e.g. sad, 
                    depressed, angry).")
              )
            )
          ),
          column(8,
            plotOutput("dance_plot")
          )
        )
      )
    ),
    tabPanel("Percentage of Album",
      fluidPage(
        fluidRow(
          column(6, offset = 2,
            titlePanel("Percentage of Album Time per Song"),
            h5("This data visualization shows the share of total time 
              for each song on the searched album.")
          ),
          column(4,
            h4("\n"),
            textInput("AlbumId",
              "Enter the ID of Album:")
          )
        ),
        #5gnWhEFNbtCn0RLG2cp90g <- test code
        fluidRow(
          column(9,
            plotOutput("bargraph")
          ),
          column(3,
            h3("Sample Album Codes"),
            h4("Abbey Road (The Beatles):"),
            p("0ETFjACtuP2ADo6LFhL6HN\n"),
            h4("Take Care (Drake):"),
            p("6X1x82kppWZmDzlXXK3y3q\n"),
            h4("thank u, next (Ariana Grande):"),
            p("2fYhqwDWXjbpjaIJPEfKFw\n")
          )
        )
      )
    ),
    tabPanel(
      "About Us",
      titlePanel(strong("ABOUT US")),
      mainPanel(
        h3("We are Team Dawgtify - Info 201 Section BC", align = "center"),
        br(),
        h4("Members: Shreya Balaji, Andy Cahill, Ryan Lee, Michael Yuan"),
        br(),
        tags$hr(),
        h4("Shreya Balaji"),
        p("Shreya is a freshman intending to major in Informatics and Design. In her spare time, she likes 
          to hang out with friends and is really into film."),
        h4("Andy Cahill"),
        p("Andy is a sophomore intending to major in Informatics."),
        h4("Ryan Lee"),
        p("Ryan is a sophomore intending to major in Informatics. He enjoys golfing and finger puppets."),
        h4("Michael Yuan"),
        p("Michael is a freshman intending to major in Informatics.")
        )
      )
  )
))