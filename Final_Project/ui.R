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
source('access_token.R')

playlist_codes <- read.csv('country_playlist_codes.csv', stringsAsFactors = FALSE)
country_list <- unique(playlist_codes$Country)
playlistTest <- get_playlist('37i9dQZEVXbMDoHDwVN2tF')
playlistTest <- data.frame(playlistTest[['tracks']][['items']], stringsAsFactors = FALSE)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  theme = shinytheme('darkly'),
  
  titlePanel("Spotify"),
  # Sidebar with a slider input for number of bins 
  tabsetPanel(
    tabPanel("Top 50 charts by Country", 
      sidebarLayout(
        sidebarPanel(
          selectInput("Country",
                      "Select a Country:",
                      country_list),
          textInput("customPlaylist",
                    "Enter ANY Playlist You Want")
          ),
        mainPanel(
          textOutput("infoText1"),
          plotOutput("tempoChart"),
          textOutput("tempoText"),
          plotOutput("keyPie"),
          
          tableOutput("distTable1")
        )
      )
    ),
    tabPanel("Tempo", 
      sidebarLayout(
        sidebarPanel(),
        mainPanel()
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