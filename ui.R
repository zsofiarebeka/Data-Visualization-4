# UI - Front-end --> it's always called ui.R
library(shiny)
library(particlesjs)

# Creating a Bootstrap page, a Shiny UI Page
ui <- basicPage(
  tags$head(tags$link(rel = "stylesheet", 
                      type = "text/css", 
                      href = "app.css")),
  particles(),
  actionButton("setting_show", "Settings"),
  div(
    h1(uiOutput('title')),
    h2(uiOutput('subtitle')),
    uiOutput('system_time'),
    class = "center")
)
