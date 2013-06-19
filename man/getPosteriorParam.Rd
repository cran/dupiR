\name{getPosteriorParam}
\docType{methods}
\alias{getPosteriorParam-methods}
\alias{getPosteriorParam,Counts-method}
\alias{getPosteriorParam}

\title{Obtain statistical parameters from the posterior density.}

\description{
Obtain statistical parameters from the posterior density.
}

\section{Methods}{
\describe{

\item{\code{signature(object = "Counts")}}{
an object of class Counts.
%%  ~~describe this method here~~
}
}}

\seealso{
\code{\link{Counts-class}, \link{plotPosterior}}
}

\author{
   Federico Comoglio, federico.comoglio@bsse.ethz.ch
}

\examples{
K <- newCounts( counts = c(20,30), fractions = c(0.075, 0.10))

#using default parameters (DUP, sampling without replacement and default prior support)
K.dup <- computePosterior(K)

getPosteriorParam(K.dup)

}   

\keyword{methods}

   