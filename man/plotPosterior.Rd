\name{plotPosterior}
\docType{methods}
\alias{plotPosterior-methods}
\alias{plotPosterior,Counts-method}
\alias{plotPosterior}
\alias{plot-method}
\alias{plot,Counts-method}

\title{Plot posterior densities}

\description{
Plot posterior densities
}

\section{Methods}{
\describe{

\item{\code{signature(object = "Counts")}}{
an object of class Counts.
%%  ~~describe this method here~~
}
}}

\seealso{
\code{\link{Counts-class}}
}

\author{
   Federico Comoglio, federico.comoglio@bsse.ethz.ch
}

\examples{
K <- newCounts( counts = c(20,30), fractions = c(0.075, 0.10))

#using default parameters (DUP, sampling without replacement and default prior support)
K.dup <- computePosterior(K)

plotPosterior(K.dup, type = 'l', lwd = 3, col = 'blue3', low = 0.025, up = 0.975)
}   

\keyword{methods}

   