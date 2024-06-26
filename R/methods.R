# getters ------------------------------------------------------------

#' Get \code{counts} slot for an object of class \code{Counts}
#' 
#' @param object object of class \code{Counts}
#' 
#' @return counts vector from a \code{Counts} object
#' 
setGeneric(name = "get_counts", def = function(object) standardGeneric("get_counts"))


#' @describeIn Counts Returns counts from a \code{Counts} object
#' 
#' @return counts vector from a \code{Counts} object
#' 
#' @export
#' 
setMethod(
  f = "get_counts",
  signature = "Counts",
  definition = function(object) {
    return(object@counts)
  }
)


#' Get \code{fractions} slot for an object of class \code{Counts}
#' 
#' @param object object of class \code{Counts}
#' 
#' @returns fractions vector from a \code{Counts} object
#' 
setGeneric(name = "get_fractions", def = function(object) standardGeneric("get_fractions"))


#' @describeIn Counts Returns fractions from a \code{Counts} object
#' 
#' @return fractions vector from a \code{Counts} object
#' 
#' @export
#' 
setMethod(
  f = "get_fractions",
  signature = "Counts",
  definition = function(object) {
    return(object@fractions)
  }
)


# setters ------------------------------------------------------------

#' Set \code{counts} slot for an object of class \code{Counts}
#' 
#' @param object object of class \code{Counts}
#' @param value numeric vector of counts
#' 
#' @return an object of class \code{Counts}
#' 
setGeneric(name = "set_counts<-", def = function(object, value) standardGeneric("set_counts<-"))


#' @describeIn Counts Replaces counts of a \code{Counts} object with the provided values
#' 
#' @param object object of class \code{Counts}
#' @param value numeric vector of counts
#' 
#' @return an object of class \code{Counts}
#' 
#' @export
#' 
setReplaceMethod(
  f = "set_counts",
  signature = "Counts",
  definition = function(object, value) {
    
    # set counts
    object@counts <- as.integer(value)
    
    # validate
    validObject(object)
    
    return(object)
  }
)


#' Set \code{fractions} slot for an object of class \code{Counts}
#' 
#' @param object object of class \code{Counts}
#' @param value numeric vector of sampling fractions
#'
#' @return an object of class \code{Counts}
#'
setGeneric(name = "set_fractions<-", def = function(object, value) standardGeneric("set_fractions<-"))


#' 
#' @describeIn Counts Replaces fractions of a \code{Counts} object with the provided values
#'
#' @param object object of class \code{Counts}
#' @param value numeric vector of sampling fractions
#' 
#' @return an object of class \code{Counts}
#' 
#' @export
#' 
setReplaceMethod(
  f = "set_fractions",
  signature = "Counts",
  definition = function(object, value) {
    
    # set fractions
    object@fractions <- value
    
    # validate
    validObject(object)
    
    return(object)
  }
)


# print and summary ------------------------------------------------------------

#' Print method for \code{Counts} class
#' 
#' @param object object of class \code{Counts}
#' 
#' @return no return value, called for side effects
#' 
setMethod(
  f = "show",
  signature = "Counts",
  definition = function(object) {
    
    cat("# A 'Counts' object", "\n")
    cat("| counts: ", object@counts, "\n")
    cat("| fractions: ", object@fractions, "\n")
    cat("| prior support: ", paste0("[", object@n_start, ":", object@n_end, "]"), "\n")
    
    # if posterior computed
    if (length(object@posterior) > 0) {
      cat("| posterior:", head(object@posterior, 3), "...", tail(object@posterior, 3), "\n")
    }
    
    if (length(object@map) > 0) {
      cat("| MAP: ", object@map, "\n")
    }
    
    if (length(object@map_p) > 0) {
      cat("| maximum posterior probability: ", object@map_p, "\n")
    }
    
    if (length(object@q_low) > 0 && length(object@q_up) > 0) {
      cat("| credible interval (", 100 * signif(object@q_up_cum_p - object@q_low_cum_p, 3), "% level): ", 
          paste0("[", object@q_low, ":", object@q_up, "]"), "\n", sep = "")
    }
  }
)


