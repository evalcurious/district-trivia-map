# install.packages("xml2")

require(xml2)

allLocationsURL <- "http://www.district-trivia.com/where/is-trivia"

doc <- read_html(allLocationsURL)

urls <- xml_find_all(doc,"//div[@class='carousel_item_description']//a[@href]")

locations <- data.frame(name = xml_text(urls), url=as.character(xml_attrs(urls)), stringsAsFactors = FALSE)

locations$url <- paste0("http://www.district-trivia.com",locations$url)

output <- data.frame(name=character()
                     ,day=character()
                     ,time=character()
                     ,address=character()
                     )

for (i in 1:nrow(locations)) {
  code <- read_html(locations$url[i])
  
  day.time <- xml_text(xml_find_all(code,'//div[@class="four columns"]//h5'))
  day <- gsub(" at.*$","", day.time)
  time <- gsub("^.* at ","", day.time)
  address.raw <- xml_find_all(code,'//div[@class="four columns"]//p')[2]
  address <- xml_text(read_html(gsub("<br>", ", ", address.raw)))
  
  site.data <- data.frame(name=locations$name[i]
                          ,day=day
                          ,time=time
                          ,address=address
                          ,stringsAsFactors = FALSE)
  
  output <- rbind(output,site.data)
  
}

# write.csv(output, "locations.csv")