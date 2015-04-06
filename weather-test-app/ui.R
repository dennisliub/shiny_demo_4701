library(shiny)

shinyUI(fluidPage(
  titlePanel("Forecast.io weather data"),

  sidebarLayout(
    sidebarPanel(
        dateInput('startDate', label = 'Start Date: yyyy-mm-dd', value = '2012-07-01'),
        dateInput('endDate', label = 'End Date: yyyy-mm-dd', value = '2012-08-01')
    ),
    mainPanel(
      plotOutput("temperaturePlot")
    )
  )
))