#' Summary method for \code{Counts} class
#' 
#' @param object object of class \code{Counts}
#' @param ... additional parameters affecting the summary produced
#' 
#' @return no return value, called for side effects
#' 
#' @export
#' 
setMethod(
  f = "summary",
  signature = "Counts",
  definition = function(object, ...) {
    
    cat("# A 'Counts' object", "\n")
    cat("| counts: ", object@counts, "\n")
    cat("| fractions: ", object@fractions, "\n")
    cat("| prior support: ", paste0("[", object@n_start, ":", object@n_end, "]"), "\n")
    
    has_posterior <- ifelse(!identical(object@posterior, numeric(0)), TRUE, FALSE)
    
    cat("| posterior available: ", has_posterior, "\n")
  
  }
)


# plot ------------------------------------------------------------

#' Plot method for \code{Counts} class
#' 
#' @param x object of class \code{Counts}
#' @param y none
#' @param ... additional parameters to be passed to \link{plot_posterior}
#' 
#' @return no return value, called for side effects
#' 
#' @export
#' 
setMethod(
  f = "plot",
  signature = "Counts",
  definition = function(x, ...) {
    
    # if posterior computed
    if (length(x@posterior) > 0 || x@gamma == TRUE) {
    
      # plot posterior density  
      plot_posterior(x, ...)
    }
    else {
      stop("No posterior available. Please use `compute_posterior` to compute it")
    }
  }
)


# posterior ------------------------------------------------------------


#' Compute the posterior probability distribution of the population size 
#' for an object of class \code{Counts}
#' 
#' @description Compute the posterior probability distribution of the population size 
#' using a discrete uniform prior and a binomial likelihood ("dup" algorithm, Comoglio et al.). 
#' An approximation using a Gamma prior and a Poisson likelihood is used when 
#' applicable ("gamma" algorithm) method (see Clough et al. for details)
#' 
#' @param object object of class \code{Counts}
#' @param n_start start of prior support range
#' @param n_end end of prior support range
#' @param replacement was sampling performed with replacement? Default to FALSE
#' @param b prior rate parameter of the gamma distribution used to compute the posterior with Clough. Default to 1e-10
#' @param alg algorithm to be used to compute posterior. One of ... . Default to "dup" 
#' 
#' @return an object of class \code{Counts}
#' 
#' @references Comoglio F, Fracchia L and Rinaldi M (2013) 
#' Bayesian inference from count data using discrete uniform priors. 
#' \href{https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0074388}{PLoS ONE 8(10): e74388}
#' 
#' @references Clough HE et al. (2005) 
#' Quantifying Uncertainty Associated with Microbial Count Data: A Bayesian Approach. 
#' \href{https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1541-0420.2005.030903.x}{Biometrics 61: 610-616}
#' 
#' @author Federico Comoglio
#'
#' @examples 
#' counts <- new_counts(counts = c(20,30), fractions = c(0.075, 0.10))
#' 
#' # default parameters ("dup" algorithm, sampling without replacement, default prior support)
#' posterior <- compute_posterior(counts)
#' 
#' # custom prior support ("dup" algorithm)
#' posterior <- compute_posterior(counts, n_start = 0, n_end = 1e3)
#' 
#' # gamma prior ("gamma" algorithm)
#' posterior <- compute_posterior(counts, alg = "gamma")
#' 
#' # sampling with replacement
#' posterior <- compute_posterior(counts, replacement = TRUE)
#' 
setGeneric(name = "compute_posterior", 
           def = function(object, n_start, n_end, replacement = FALSE, b = 1e-10, alg = "dup") {
             standardGeneric("compute_posterior")
           })
          

