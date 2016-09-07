
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


shinyServer(function(input, output) {
  
  fun1<- reactive ({
    texto <- paste("aux <- ", input$expresion1)
    print(texto)
    eval(parse(text=texto))
    aux
  })
  
  fun2<- reactive ({
    texto <- paste("aux <- ", input$expresion2)
    print(texto)
    eval(parse(text=texto))
    aux
  }) 
  
  
  
  output$text1 <- renderText({     (fun1())(input$testFun1)  })  
  
  output$Grafica <- renderPlot({
    x <- seq(input$minimoGraf, input$maximoGraf, length.out = 100)
    y1 <- sapply(x, fun1())
    y2 <- sapply(x, fun2())
    plot(x, y1, type = "l", col="blue", main = "Grafica")
    lines(x, y2, col="red")
    
  })
  
  
  
}
)