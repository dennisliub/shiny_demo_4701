library(shiny)
library(dplyr)
library(ggplot2)
library(scales)

getWeatherPlotData <- function(weatherData, startDate, endDate, timezone) {
    startTime <- as.POSIXlt(as.Date(startDate), tz=timezone)
    endTime <- as.POSIXlt(as.Date(endDate), tz=timezone)
    flags <- weatherData$time >= startTime & weatherData$time < endTime
    weatherData[flags,]
}

loadWeatherData <- function() {
    load('weather.RData')
    weatherData
}

shinyServer(function(input, output) {
    
    weatherData <- loadWeatherData()

    output$temperaturePlot <- renderPlot({
        df <- getWeatherPlotData(weatherData, input$startDate, input$endDate, 'America/New_York')
        g <- ggplot(df, aes(x=time, y=temperature)) + 
            geom_line(aes(alpha=0.02)) +
            #geom_point(aes(alpha=0.02)) +
            theme_bw() + 
            ggtitle(sprintf("Hourly Temperature between %s and %s", input$startDate, input$endDate)) + 
            xlab('Date') + 
            ylab('Temperature in F') +
            theme(legend.position="none")

        print(g)
      })
})
