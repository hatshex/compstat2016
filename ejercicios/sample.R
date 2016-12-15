##############################################################
### Estadística Computacional 
### Profesor: Mauricio García Tec
### Alumna: Gabriela Flores Bracamontes | 160124
### Fecha 17/08/2016
##############################################################
### Bibliografía:
### 
##############################################################
### sample.R
##############################################################

library(dplyr)

#x<-sample(
#          c("A", "B", "C"),
#          1000, 
#          replace = TRUE, 
#          prob = c(.25, .25 ,.5)
#          )
#table(x)

set.seed(101010)
n <-100
categorias <- c("A", "B", "C")
prob <- c(.25, .25 ,.5)
U <-runif(n)
vecF_i <- cumsum(prob)
x <- c()
for (i in 1:n) 
  {
  j<-1
  while(U[i] > vecF_i[j])
  {
    j<- j +1
    
  }
  x <-c(x,categorias[j])
  
}

table(x)
