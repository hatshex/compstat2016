##############################################################
### Estadística Computacional 
### Profesor: Mauricio García Tec
### Alumna: Gabriela Flores Bracamontes | 160124
### Fecha 17/08/2016
### MÉTODO DE SIMULACIÓN DE FUNCIÓN INVERSA
### Distribución exponencial
##############################################################
### Bibliografía:
### 
##############################################################
### SimFunInv.R
##############################################################


library(ggplot2)


library(plotly)

Finv<-function(u, lambda)
{
  return(-log(1-u)/lambda)
}

set.seed(110104)
nsim <- 1000
lamda <- .2

U <- runif(nsim)
X <- Finv(U, lamda)
table(X)

X2 <- rexp( nsim, rate = lamda)
plot_ly (x=X ,type = "histogram", opacity=.3) %>%
    add_trace (x=X2, type = "histogram", opacity=.3)

