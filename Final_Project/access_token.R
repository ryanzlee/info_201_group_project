library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '4242ef4736e84ce9be0a4fbd63629905')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '7224c18cb4064ad8a6a0916b31939f59')

access_token <- get_spotify_access_token()

