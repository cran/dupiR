\name{Counts}
\docType{class}
\alias{Counts-class}
\alias{summary,Counts-method}


\title{Class "Counts" -- a container for measurements information and inference results}
\description{This is the main class for the present package.}
\section{Objects from the Class}{
Objects should be created with calls to \code{\link{newCounts}}.
}

\note{ 
The slot \code{counts} contains 
The slot \code{fractions} contains 
The slot \code{n1}
The slot \code{n2}
The slot \code{X}
The slot \code{mle}
The slot \code{nconst}
The slot \code{posterior}
}

\seealso{
\code{\link{newCounts}}
}

\examples{
# create an object of class 'Counts' by using new
new('Counts', counts = c(30, 35), fractions = c(0.075, 0.1))

#or by means of the constructor
newCounts(counts = c(30, 35), fractions = c(0.075, 0.1))
}

\keyword{class}