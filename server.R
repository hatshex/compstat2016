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
require(plyr)
library(shinydashboard)
library(ggplot2)
library(plotly)
require(vcd)
require(MASS)
library(shiny)
library(shinythemes)
require(MASS)
library(Rcpp)
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  ####################################################################################################################
  #################### Homework 1 Server
  ####################################################################################################################
  
  set.seed(160124)
  
  white.url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"
  white <- read.csv(white.url, header = TRUE, sep = ";")
  
## Defino las iniciales no informativas
  prior.alpha <- function(x) dnorm(x, 0, 0.1)
  prior.beta <- function(x) dnorm(x, 0, 0.1)
  prior.sigma <- function(x) dgamma(x, 0.01, 0.01)
  

  u <- reactive({ runif(input$nsim)  })
  X <- reactive({ -log(1-u())/input$lambda})
  X2 <- reactive({rexp(input$nsim, rate = input$lambda)})
  datos <- reactive({
    data <- as.data.frame(cbind(sort(u()), sort(X()),sort(X2())))
    names(data)<-(c("Uniforme","X","X2"))
    data
    
  })
  
  
  output$fi_acumulada <- renderPlotly({
    plot_ly (x=sort(X()),y=sort(u()),type = "scatter", mode="lines", name = "Función de distribución acumulada de X",
             marker = list(color="rgb(0,102, 51)," ),opacity=.5
    )%>%
      layout(
        title="U(X)= F(X) Función de distribución de X", 
        xaxis = list(title = "X", showgrid = T),
        yaxis = list(title = "Frecuencia acumulada de X",showgrid = T)
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
      layout( title="Histogramas X y X2",
              xaxis = list(title = "Observaciones simuladas", showgrid =TRUE),
              yaxis = list(title = "Frecuencias", showgrid = F),
              showlegend = TRUE)
    
  })
  
  
  output$fi_table <- renderDataTable({
    # datos <- as.data.frame(cbind(sort(u()), sort(X()),sort(X2())))
    # names(datos) <- c("Uniforme","X","X2")
    datos()  
  })
  
  output$testKS <- renderText({
    test <- ks.test(x = X(), 
                    y = "pexp", 
                    rate = input$lambda)
    pvalue <- round(as.numeric(test$p.value),2)
    # Si p-valor ≥ α ⇒ Aceptar H0
    # Si p-valor < α ⇒ Rechazar H0
    
    ifelse( pvalue < .05, 
            paste("Para un nivel de significancia α=.05, con p-value ", pvalue,
                  " se rechaza H1, los datos NO se distribuyen exponencialmente"), 
            paste("Para un nivel de significancia α=.05, con p-value ", pvalue, 
                  " no se rechaza H0, los datos se distribuyen exponencialmente")
    )
  })    
  
  
  output$QQplot <- renderPlotly({
    datos<- data.frame(X())
    t <- ggplot(datos, aes(sample = X())) + 
      geom_abline(slope = 1, color = '#006633') + 
      stat_qq(distribution = qexp, dparams = input$lambda, 
              size = .5, color = '#496067') 
    t<- t + labs( title="Q-Q Plot",x="Q Theorical", y="Q Distribution")
    
  }) 
  output$testChi <- renderPrint({
    breaks <- c(seq(0,10,by=1))
    O <- table(cut(X(),breaks=breaks))
    p <- diff(pexp(breaks))
    chisq.test(O,p=p, rescale.p=T)
    
  })
  
  output$downloadData <- downloadHandler(
    filename <- function() { paste('datos','.csv', sep='|') },
    content <- function(file) {
      write.csv(datos(), file, row.names = FALSE)
      
    })
  ###############################################################################################
  ###############################################################################################
  
  a <- reactive({ input$h2a })
  b <- reactive({ input$h2b })
  nsim <- reactive({ as.numeric(input$h2nsim) })
  f <- reactive({input$h2fun })
  alpha <- reactive({ input$h2alpha })
  
  Phi <- reactive({
    texto <- paste("aux <- function(x) ",f())
    eval(parse(text = texto))
    aux
  })
  
  mc.intervals <- function(Phi, N, X.dens, alpha){
    N<- seq(10,N,10)
    results.list <- lapply(N, function(nsim){
      # MonteCarlo step
      X <- sapply(FUN=X.dens, nsim) # N samples of the density of X
      PhiX <- sapply(X, Phi) # Evaluate phi at each X_i
      estim <- (b()-a())*mean(PhiX) # Estimate of int_a^b \phi(x)f(x)df=E[phi(X_i)]
      trapezoid <- (b() - a())/2*mean(PhiX[-N] + PhiX[-1]) ## Estimate trapezoid
      S2 <- var(PhiX) # Estimate of the variance of phi(X_i)
      quant <- qnorm(alpha/2, lower.tail=FALSE) # Right quantile for alpha/2
      int.upper <- estim + sqrt(S2/nsim)*quant # Upper confidence interval
      int.lower <- estim - sqrt(S2/nsim)*quant # Lower confidence interval
      tra.upper <- trapezoid + sqrt(S2/nsim)*quant # Upper confidence interval
      tra.lower <- trapezoid - sqrt(S2/nsim)*quant # Lower confidence interval
      return(data.frame(N=nsim, Estimate_Integral=estim, Estimade_Trapezoid=trapezoid, LI=int.lower, UI=int.upper, LT=tra.lower, UT=tra.upper))
      # -------
    })
    #
    results.table <- ldply(results.list) # Assembles list in data.frame
    return(results.table)
  }
  
  X.dens <- function(nsim) runif(nsim, a(), b())
  datos <- reactive({ mc.intervals(Phi=Phi(), N=nsim(), X.dens=X.dens, alpha=alpha())})
  
  output$g_fun <- renderPlot({
    x <- seq(a(), b(), (b()-a())/nsim())
    y <- sapply(x, Phi())
    datos <- data.frame(x,y)
    ggplot(datos,aes(x,y))+
      geom_line(colour="#006633",size=1)+
      geom_area(fill="#496067",alpha=0.2)+
      labs(x="x", y="y")
  })



  output$g_IntegralMC <- renderPlot({
    
    pi <- integrate(Phi(), a(), b())
    ggplot(datos(), aes(x=log10(seq(10,nsim(),10)))) +
    geom_ribbon(aes(ymin=LI, ymax=UI), fill="grey", alpha=.4) +
    geom_ribbon(aes(ymin=LT, ymax=UT), fill="#006633", alpha=.2) +      
    geom_line(aes(y=Estimate_Integral), colour="blue") +
    geom_line(aes(y=Estimade_Trapezoid), colour="#006633") +
    geom_hline(aes(yintercept=pi$value) , colour="red", linetype="dotted", size=1)+
    labs(x='# simulaciones en logaritmo base 10', y='Estimación de la integral')
  })
  
  output$table_IntegralMC <- renderDataTable({
    datos()  
  })
   
  output$downloadSimulacion <- downloadHandler(
    filename <- function() { paste('datos','.csv', sep='|') },
    content <- function(file) {
      write.csv(datos(), file, row.names = FALSE)
      
    })
  
  ############################################
  ############################################

  
    datosMH <- reactive({  
      subset(white, select = c(input$Y, input$X)) 
      # if(is.null(input$cVariables))
      #   return()
      # white[, input$cVariables]
      

    })
  output$table <- DT::renderDataTable(DT::datatable({
    datosMH()
  }))
  
  output$g_dispersion<- renderPlot({
    plot(
      datosMH()[,2], 
      jitter(datosMH()[,1]), 
      xlab = names(datosMH()[input$X]),
      ylab = names(datosMH()[input$Y]),
      col = "firebrick"
      )
    # par(mfrow = c(4,3))
    # for (i in c(1:11)) {
    #   plot(white[, i], jitter(white[, "quality"]), xlab = names(white)[i],
    #        ylab = "quality", col = "firebrick", cex = 0.8, cex.lab = 1.3)
    #   abline(lm(white[, "quality"] ~ white[ ,i]), lty = 2, lwd = 2)
    # }
    # par(mfrow = c(1, 1))
    
  })
  
  output$g_prior.alpha<- renderPlot({
    plot(prior.alpha,  col="darkred", lwd="2")
  })
  output$g_prior.beta<- renderPlot({
    plot(prior.beta,  col="darkred", lwd="2")
  })
  output$g_prior.sigma<- renderPlot({
    plot(prior.sigma,  col="darkred", lwd="2")
  })
})
