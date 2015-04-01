fluidPage(
  # Application title
  titlePanel("Word Cloud"),

  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      h4("These inputs control the other inputs on the page"),
      textInput("hashtag",
                "Type the hashtag without #:",
                "4701"),
      actionButton("update", "Change"),
          ),

    # Show Word Cloud
    mainPanel(
      plotOutput("plot")
    )
  )
)r