  # Server - Back-end --> it's always called server.R
  library(shiny)
  library(lubridate)
  library(particles)
  
  
  # Implementing a function which will receive inputs from the UI, we can also create outputs which will be rendered later on
  server <- function(input, output) {
    
    # Now, these are not global variables but settings
    settings <- reactiveValues(
      title = 'Data Visualization 4',
      subtitle = 'Building Dashboards',
      schedule = as.POSIXct("2024-05-08 13:30:00")
    )
    
    output$title <- renderText(settings$title)
    output$subtitle <- renderText(settings$subtitle)
    
    # Render system time
    output$system_time <- renderText(as.character({
      invalidateLater(250)
      color <- ifelse(settings$schedule > Sys.time(), "black", "red")
      span(round(as.period(interval(settings$schedule, Sys.time()))),
          style = paste("color", color, sep = ':'))
    }))
    
    # Show modal for editing content
    observeEvent(input$setting_show, {
      showModal(modalDialog(
        # The first is the input data, the second is the label and the third is 'Data Visualization"
        textInput("title", "Title", value = settings$title),
        footer = tagList(actionButton("settings_update", "Update"))
      ))
    })
    
    
    observeEvent(input$settings_update, {
      settings$title <- input$title},
      removeModal())
  }
  