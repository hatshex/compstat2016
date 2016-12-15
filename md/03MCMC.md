#### Tarea 3: MCMC, regresión lineal y estadística Bayesiana
* **Forma de entrega**: Shiny app
* **Fecha recomendada de terminación**:  octubre
* **Objetivo**: Hacer un análisis *regresión lineal simple bayesiana* usando Markov Chain Monte Carlo. Deben incluir algún tipo de análisis de diagnóstico.
El objetivo es *predecir* una variable *y* usando otra variable aleatoria *x*. Detrás hay un modelo de la forma
<div align="center">y = a + x*beta + eps con eps x ~ N(0, sigma^2)</div>
  Los parámetros desconocidos del modelo son `a`, `beta` y `eps` (el efecto de x y la precisión del ajuste respecitivamente).
En un análisis bayesiano suponemos una distribución inicial para estos parámetros. La distribución inicial debe ser un reflejo de su certidumbre o incertidumbre de cierto valor que podría tomar. El usuario debe dar sus suposiciones iniciales.
* **Input mínimo**
  + Parámetros para las distribuciones iniciales. Vamos a suponer que son de la forma <br/> `a ~ N(a_0, sda_0^2), beta ~ N(b_0, sdb_0^2), sigma_0 ~ Gamma(shape0, scale0)`
+ `n_sim`: número de simulaciones para el Método de MCMC que elijan
+ Parámetros adicionales para el modelo de MCMC que elija. Por ejemplo, si elije Random-Walk Metropolis tienen que elegir un tamaño de brinco.
* **Output mínimo**
  + Herramientas de diagnóstico numéricas y visuales para evaluar al convergencia del MCMC
+ Un `scatterplot` de `x` con `y` con la linea `hat(y) = a + beta*x` encimada.
+ Tiempo de cómputo.
* **Instrucciones adicionales**: Su método debe estar programado en `Rcpp`. Si utilizan alguna bibliografía para elejir sus métodos pueden ponerlo en la app. Si quieren sorprender al maestro intenten un método adaptativo de Metropolis-Hasting en vez del método de Random-walk.

### Tarea 3b: MCMC, historia y avances
* Leer el artículo "The MCMC revolution". Hacer una síntesis de una página de los avances que ha habido en el área. 
