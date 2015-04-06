library(shiny)

shinyUI(fluidPage(
  titlePanel("Forecast.io weather data for New York City"),

  sidebarLayout(
    sidebarPanel(
        dateRangeInput('dateRange', label='Date Range: ', start = Sys.Date()-1, end = Sys.Date()+1),
        textInput("apiKey", "Forecast.io API Key:", ""),
        submitButton("Get Data")
    ),
    mainPanel(
      plotOutput("temperaturePlot"),
      dataTableOutput('weatherData')
    )
  )
))
