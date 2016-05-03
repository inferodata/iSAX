\name{iSA}
\alias{iSA}
\title{The iSA algorithm}
\description{
This function implements the iSA - integrated Sentiment Analysis algorihtm}
\usage{
iSA(Strain, Stest, Dtrain, nboot = 1000, predict = FALSE,
    ret.boot = FALSE, seqlen = 5, sparse = FALSE, verbose = TRUE)
}
\arguments{
  \item{Strain}{a vector of stem strings belonging to the training set}
  \item{Stest}{a vector of stem strings belonging to the test set}
  \item{Dtrain}{a vector of codings belonging to the training set}
  \item{nboot}{number of bootstrap replications for standard error estimation}
  \item{predict}{non in use}
  \item{ret.boot}{return all bootstrap estimates?}
  \item{seqlen}{length of substrings used in iSA}
  \item{sparse}{use sparse matrix to store data?}
  \item{verbose}{show all steps?}
}
\details{
Prediction is implemented but only beta. Use it at your own risk.
}
\value{
    \item{est}{estimated parameters}
    \item{tab}{table of results}
    \item{best}{bootstrap estimated parameters}
    \item{btab}{table of results for bootstrap estimates}
    \item{pred}{prediction for each entry}
    \item{tim}{execution time}
}
\references{
Iacus, S.M., Curini, L., Ceron, A. (2015) iSA (U.S. provisional patent application No. 62/215264)
}
\author{Stefano M. Iacus}
\seealso{\code{\link{prep.data}}}
\keyword{ data }
