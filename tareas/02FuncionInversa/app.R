##############################################################
### Estadística Computacional 
### Profesor: Mauricio García Tec
### Alumna: Gabriela Flores Bracamontes | 160124
### Tarea 02 | Función Inversa
### Fecha 24/08/2016
##############################################################
### Bibliografía:
### https://rstudio.github.io/shinydashboard/
##############################################################
### app.R
##############################################################

library(dplyr)
library(shinydashboard)
library(ggplot2)
library(plotly)

ui <- dashboardPage(
  dashboardHeader(title = "GCL - GFB" ),
  dashboardSidebar(
    title="PARÁMETROS",
    sliderInput("nsim", "Número de simulaciones:", 10,10000, 1500),
    sliderInput("lambda",
                "Asigne un número para lambda:",
                min = 0.00000000000001,
                max = 10,
                value = 0.00000005
    )
  ),
  dashboardBody(
    fluidRow(
      box(title="Generación de  números uniformes",width = 5, solidHeader = TRUE, status = "danger", plotOutput("fi_hist2", height = 300)),
      box(title="Distribución Exponencial", width = 5, solidHeader = TRUE, status = "success", plotlyOutput("fi_hist", height = 300))
      
    )
    ,
    fluidRow(
      box(title="Acumulada", width = 5, solidHeader = TRUE, status = "success", plotlyOutput("fi_acumulada", height = 300)),
            box(title="Datos", width       = 5, solidHeader = TRUE, status = "warning", dataTableOutput('fi_table'))

    )
  )
)

server <- function(input, output) {
  ########################################################################
  set.seed(160124)
  
  #Finv<-function(nsim, lambda=.2, seed=160124)
  #{
  #  u <- runif(nsim)
  #  return(-log(1-u)/lambda)
  #}
  u <- reactive({ runif(input$nsim)  })
  X <- reactive({ -log(1-u())/input$lambda})
  X2 <- reactive({rexp(input$nsim, rate = input$lambda)})
    
   ########################################################################

      output$fi_hist2 <- renderPlot({
    qplot(u(),   geom="histogram",
          fill=I("black"), 
          col=I("white"), 
          alpha=I(.4) )
  })  
  
      output$fi_acumulada <- renderPlotly({
        plot_ly (x=sort(X()),y=sort(u()),type = "scatter", mode="lines", name = "Función de distribución acumulada de X",
                 marker = list(          
                   color="rgb(0,102, 51)," 
                 ),opacity=.5
                 
        )%>%
          layout(
            title="U(X)= F(X) Función de distribución de X", 
            xaxis = list(
              title = "X", 
              showgrid = T 
            ),
            yaxis = list(
              title = "Frecuencia acumulada de X", 
              showgrid = T 
            )
            
          )
        
      })   
    
      
  output$fi_hist <- renderPlotly({
    plot_ly (x=X(),type = "histogram", name = "X= Función Inversa",
             marker = list(          
               color="rgb(0,102, 51)," 
             ),opacity=.5
             
             )%>%
      add_trace (
        x=X2(), 
        name = "X2= Función Exponencial ",type = "histogram", 
        marker = list(
          color="rgb(160, 160, 160)"
        ),
        opacity=.5
        
      )%>%
      layout(title = "Frecuencias de X y X2",
             xaxis = list(
               title = "X", 
               showgrid = F 
             ),
             showlegend = TRUE)
        
  })
  
  
  output$fi_table <- renderDataTable({
    datos <- as.data.frame(cbind(sort(u()), sort(X()),sort(X2())))
    names(datos) <- c("Uniforme","X","X2")
    datos  
  })

}

shinyApp(ui, server)