#' 
#' @describeIn Counts Compute the posterior probability distribution of the population size
#' 
#' @param object object of class \code{Counts}
#' @param n_start start of prior support range
#' @param n_end end of prior support range
#' @param replacement was sampling performed with replacement? Default to FALSE
#' @param b prior rate parameter of the gamma distribution used to compute the posterior with Clough. Default to 1e-10
#' @param alg algorithm to be used to compute posterior. One of ... . Default to "dup" 
#' 
#' @return an object of class \code{Counts}
#'
#' @export
#' 
setMethod(
  f = "compute_posterior",
  signature = "Counts",
  definition = function(object, n_start, n_end, replacement = FALSE, b, alg = "dup") {
    
    # validate input data type
    if(!is(object, "Counts")) {
      stop("Input object not of class `Counts`")
    }
    
    # validate algorithm key
    valid_alg <- c("dup", "gamma")
    
    if(!alg %in% valid_alg) {
      stop("Invalid algorithm name. Please provide one of `dup` or `gamma` to argument `alg`")
    }
    
    # unpack
    counts    <- object@counts
    fractions <- object@fractions
    f_product <- object@f_product
    
    # compute total counts and sum of sampling fractions
    total_counts <- sum(counts)
    f_sum        <- sum(fractions)
    
    # if range start not provided
    if (missing(n_start)) {
      # get it from object
      n_start <- object@n_start
    } else {
      # set range start
      object@n_start <- n_start
    }
    
    # if range end not provided
    if (missing(n_end)) {
      # get it from object
      n_end <- object@n_end
    } else {
      # set range end
      object@n_end <- n_end
    }
    
    # compute posterior
    switch(alg,
      "dup" = {
        # with replacement, using Clough et al.
        if (f_sum < 1 / 32) { 
          message("Effect of replacement negligible, used Gamma approximation")
          posterior        <- gamma_poisson_clough(object, n_start, n_end, b = b)
          object@posterior <- posterior

          return(object)
        }
        
        s <- n_start : n_end
        
        # with replacement
        if (replacement) { 
          denominator          <- compute_normalization_constant(counts, n_start, n_end, f_product)
          posterior            <- sapply(s, compute_posterior_with_replacement, counts, f_product, denominator)
          object@norm_constant <- denominator
          object@posterior     <- posterior
          
          return(object)
        }
        # without replacement
        else {
          posterior        <- dnbinom(s - total_counts, total_counts + 1, f_sum)
          object@posterior <- posterior
          
          return(object)
        }
      },
      
      # with gamma-poisson, using Clough et al.
      "gamma" = {
        posterior        <- gamma_poisson_clough(object, n_start, n_end, b = b)
        object@posterior <- posterior

        return(object)
      }
    )
  }
)


#' Compute posterior probability distribution parameters (e.g. credible intervals)
#' for an object of class \code{Counts}
#' 
#' @description This function computes posterior parameters and credible intervals 
#' at the given confidence level (default to 95\%).
#' 
#' @param object object of class \code{Counts}
#' @param low 1 - right tail posterior probability
#' @param up left tail posterior probability
#' @param ... additional parameters to be passed to \link{plot_posterior}
#' 
#' @return an object of class \code{Counts}
#' 
#' @references Comoglio F, Fracchia L and Rinaldi M (2013) 
#' Bayesian inference from count data using discrete uniform priors. 
#' \href{https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0074388}{PLoS ONE 8(10): e74388}
#' 
#' @references Clough HE et al. (2005) 
#' Quantifying Uncertainty Associated with Microbial Count Data: A Bayesian Approach. 
#' \href{https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1541-0420.2005.030903.x}{Biometrics 61: 610-616}
#' 
#' @author Federico Comoglio
#'
#' @examples 
#' counts <- new_counts(counts = c(20,30), fractions = c(0.075, 0.10))
#' 
#' # default parameters ("dup" algorithm, sampling without replacement, default prior support)
#' posterior <- compute_posterior(counts)
#' 
#' get_posterior_param(posterior)
#' 
setGeneric(name = "get_posterior_param", 
           def = function(object, low = 0.025, up = 0.975, ...) {
             standardGeneric("get_posterior_param")
           })


