
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Estadística Computacional"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("tarea", label="Escoge tarea",
        choices = c(
          "Aceptación Rechazo"="aceptacionRechazo",
          "Funcion Inversa"="funInv"
        ),
        selected="aceptacionRechazo"
      )
    ),
    # Show a plot of the generated distribution
    mainPanel(
      conditionalPanel(
        condition="input.tarea=='aceptacionRechazo'",
        h2("Aceptación-Rechazo"),
        textInput(
          inputId="expresion1", 
          label="Función f",
          value="function(x) 2*x"
        ),
        selectInput(
          inputId="expresion2", 
          label="Función g",
          choices=c("Uniforme(xmin, xmax)"="unif", "Exponencial(1) truncada a (xmin,xmax)"="exp", "Normal(0,1) truncada a (xmin,xmax)"="norm")
        ),
        sliderInput("xmin", "xmin", min=-30, max=30, value=0),
        sliderInput("xmax", "xmax", min=-30, max=20, value=1),
        sliderInput("M", "M", min=0.1, max=100, value=1),
        numericInput("nsim", "Número de simulaciones", value=100),
        actionButton("button1", "Correr"),
        plotOutput("Grafica"),
        h3("Resultados"),
        p("Tasa de éxito", textOutput("tasa_exito")),
        plotOutput("hist_sim"),
        sliderInput("nbins", "nbins", value=20, min=10, max=100)
      )
    )
  )
))
