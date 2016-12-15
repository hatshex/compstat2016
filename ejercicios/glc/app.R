##############################################################
### Estadística Computacional 
### Profesor: Mauricio García Tec
### Alumna: Gabriela Flores Bracamontes | 160124
### Tarea 01 | Generador Congruencial Lineal
### Fecha 17/08/2016
##############################################################
### Bibliografía:
### https://rstudio.github.io/shinydashboard/
##############################################################
### app.R
##############################################################

library(dplyr)
library(shinydashboard)
library(ggplot2)

ui <- dashboardPage(
  dashboardHeader(title = "GCL - GFB" ),
  dashboardSidebar(
    title="PARÁMETROS",
    sliderInput("nsim", "Número de simulaciones:", 1000,10000, 5550),
    sliderInput("incremento", "Incremento:", 1,10, 1),
    numericInput("multiplicador", "Multiplicador:", 2456651, 1),
    numericInput("semilla", "Semilla:", 160124, 1),
    numericInput("M", "M:", 2^32, 1)
  ),
  dashboardBody(
    fluidRow(
      box(title="Histograma", width = 5, solidHeader = TRUE, status = "success", plotOutput("gcl_hist", height = 300)),
      box(title="Plot",width = 5, solidHeader = TRUE, status = "danger", plotOutput("gcl_plot", height = 300))
    ),
    fluidRow(
      box(title="Datos", width       = 10, solidHeader = TRUE, status = "warning", dataTableOutput('gcl_table'))
      

    )
  )
)

server <- function(input, output) {
  GCL <- function (nsim, M = 2^32, multiplicador = 2456651, incremento = 1, semilla = 1 ){
    seq <- c(semilla,nsim-1) 
    for(i in 1:(nsim - 1)) seq[i+1] <- (seq[i]*multiplicador + incremento) %% M
    seq/M
  }
  
  datos <- reactive({
    GCL(input$nsim, input$M, input$multiplicador, input$incremento, input$semilla)
  })
  
  
    output$gcl_hist <- renderPlot({
    qplot(datos(),   geom="histogram",
          fill=I("black"), 
          col=I("white"), 
          alpha=I(.4) )
  })
  
  output$gcl_plot <- renderPlot({
    qplot(datos()[-input$nsim], datos()[-1], alpha=I(.3))
  })
  
  output$gcl_table <- renderDataTable({
    data.frame(datos())
  })
  
}

shinyApp(ui, server)