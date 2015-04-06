library(shiny)
library(Rforecastio)
library(dplyr)
library(ggplot2)
library(scales)

getStoredWeatherPlotData <- function(weatherData, startDate, endDate, timezone) {
    startTime <- as.POSIXlt(as.Date(startDate), tz=timezone)
    endTime <- as.POSIXlt(as.Date(endDate), tz=timezone)
    flags <- weatherData$time >= startTime & weatherData$time < endTime
    weatherData[flags,]
}

loadWeatherData <- function() {
    load('weather.RData')
    weatherData
}

getForecastIoData <- function(apiKey, lat, long, qDate, timezone) {
    timestamp <- as.numeric(as.POSIXct(as.character(qDate), tz=timezone))                
    print(sprintf('Getting data for %s, timestamp: %d', qDate, timestamp))
    d <- fio.forecast(apiKey, lat, long, timestamp, sslverifypeer=FALSE)
}

getForecastIoWeatherPlotData <- function(apiKey, startDate, endDate, lat, long, timezone) {
    qDate <- as.Date(startDate)
    endDate <- as.Date(endDate)
    n <- as.numeric(endDate - qDate)
    result <- data.frame()
    withProgress(message = 'Getting data', value = 0, {
        while (qDate < endDate) {
            incProgress(1/n, detail = paste("Getting data for ", qDate))
            d <- getForecastIoData(apiKey, lat, long, qDate, timezone)
            z <- d$hourly.df %>% select(time, summary, temperature, humidity, 
                                        precipIntensity, precipProbability, 
                                        windSpeed, cloudCover)
            if (nrow(result) > 0) {
                result <- rbind(result, z)
            } else {
                result <- z
            }
            qDate <- qDate + 1
        }
    })    
    result
}

shinyServer(function(input, output) {
    output$temperaturePlot <- renderPlot({
        startDate <- input$dateRange[1]
        endDate <- input$dateRange[2]
        if (input$apiKey != '') {
            latitude <- 40.7127
            longitude <- -74.0059
            df <- getForecastIoWeatherPlotData(input$apiKey, startDate, endDate, latitude, longitude, 'America/New_York')
            g <- ggplot(df, aes(x=time, y=temperature)) + 
                geom_line(aes(alpha=0.02)) +
                #geom_point(aes(alpha=0.02)) +
                theme_bw() + 
                ggtitle(sprintf("Hourly Temperature between %s and %s", startDate, endDate)) + 
                xlab('Date') + 
                ylab('Temperature in F') +
                theme(legend.position="none")
            
            print(g)
        }
    })
})
      