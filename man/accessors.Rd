\name{getCounts}
\docType{methods}
\alias{getCounts-methods}
\alias{getCounts,Counts-method}
\alias{getCounts}
\alias{getFractionss-methods}
\alias{getFractions,Counts-method}
\alias{getFractions}

\title{Accessors for the 'counts' and 'fractions' slots of a Counts object.}

\description{
Each measurement consists of an integer count and a matched sampling fraction. The counts and fractions slots contain the results of an arbitrary set of measurements.

The counts slot is am integer vector of counts 
	
The fractions slot is a numeric vector of matched sampling fractions	
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
K <- newCounts( counts = c(20,30), fractions = c(0.075, 0.1))

getCounts(K)
getFractions(K)
}   

\keyword{methods}

   