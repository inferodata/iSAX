\name{expo}
\alias{expo}
\docType{data}
\title{The Expo data Set}
\description{
This data set consists of a subset of 28195 tweets concerning international reactions (i.e. excluding Italy) on the forthcoming Expo2015 event   (see \url{http://www.expo2015.org/en/index.html})
in Milan. The tweets were written in English and published worldwide between the 1st of November 2013 and the 31st of May 2014, using the keyword \code{expo2015}.
}
\usage{data(expo)}
\examples{
data(expo)
S <- expo$S # iSA feature vectors
dtm <- expo$dtm  # DocumentTerm matrix
dim(dtm)
table(tr)  # the hand coded data tags
}
\keyword{datasets}
