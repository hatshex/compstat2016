library(Rcpp)
sourceCpp('cppFunctions.cpp')
timesTwo(c(15,30))
sampleC(c(.5,.5))

mat <-  matrix (c(.5, .5, .2 ,.8), byrow = TRUE, nrow = 2)
dimnames(mat)<-list(c("sol", "lluvia"),c("sol", "lluvia"))
mat

mc_transition(1,mat)
traj <- mc_trajectory(init_state = 1, nobs = 100, trans_mat = mat)
dict <- c("1" = "sol", "2"="lluvia")
dict[traj]