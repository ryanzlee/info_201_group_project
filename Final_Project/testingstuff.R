playlist <- get_playlist("37i9dQZEVXbMDoHDwVN2tF")
playlist <- data.frame(playlist[['tracks']][['items']], stringsAsFactors = FALSE)
playlist <- select(playlist, track.name, track.id)
track_features <- get_track_audio_features(playlist$track.id)
colnames(track_features)[colnames(track_features)== "id"] <- "track.id"
testData <- right_join(playlist, track_features, by = "track.id")
#testData <- select(testData, track.name, tempo)
plot <- ggplot(data = testData) +
  stat_bin(aes(x = tempo), binwidth = 5)
print(plot)

ee <- c(0:12)
keys <- as.data.frame(table(testData$key))
letterValues <- c("C","C#/Db","D","D#/Eb","E","E#/Fb","F","F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B")
keys <- mutate(keys, letter = letterValues)

bp <- ggplot(keys, aes(x = "", y = Freq, fill = Var1)) +
        geom_bar(width = 1, stat = "identity")
pie <- bp + coord_polar("y", start = 0)
print(pie)