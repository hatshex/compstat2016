## app.R ##
library(shiny)
library(shinydashboard)
library(plotly)

## Only run this example in interactive R sessions
if (interactive()) {
  header <- dashboardHeader(
    #disable = TRUE
    title = "Estadística Computacional",
    titleWidth = "100%"
    )
  
  sidebar <- dashboardSidebar(
    sidebarUserPanel("hatshex",
                     subtitle = a(href = "http://github.com/hatshex", icon("circle", class = "text-success"), "Data Scientist"),                     
                     #subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
                     image = "gabs.jpg"
    ),
    sidebarMenu(
      id = "tabs",
            menuItem("Homeworks", icon = icon("table"), tabName = "homeworks",#badgeColor = "green",
                     menuSubItem("Inverse Function", tabName = "subitem1"),
                     menuSubItem("Integral", tabName = "subitem2"),
                     menuSubItem("MCMC Text", tabName = "subitem3")
            )
      
       )
  )
  
  body <- dashboardBody(
    tabItems(
      tabItem("homeworks",
              div(p("Dashboard tab content"))
              
      ),
      tabItem("subitem1"),
      tabItem("subitem2",
              # Boxes need to be put in a row (or column)
              fluidRow(
                box(
                  title = "Parámetros",                  
                  numericInput("lambda", "Lamda", value = 2, 
                               min = .0001, step = 1),
                  sliderInput("nsimulaciones", "Número de simulaciones:", 
                              min = 10, max = 5000, value = 500, 
                              step = 10)
                  

                  
                )
              )
              
                    )
              
      ),
      tabItem("subitem3")
      
    )
  
  
  
  shinyApp(
    ui = dashboardPage(skin="black", header, sidebar, body),
    server = function(input, output) { 
      output$plot1 <- renderPlot({
        data <- histdata[seq_len(input$slider)]
        hist(data)
      })
      
      }
  )
}