#' 
#' @describeIn Counts Extract statistical parameters (e.g. credible intervals) 
#' from a posterior probability distribution
#'
#' @param object object of class \code{Counts}
#' @param low 1 - right tail posterior probability
#' @param up left tail posterior probability
#' @param ... additional parameters to be passed to \link{plot_posterior}
#' 
#' @return an object of class \code{Counts}
#'
#' @export
#' 
setMethod(
  f = "get_posterior_param",
  signature = "Counts",
  definition = function(object, low = 0.025, up = 0.975, ...) {
    
    # unpack
    posterior <- object@posterior
    
    # if posterior computed with dup
    if (!is.null(posterior)) {
      
      # unpack 
      n_start <- object@n_start
      n_end   <- object@n_end
      s       <- n_start : n_end
      
      # compute posterior params
      map_index <- which.max(posterior)
      map_p     <- posterior[map_index]
      map       <- s[map_index]
      
      # compute cumulative
      ecdf <- compute_ecdf(posterior)
    
      # compute lower bound of credible interval
      if (all(ecdf > low)) {
        
        q_low_index <- 1L
        q_low_p     <- posterior[q_low_index]
        q_low_cum_p <- 0
        q_low       <- 0

      }
      else {
      
        lower_index <- which((ecdf <= low) == TRUE)
        q_low_index <- lower_index[length(lower_index)]
        q_low_p     <- posterior[q_low_index]
        q_low_cum_p <- ecdf[q_low_index]
        q_low       <- s[q_low_index]
      
      }
      
      # compute upper bound of credible interval
      upper_index <- which((ecdf >= up) == TRUE)
      q_up_index  <- upper_index[1]
      q_up_p      <- posterior[q_up_index]
      q_up_cum_p  <- ecdf[q_up_index]
      q_up        <- s[q_up_index]
      
    }
    
    # posterior from a gamma-poisson
    else {
      
      # unpack
      counts    <- object@counts
      fractions <- object@fractions
      
      # compute total counts and sum of sampling fractions
      total_counts    <- sum(counts)
      total_fractions <- sum(fractions)
      
      # update slot
      object@gamma <- TRUE
      
      # set gamma params
      a <- 1
      b <- 1e-10
      
      # compute quantiles
      q_low <- round(qgamma(low, a + total_counts, b + total_fractions))
      q_up  <- round(qgamma(up, a + total_counts, b + total_fractions))
      
      # update prior support
      n_start <- round(0.9 * q_low)
      n_end   <- round(1.1 * q_up)
      
      # compute posterior params
      map         <- round(total_counts / (total_fractions + b))
      map_index   <- ifelse(n_start == 0, map, map - n_start + 1)
      map_p       <- dgamma(map, a + total_counts, b + total_fractions)
      q_low_index <- as.integer(ifelse(n_start == 0, q_low, q_low - n_start + 1))
      q_low_p     <- dgamma(q_low, a + total_counts, b + total_fractions)
      q_low_cum_p <- pgamma(q_low, a + total_counts, b + total_fractions)
      q_up_index  <- as.integer(ifelse(n_start == 0, q_up, q_up - n_start + 1))
      q_up_p      <- dgamma(q_up, a + total_counts, b + total_fractions)
      q_up_cum_p  <- pgamma(q_up, a + total_counts, b + total_fractions)
      
    }

    # update slots
    object@n_start     <- n_start
    object@n_end       <- n_end
    object@map_p       <- map_p
    object@map_index   <- map_index
    object@map         <- map
    object@q_low_p     <- q_low_p
    object@q_low_index <- q_low_index
    object@q_low_cum_p <- q_low_cum_p
    object@q_low       <- q_low
    object@q_up_p      <- q_up_p
    object@q_up_index  <- q_up_index
    object@q_up_cum_p  <- q_up_cum_p
    object@q_up        <- q_up
    
    return(object)
    
  }
)


#' Plot posterior probability distribution and display posterior parameters
#' for an object of class \code{Counts}
#' 
#' @param object object of class \code{Counts}
#' @param low 1 - right tail posterior probability
#' @param up left tail posterior probability
#' @param xlab x-axis label. Default to 'n' (no label)
#' @param step integer defining the increment for x-axis labels (distance between two consecutive tick marks)
#' @param ... additional parameters to be passed to \link{curve}
#' 
#' @return no return value, called for side effects
#' 
#' @references Comoglio F, Fracchia L and Rinaldi M (2013) 
#' Bayesian inference from count data using discrete uniform priors. 
#' \href{https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0074388}{PLoS ONE 8(10): e74388}
#' 
#' @author Federico Comoglio
#'
#' @examples 
#' counts <- new_counts(counts = c(20,30), fractions = c(0.075, 0.10))
#' 
#' # default parameters ("dup" algorithm, sampling without replacement, default prior support)
#' posterior <- compute_posterior(counts)
#' 
#' # plot posterior
#' plot_posterior(posterior, type = 'l', lwd = 3, col = 'blue3')
#' 
setGeneric(name = "plot_posterior", 
           def = function(object, low = 0.025, up = 0.975, xlab, step, ...) {
             
             standardGeneric("plot_posterior")
             
          })


