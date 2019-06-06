# Statify: The Application for Stat-loving Audiophiles
## Group Dawgs: Ryan Lee, Andy Cahill, Shreya Balaji, Michael Yuan

### About our app
Our application ultilizes the Spotify Web API in addition to the spotifyr package within
r to create interactive visualizations towards different audio features of a chosen song, album,
or playlist. Utlizing the spotifyr package, we are able to provide users the ability
to look at hidden audio feature values within spotify and learn about what dynamics make up
a given song. Our application is split into multiple tabs each with different information
and/or visualizations on them. The tabs are as follows:

1. **Our Mission** - shows information about app and its functionality
2. **Playlist Stats** - shows visualizations of the tempo, key, and length of songs within a given playlist. Users input a playlist(top 50 by country or custom with playlist api code) and app will display table of songs within playlist and the frequency of different tempos, keys, and lengths within that playlist. Also reports the average tempo and length of songs within the playlist.
3. **Danceability Features** - shows visualization of the danceability features of a chosen song. Users chose a song from the chosen playlist(On Tab #2) and creates bar chart of audio features which include danceability, energy, speechiness, acousticness, instrumentalness, liveness, and valence of the chosen song.
4. **Percent of Album** - shows visualization of the percent share of total time each song of a particular album has. Users input an album's API code and generates pie chart of all the songs and the portion of total time each one contributes to the album.
5. **About Us** - displays information about our group and the members involved.

Below are links to our application of shinyapps, the spotifyr documentation, and the spotify web API

* [Statify powered by Shiny](https://cahillaw.shinyapps.io/Statify/)
* [Spotifyr documentation](https://www.rdocumentation.org/packages/spotifyr/versions/1.0.0)
* [Spotify web API](https://developer.spotify.com/documentation/web-api/)