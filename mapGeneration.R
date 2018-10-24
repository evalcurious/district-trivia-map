# install.packages("leaflet")

require(leaflet)

trivia <- read.csv(paste0(getwd(),"/locationsGeocoded.csv"))

# Tested at https://regexr.com/
trivia$address <- gsub(" ?,(?=( +[A-z]+)+ ?,(.+))","<br>",trivia$address,perl=TRUE)

map <- leaflet(trivia) %>%
  addProviderTiles(provider="Stamen.Watercolor") %>%
  addProviderTiles(provider="CartoDB.PositronOnlyLabels") %>%
  addMarkers(lat=~lat,lng=~lng
                   ,group=~day
                   ,popup=~paste0("<h4>",name,"</h4>",
                                  "<p><em>",time,"</em></p>",
                                  address
                                  )) %>%
  addLayersControl(overlayGroups = c("Monday","Tuesday","Wednesday","Thursday","Sunday")
                   ,options=layersControlOptions(collapsed=FALSE)) %>%
  setView(lng=-77.0369,lat=38.9072,zoom=9)
  
map