#' 
#' @describeIn Counts Plot posterior probability distribution and posterior parameters
#' 
#' @param object object of class \code{Counts}
#' @param low 1 - right tail posterior probability
#' @param up left tail posterior probability
#' @param xlab x-axis label. Default to 'n' (no label)
#' @param step integer defining the increment for x-axis labels (distance between two consecutive tick marks)
#' @param ... additional parameters to be passed to \link{curve}
#' 
#' @return no return value, called for side effects
#'
#' @export
#' 
setMethod(
  f = "plot_posterior",
  signature = "Counts",
  definition = function(object, low = 0.025, up = 0.975, xlab, step, ...) {
    
    # validate input type
    if(!is(object, "Counts")) {
      stop("Input object not of class `Counts`")
    }
    
    # unpack
    counts    <- object@counts
    fractions <- object@fractions
    posterior <- object@posterior
    
    post_params <- get_posterior_param(object, low, up)
    n1 <- post_params@n_start
    n2 <- post_params@n_end
    s <- n1:n2
    a <- 1
    b <- 1e-10
    main.text <- paste("Posterior probability distribution \n ", "K=", sum(counts), "; ", "R=", sum(fractions), sep = "")
    if (!is.null(posterior)) {
      l <- length(s)
      plot(posterior,
        xaxt = "n", pch = 19, cex = 0.5,
        main = main.text, xlab = ifelse(missing(xlab), "n", xlab), ylab = "density", ylim = c(0, 1.05 * max(posterior)), ...
      )
      if (missing(step)) {
        axis(side = 1, at = seq(1, l, by = round(l / 15)), labels = seq(n1, n2, by = round(l / 15)))
      }
      else {
        at <- which(s %% step == 0)
        axis(side = 1, at = at, labels = s[at])
      }
      abline(v = post_params@map_index, lwd = 1.5, col = "blue3")
      lines(c(post_params@q_low_index, post_params@q_low_index), c(0, post_params@q_low_p), lwd = 1.5, lty = 2, col = "gray50")
      lines(c(post_params@q_up_index, post_params@q_up_index), c(0, post_params@q_up_p), lwd = 1.5, lty = 2, col = "gray50")
      rect(post_params@q_low_index, 0, post_params@q_up_index, 1 / 30 * post_params@map_p, col = "gray70")
    }
    else {
      l <- n2 - n1 + 1
      x <- NULL
      curve(dgamma(x, a + sum(counts), b + sum(fractions)),
        from = n1, to = n2,
        xaxt = "n", pch = 19, cex = 0.5,
        main = main.text, xlab = ifelse(missing(xlab), "n", xlab), ylab = "density", ...
      )
      if (missing(step)) {
        axis(side = 1, at = seq(1, l, by = round(l / 15)), labels = seq(n1, n2, by = round(l / 15)))
      }
      else {
        at <- which(s %% step == 0)
        axis(side = 1, at = at, labels = s[at])
      }
      abline(v = post_params@map, lwd = 1.5, col = "blue3")
      lines(c(post_params@q_low, post_params@q_low), c(0, post_params@q_low_p), lwd = 1.5, lty = 2, col = "gray50")
      lines(c(post_params@q_up, post_params@q_up), c(0, post_params@q_up_p), lwd = 1.5, lty = 2, col = "gray50")
      rect(post_params@q_low, 0, post_params@q_up, 1 / 30 * post_params@map_p, col = "gray70")
    }
    leg <- legend("topright",
      legend = c(
        paste("MAP: ", post_params@map, ", (p=", signif(post_params@map_p, 3), ")", sep = ""),
        paste("CI: [", s[post_params@q_low_index], ",", s[post_params@q_up_index], "]", sep = ""),
        paste("CL: ", signif(1 - (signif(post_params@q_up_cum_p, 3) - signif(post_params@q_low_cum_p, 3)), 3), sep = ""),
        paste("Tails: [", signif(post_params@q_low_cum_p, 3), ",", 1 - signif(post_params@q_up_cum_p, 3), "]", sep = "")
      ),
      col = c("blue3", NA, NA, "gray50"), lty = c(1, 0, 0, 2), lwd = c(2, 0, 0, 2),
      fill = c(NA, "gray70", "gray70", NA), bty = "n", border = rep("white", 4), plot = TRUE
    )
    # add counts table
    D <- cbind(counts, fractions)
    colnames(D) <- c("Counts", "Fractions")
    rownames(D) <- 1:nrow(D)
    addtable2plot(leg$rect$left + leg$rect$w / 3, post_params@map_p * 0.85,
      xjust = 0, yjust = 0, D, bty = "o",
      display.rownames = FALSE, hlines = FALSE
    )
  }
)
