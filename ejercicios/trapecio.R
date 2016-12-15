# Regla del trapecio
# Trabajamos con un vector para una dimensión
limits <- c(0,1)
eps <- .01
fun <- function(x){
  x^2
  
}
trapecio <- function(limits, fun, eps=1e-6)
{
  #limits es un vector de tamaño 2
  #eps es el tamaño de cada subintervalo
  x_i <- seq(
    from=limits[1],
    to=limits[2],
    by = eps
  )
  f_i<- sapply(x_i, fun) # Evaluar cada xi en mi función
  eps/2*sum(f_i[-length(x_i)] + f_i[-1])
}

# Para probar utilizar
# trapecio( c(0,1), function(x) x*x, eps=.1)
# integrate (function(x) x*x, 0,1)  

#####################################################
# Ahora vamos a trabajar con una lista

# Regla del trapecio
limits <- c(0,1)
eps <- .01
fun <- function(x){
  x^2
  
}

limits_list <- list(c(0,1),c(-1,0))
trapecio <- function(limits_list, fun, eps=1e-6)
{
  #El prerequisito es que fun sea una función R^d ->R
  # donde d es el tamaño de la lista, y la lista
  # tiene los límites de integración en cada dimensión
  if()
  {
    x_i <- seq(
      from=limits[1],
      to=limits[2],
      by = eps
    )
    f_i<- sapply(x_i, fun) # Evaluar cada xi en mi función
    eps/2*sum(f_i[-length(x_i)] + f_i[-1])
    
  }
  else
  {
    ndim <- length(limits_list)
    limits <- limits_list[[1]]
    x_i <- seq(
      from=limits[1],
      to=limits[2],
      by = eps
    )
    f_i <- sapply(x_i, function(x){
      trapecio (limits_list[-1]), function(y) fun(c(x,y), eps =)
    }
      )
  }
}





trapezoid <- function(N, a, b, FUN){
  # FUN is the function we one to integrate FUN: R^dim-->R
  # a,b are dim-dimensional vectors specifying the limits of integration.
  # Each (ai,bi), aiEb, biEb, will be partitioned in N segments of same size.
  dim <- length(a)
  x <- seq(a[1], b[1], (b[1]-a[1])/N)
  if (dim==1){
    fi <- sapply(x, FUN)
  } else{
    fi <- sapply(x, function (x){
      trapezoid(N, a[-1], b[-1], function(y) FUN(c(x,y)))
    })
    
  }
  return(((b[1]-a[1])/(2*N))*sum(fi[-1]+fi[-(N+1)]))
}
# Example: the volume of a sphere with n=20:
trapezoid(20, c(-1,-1,-1), c(1, 1, 1), function(x) {sum(x^2)<=1})
## [1] 4.154
# real volume
(4/3)*pi

# Para probar utilizar
# trapecio( c(0,1), function(x) x*x, eps=.1)
# integrate (function(x) x*x, 0,1)  

