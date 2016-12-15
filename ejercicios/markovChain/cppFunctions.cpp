
#include <Rcpp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp 
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
Rcpp::NumericVector timesTwo(Rcpp::NumericVector x) {
  return x * 2;
}

// [[Rcpp::export]]
int sampleC(Rcpp::NumericVector prob)
  {
    // comprobamos que la probabilidad sume 1
    prob =  prob / Rcpp::sum(prob);
    Rcpp::NumericVector cumprob = Rcpp::cumsum(prob);
    //runif regresa un NumericVector que es un arreglo de doubles
    double u = Rcpp::runif(1)[0];
    int i = 0;
    while(cumprob[i]<u)
    {
      i++;
    }
    // vamos a trabajar con indices que empiezan en uno
    return i+1;    
  }

// [[Rcpp::export]]
int mc_transition (int current_state, Rcpp::NumericMatrix trans_mat)
{
  //Rcpp::_se vuelve _ si incluyen el namespace
  Rcpp::NumericVector prob = trans_mat(current_state-1, Rcpp::_);
  int new_state = sampleC(prob);
  return new_state;
}

// [[Rcpp::export]]
Rcpp::NumericVector mc_trajectory(int init_state, int nobs, Rcpp::NumericMatrix trans_mat)
  {
  //Llama al constructor de clase NumericVector
  Rcpp::NumericVector trajectory(nobs + 1);  
  trajectory[0] = init_state;  
  for(int i=0; i < nobs; i++)
  {
    trajectory[i + 1] = mc_transition(trajectory[i], trans_mat);
  }
  return trajectory;
  }
// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically 
// run after the compilation.
//

