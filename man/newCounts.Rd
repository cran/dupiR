\name{newCounts}
\docType{methods}
\alias{newCounts-methods}
\alias{newCounts,Counts-method}
\alias{newCounts}

\title{Constructor of objects of class Counts}

\description{
Constructor of objects of class Counts
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
K
#or (a little bit more informative) use:
summary(K)
}   

\keyword{methods}

   