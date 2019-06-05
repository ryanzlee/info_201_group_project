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

playlist_codes <- read.csv('country_playlist_codes.csv', stringsAsFactors = FALSE)
country_list <- unique(playlist_codes$Country)
playlistTest <- get_playlist('37i9dQZEVXbMDoHDwVN2tF')
playlistTest <- data.frame(playlistTest[['tracks']][['items']], stringsAsFactors = FALSE)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  #theme = shinytheme('darkly'),
  
  titlePanel("Spotify"),
  # Sidebar with a slider input for number of bins 
  tabsetPanel(
    tabPanel("Top 50 charts by Country", 
      sidebarLayout(
        sidebarPanel(
          selectInput("Country",
                      "Select a Country: (Choose Custom for Custom Playlist)",
                      country_list),
          textInput("customPlaylist",
                    "Enter ANY Playlist You Want (Paste Spotify URI Here)")
          ),
        mainPanel(
          titlePanel("Distributions of Track Tempo, Key and Length of Songs in Selected Playlist"),
          textOutput("infoText1"),
          DT::dataTableOutput("distTable1"),
          plotlyOutput("tempoChart"),
          textOutput("tempoText"),
          plotOutput("keyPie"),
          plotlyOutput("lengthChart"),
          textOutput("lengthText")
        )
      )
    ),
    tabPanel(
      "Danceability",
      titlePanel("Factors of Danceability"),
      sidebarLayout(
        sidebarPanel(
          uiOutput("dropdown")
        ),
        mainPanel(
          plotOutput("dance_plot"),
          p("This is an interactive plot that shows the danceability, energy, speechiness, acousticness,
            instrumentalness, liveness, and valence of a chosen song. The songs are from the Top Global 2019 list.")
          )
        )
      ),
    tabPanel("Tab 3", 
             sidebarLayout(
               sidebarPanel(),
               mainPanel()
             )
    )
  )
))