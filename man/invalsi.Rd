\name{invalsi}
\alias{invalsi}
\docType{data}
\title{The Invalsi data Set}
\description{
The INVALSI "Istituto nazionale per la valutazione del sistema educativo di istruzione e di formazione" data set is a subset of 15398 tweets from the original data collected during the days of the administration of a national test to secondary school children in Italy (from  May 6th to June 18th, 2014). The INVALSI data set includes only tweets that include the word or the hashtag \code{INVALSI}. Unfortunately, Twitter policies do not allow for the distribution of the original data, and the original IDs where lost, but this R version provides the Document-Term matrix which is enough for the text-ming task.
}
\usage{data(invalsi)}
\examples{
data(invalsi)
S <- invalsi$S # iSA feature vectors
dtm <- invalsi$dtm  # DocumentTerm matrix
dim(dtm)
table(tr)  # the hand coded data tags
}
\keyword{datasets}
