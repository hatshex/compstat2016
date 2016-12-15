
##############################################################
### Estadística Computacional
### Profesor: Mauricio García Tec
### Alumna: Gabriela Flores Bracamontes | 160124
### Tareas
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
require(vcd)
require(MASS)
library(shiny)
library(shinythemes)

setwd("E:/itam/2016 Verano/compstat2016/")
white.url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"
white.raw <- read.csv(white.url, header = TRUE, sep = ";")
white <- white.raw

# Define UI for application that draws a histogram
shinyUI(
  fluidPage
  (
    title="Estadística Computacional",
    theme = shinytheme("flatly"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/gabs.css"),
    navbarPage(
      #img(class="img-circle", src="images/gabs.jpg"),
      navbarMenu(
        "Homeworks",
        ####################################################################################################################
        #################### Homework 1
        ####################################################################################################################
        
               tabPanel("Inverse Function", # tabPanel-Inverse Function
                        sidebarPanel(
                          div(class="panel-body",
                              sliderInput("nsim", "Número de simulaciones:", 10,10000, 1500),
                              sliderInput("lambda",
                                          "Asigne un número para λ:",
                                          min = 0.00000000000001,
                                          max = 10,
                                          value = 0.05),
                              downloadButton(class="btn btn-primary" ,'downloadData', 'Datos')
                          )#div(class="panel-body",
                        ),#sidebarPanel
                        mainPanel(
                          tabsetPanel( ## mainPanel/tabsetPanel
                            tabPanel("Intro",br(),br(),
                                     includeMarkdown("md/01InverseFunction.md")
                            ), #tabPanel Intro
                tabPanel("Gráficos",plotlyOutput("fi_hist")),
                tabPanel("Pruebas",
                         br(),
                         br(),
                         h4("Kolmogórov-Smirnov:"),
                         div(class="panel panel-default",
                             div(class="panel-body",
                                 p("H0: Los datos analizados siguen una distribución exponencial"),
                                 p("H1: Los datos analizados NO siguen una distribución exponencial"),
                                 textOutput("testKS")
                             )
                         )
                         ,
                         br(),
                         br(),
                         h4("Chi Cuadrada"),
                         div(class="panel panel-default",
                             div(class="panel-body",
                                 textOutput("testChi")
                             )
                         )
                         ,
                         br(),
                         br(),
                         h4("Basadas en Gráficos"),
                         br(),
                         div(class="panel panel-default",
                             plotlyOutput("fi_acumulada")),
                         div(class="panel panel-default",
                             plotlyOutput("QQplot"))
                         
                ),
                tabPanel("Data", dataTableOutput('fi_table'))
                          )## mainPanel/tabsetPanel
                        )#mainPanel
               ),#tabPanel("Inverse Function",

####################################################################################################################
#################### Homework 2
####################################################################################################################
tabPanel("Integral",
         sidebarPanel
         (
           title="Parámetros",
           textInput(inputId = "h2fun",
                     label = 'Escribe g(x)',
                     value = "(cos(50*x) + sin(20*x))^2"),
           br(),
           sliderInput("h2alpha", "Significancia del intervalo (α):", value = 0.05,
                       min = 0.001, max = 0.1,step = 0.001),
           br(),
           #sliderInput('h2intab', label = 'Limites de integracion (a,b)', min = -6, max = 6, value = c(0,2), step = 0.01),
           numericInput("h2a", "Límite inferior:", min = -6, max = 6, value = -2),
           numericInput("h2b", "Límite superior:", min = -6, max = 6, value = 2),           
           br(),
           selectInput("h2nsim", "No. de Simulaciones:", choices = c(10,100,1000,10000,100000), selected = 1000),
           downloadButton(class="btn btn-primary" ,'downloadSimulacion', 'Datos')

         ),
         mainPanel(
           tabsetPanel(
             tabPanel("Intro", includeMarkdown("md/02MonteCarloIntegral.md")),
             tabPanel("Gráficas", 
                      br(),
                      h4("Función a integrar"),
                      br(),
                      div(class="panel panel-default", plotOutput("g_fun"), plotOutput("g_IntegralMC"))
                      ),
             tabPanel("Data", dataTableOutput('table_IntegralMC'))
           ))
),
################################################################
################################################################
tabPanel("MCMC",
         sidebarPanel
         (
           title="Parámetros"
         ),
         mainPanel(
           tabsetPanel(
             tabPanel("Intro", includeMarkdown("md/03MCMC.md"))
           ))
),

################################################################
################################################################
tabPanel("Metropolis-Hastings",
         sidebarPanel
         (
           title="Parámetros", 
           h4("Los datos a utilizar son Calidad de vino"),
           div("Se descargaron del repositorio https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"),
           br(),
           br(),
           div("Los datos se visualizaran en la pestaña Datos"),
           # checkboxGroupInput("cVariables", h3("Variables"),
           #                    choices = names(white)),
           fluidRow(
             column(5, selectInput("Y",
                                   "Y:",
                                   c(rev(unique(as.character(names(white))))))),
             
             column(5, selectInput("X",
                                   "X:",
                                   c(unique(as.character(names(white))))))
           ),
           br()
      
           
         ),
         mainPanel(
           tabsetPanel(
             tabPanel("Intro", includeMarkdown("md/04-06Metropolis-Hastings.Rmd")),
             tabPanel("Gráficas",
                      br(),
                      h4("Gráfica de dispersión"),
                      br(),
                      div(class="panel panel-default", plotOutput("g_dispersion"), 
                          h4("Definición de iniciales vagas o no informativas"),
                          plotOutput("g_prior.alpha"),
                          plotOutput("g_prior.beta"),
                          plotOutput("g_prior.sigma")
                          )
                      ),
             tabPanel("Datos",
                      fluidRow(
                        DT::dataTableOutput("table")
                      )
                      )
           ))
)

################################################################
      )#NavMenu("Homeworks"
,title=div("Estadística Computacional", tags$img(src="imgs/gabs.png", class="img-circle"))    
)#navbarPage
  )#fluidPage
) ##shinyUI
