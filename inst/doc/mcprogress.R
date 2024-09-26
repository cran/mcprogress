## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE
)
library(parallel)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("mcprogress")

## ----eval = FALSE-------------------------------------------------------------
#  devtools::install_github("myles-lewis/mcprogress")

## ----eval=FALSE---------------------------------------------------------------
#  library(mcprogress)
#  
#  # toy example
#  res <- pmclapply(letters[1:20], function(i) {
#                   Sys.sleep(0.2 + runif(1) * 0.1)
#                   setNames(rnorm(5), paste0(i, 1:5))
#                   }, mc.cores = 2, title = "Working")
#  

## ----eval=FALSE---------------------------------------------------------------
#  Working  |================================                 |  60%  eta 3.1 secs

## ----out.width='80%', echo=FALSE----------------------------------------------
knitr::include_graphics("mcp1.png")

## ----out.width='65%', echo=FALSE----------------------------------------------
knitr::include_graphics("mcp2.png")

## ----eval=FALSE---------------------------------------------------------------
#  library(parallel)
#  
#  my_fun <- function(x, cores) {
#    start <- Sys.time()
#    mcProgressBar(0, title = "my_fun")  # initialise progress bar
#  
#    res <- mclapply(seq_along(x), function(i) {
#      # inner loop of calculation
#      y <- 1:4
#      inner <- lapply(seq_along(y), function(j) {
#        Sys.sleep(0.2 + runif(1) * 0.1)
#        mcProgressBar(val = i, len = length(x), cores, subval = j / length(y),
#                      title = "my_fun", start = start)
#        rnorm(4)
#      })
#      inner
#    }, mc.cores = cores)
#  
#    closeProgress(start, title = "my_fun")  # finalise the progress bar
#    res
#  }
#  
#  output <- my_fun(letters[1:4], cores = 2)

## ----eval=FALSE---------------------------------------------------------------
#  ## Example of long function
#  longfun <- function(x, cores) {
#    start <- Sys.time()
#    mcProgressBar(0, title = "longfun")  # initialise progress bar
#  
#    res <- mclapply(seq_along(x), function(i) {
#      # long sequential calculation in parallel with 3 major steps applied to x[i]
#      Sys.sleep(0.5)
#      mcProgressBar(val = i, len = length(x), cores, subval = 0.33,
#                    title = "longfun", start = start)  # 33% complete
#      Sys.sleep(0.5)
#      mcProgressBar(val = i, len = length(x), cores, subval = 0.66,
#                    title = "longfun", start = start)  # 66% complete
#      Sys.sleep(0.5)
#      mcProgressBar(val = i, len = length(x), cores, subval = 1,
#                    title = "longfun", start = start)  # 100% complete
#      return(rnorm(4))
#    }, mc.cores = cores)
#  
#    closeProgress(start, title = "longfun")  # finalise the progress bar
#    res
#  }
#  
#  output <- longfun(letters[1:4], cores = 2)

## ----eval=FALSE---------------------------------------------------------------
#  # Example from doMC vignette
#  library(doMC)
#  library(foreach)
#  registerDoMC(4)
#  
#  x <- iris[which(iris[,5] != "setosa"), c(1,5)]
#  trials <- 10000
#  
#  {
#    start <- Sys.time()
#    r <- foreach(i = seq_len(trials), .combine = cbind) %dopar% {
#      ind <- sample(100, 100, replace = TRUE)
#      result1 <- glm(x[ind, 2] ~ x[ind, 1], family = binomial(logit))
#      mcProgressBar(i, trials, cores = getDoParWorkers(), start = start)
#      coefficients(result1)
#    }
#    closeProgress(start)
#  }
#  
#  # Equivalent using pmclapply
#  r <- pmclapply(seq_len(trials), function(i) {
#    ind <- sample(100, 100, replace = TRUE)
#    result1 <- glm(x[ind, 2] ~ x[ind, 1], family = binomial(logit))
#    coefficients(result1)
#  }, mc.cores = 4)

## ----eval=FALSE---------------------------------------------------------------
#  res <- mclapply(1:5, function(i) {
#    Sys.sleep(runif(1) /10)
#    message_parallel("Process ", i, " done")
#    rnorm(1)
#  })
#  ## Process 1 done
#  ## Process 3 done
#  ## Process 2 done
#  ## Process 5 done
#  ## Process 4 done

## ----eval=FALSE---------------------------------------------------------------
#  out <- mclapply(1:5, function(i) {
#    rnorm(-1)
#  }, mc.cores = 2)  # change mc.cores = 1 to reveal actual error message
#  ## Warning in mclapply(1:5, function(i) {: all scheduled cores encountered errors
#  ## in user code

## ----eval=FALSE---------------------------------------------------------------
#  out <- mclapply(1:5, function(i) {
#    j = 4 + i
#    rnorm(-1) |> catchError(i, j)
#  }, mc.cores = 2)
#  ## Error in rnorm(-1) : invalid arguments
#  ## i=1, j=5
#  ## Error in rnorm(-1) : invalid arguments
#  ## i=2, j=6

## ----eval=FALSE---------------------------------------------------------------
#  res <- mclapply(1:5, function(i) {
#    Sys.sleep(runif(1) /10)
#    if (i == 5) mcstop("My error message")
#    rnorm(1)
#  })
#  ## My error message

