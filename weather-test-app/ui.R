library(shiny)

shinyUI(fluidPage(
  titlePanel("Forecast.io weather data"),

  sidebarLayout(
    sidebarPanel(
        dateRangeInput('dateRange', label='Date Range: ', start = '2012-07-01', end = '2012-07-03'),
        textInput("apiKey", "Forecast.io API Key:", ""),
        submitButton("Get Data")
    ),
    mainPanel(
      plotOutput("temperaturePlot")
    )
  )
))
