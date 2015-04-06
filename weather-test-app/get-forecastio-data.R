# libary(devtools)
# library(RCurl)
# install_github("hrbrmstr/Rforecastio")

library(Rforecastio)
library(ggplot2)
library(dplyr)

getForecastIoData <- function(apiKey, lat, long, qDate, timezone) {
    timestamp <- as.numeric(as.POSIXct(as.character(qDate), tz=timezone))                
    print(sprintf('Getting data for %s, timestamp: %d', qDate, timestamp))
    d <- fio.forecast(apiKey, lat, long, timestamp, sslverifypeer=FALSE)
}


plotDate <- function (d) {
    g <- ggplot(data=d$hourly.df, aes(x=time, y=temperature))
    g <- g + labs(y="", x="time", title="Hourly Weather Condition")
    #g <- g + geom_line(aes(y=humidity*100), color="green", size=0.25)
    g <- g + geom_line(aes(y=temperature), color="red", size=0.25)
    g <- g + geom_line(aes(y=precipProbability*100), color="blue", size=0.25)
    g <- g + theme_bw()
    print(g)
}

getDataForNYCDates <- function(startDate, endDate, destDir) {
    #New York: 40.7127° N, 74.0059° W
    getDataForDates(startDate, endDate, 40.7127, -74.0059, 'America/New_York', destDir)
}


getDataForDates <- function(startDate, endDate, lat, long, timezone, dataDir) {
    apiKey <- readLines('forecastio-api-key.txt')
    qDate <- as.Date(startDate)
    endDate <- as.Date(endDate)
    while (qDate < endDate) {
        d <- getForecastIoData(apiKey, lat, long, qDate, timezone)
        fileName <- sprintf('%s/%s.Rdata', dataDir, qDate)
        save(d, file=fileName)
        
        qDate <- qDate + 1
    }
}

consolidateDownloadedFiles <- function(dataDir) {
    files <- list.files(dataDir)
    result <- data.frame()
    for (fileName in files) {
        fileName <- paste(dataDir, fileName, sep='/')
        print(sprintf("Loading %s", fileName))
        load(file=fileName)
        z <- d$hourly.df %>% select(time, summary, temperature, humidity, 
                          precipIntensity, precipProbability, 
                          windSpeed, cloudCover, visibility)
        if (nrow(result) > 0) {
            result <- rbind(result, z)
        } else {
            result <- z
        }
    }
    result
}

weatherData <- consolidateDownloadedFiles('data2')
#write.csv(weatherData, file='weather.csv')
save(weatherData, file='weather.RData')
