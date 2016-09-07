
n_sim<-1000
n_personas <-25

x <- numeric(n_personas)

experimentos <- replicate(n_sim, {
  bdays <- sample.int(365, n_personas, repl=T)
  exito <- (anyDuplicated(bdays)>0)
  exito
})
prob_exito <- mean(experimentos)



personas_necesarias <- (n_sim,{
  i<-1
  bdays <- sample.int(365, 1)
  while(anyDuplicated(bdays)==0){
    bdays <- c(bdays, sample.int(365,1))
    i<-i+1
  }
  i
})