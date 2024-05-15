library(shiny)
library(jsonlite)
library(data.table)
library(httr)
library(rtsdata)
library(DT)
library(TTR)
library(plotly)
library(dygraphs)
library(shinythemes)
library(shinydashboard)


library(shiny)
source('functions.R')

# ui <- fluidPage(
#   h1("Stock screener"),
#   uiOutput("my_ticker"),
#   dateRangeInput("my_date", "Select a date", start = Sys.Date()-1000, end = Sys.Date(), format = "yyyy-mm-dd"),
#   tableOutput("table_out"),
#   plotlyOutput("data_plot"),
#   plotOutput("simple_plot")
# )




# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       uiOutput("my_ticker"),
#       dateRangeInput("my_date", "Select a date", start = Sys.Date()-1000, end = Sys.Date(), format = "yyyy-mm-dd")
#     ),
#     mainPanel(
#       tabsetPanel(
#         tabPanel('plotly', plotlyOutput("data_plot")),
#         tabPanel('ggplot', plotOutput("simple_plot")),
#         tabPanel('data', tableOutput("table_out")),
#       )
#     )
#   )
# )




# ui <- fluidPage(
#   theme = shinytheme("superhero"),
#   tabsetPanel(
#     tabPanel('Control',
#              wellPanel(
#              uiOutput("my_ticker"),
#              dateRangeInput("my_date", "Select a date", start = Sys.Date()-1000, end = Sys.Date(), format = "yyyy-mm-dd")) 
#     ),
#     tabPanel('plot', plotlyOutput("data_plot"), plotOutput("simple_plot") ),
#     tabPanel('data', tableOutput("table_out"))
#   )
# )



# ui <- navbarPage(theme = shinytheme("superhero"),
#                  title = 'Stock browser',
#                  tabPanel('Control', uiOutput("my_ticker"), dateRangeInput("my_date", "Select a date", start = Sys.Date()-1000, end = Sys.Date(), format = "yyyy-mm-dd")),
#                  tabPanel('Plot', plotlyOutput("data_plot"), plotOutput("simple_plot")),
#                  tabPanel('Data', tableOutput("table_out")),
#                  )



# ui <- navbarPage(title = 'Stock browser', theme = shinytheme('superhero'),
#                  fluidRow(
#                    uiOutput("my_ticker"),
#                    dateRangeInput("my_date", "Select a date", start = Sys.Date()-1000, end = Sys.Date(), format = "yyyy-mm-dd")
#                  ),
#                  fluidRow(
#                    column(5,
#                           plotOutput("simple_plot")
#                           ),
#                    column(7,
#                           plotlyOutput("data_plot")
#                           )
#                  ),
#                  fluidRow(
#                    tableOutput("table_out")  
#                  )
#     )

# BASIC DASHBOARD PAGE

ui <-dashboardPage(
    dashboardHeader(title = 'Stock browser'),

    dashboardSidebar(
      sidebarMenu(
        h5('sidebar'),
        uiOutput("my_ticker"),
        dateRangeInput("my_date", "Select a date", start = Sys.Date()-1000, end = Sys.Date(), format = "yyyy-mm-dd")),
        menuItem("Plot", tabName = "plot", icon = icon("dashboard")),
        menuItem("GGplot", tabName = "ggplot", icon = icon("th")),
        menuItem("Data", tabName = 'data', icon = icon("th"))
      ),

    dashboardBody(
      tabItems(
        tabItem(tabName = "plot",
                plotOutput("simple_plot")
        ),
        tabItem(tabName = "data",
                tableOutput("table_out")
        ),
        tabItem(tabName = "ggplot",
                plotOutput("data_plot")
        )
      )
    )
  )
  
  
  
  
  
  
  
  
  
  
  
  
  
  













server <- function(input, output, session) {
  sp500 <- get_sp500()
  setorder(sp500, -market_cap_basic)
  
  # Reactive expression to fetch data based on selected ticker and date range
  data <- reactive({
    req(input$stock_id, input$date)
    get_data_by_ticker_and_date(input$stock_id, input$date[1], input$date[2])
  })
  
  # Render the data table
  output$data_table <- renderDataTable({
    data()
  })
  
  output$my_ticker <- renderUI({
    selectInput("stock_id", 'Select a stock', setNames(sp500$name, sp500$description), selected = 'TSLA', multiple = FALSE)
  })
 
  # observeEvent(input$stock_id, {
  #   print(input$my_date)
  #   print(input$stock_id)
  # })
  
  my_reactive_df <- reactive({
  get_data_by_ticker_and_date(input$stock_id, start_date = input$my_date[1], end_date = input$my_date[2])
  })

  output$table_out <- renderTable({
    my_reactive_df()
  })
  
  output$data_plot <- renderPlotly({
    get_plot_of_data(my_reactive_df())
  })
  
  # Render the ggplot plot
  output$simple_plot <- renderPlot({
    get_ggplot_plot(my_reactive_df())
  })
  
}

shinyApp(ui, server)