
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
      radioButtons("tarea", label = h3("Escoger tarea"),
                   choices = c("Aceptación - Rechazo" = "AceptacionRechazo", "Función Inversa" = "finInv"), 
                   selected = "AceptacionRechazo")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      conditionalPanel(
        condition="input.tarea=='AceptacionRechazo'",
        h2=("Aceptación - Rechazo"),
        textInput(
          inputId="expresion1", 
          label = "Escribe una funcion", 
          value = "function (x) 2*x"
        ),
        textInput(
          inputId="expresion2", 
          label = "Escribe una funcion", 
          value = "function (x) x^3"
        ),
        numericInput("testFun1", "Ingresa un valor", 3),
        numericInput("testFun2", "Ingresa un valor", 5),
        plotOutput("Grafica"),
        numericInput("minimoGraf","xmin",0),
        numericInput("maximoGraf","xmax",10),
        textOutput("text1")
      )
      
    )
  )
))
