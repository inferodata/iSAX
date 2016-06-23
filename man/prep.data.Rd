\name{prep.data}
\alias{prep.data}
\title{Prepares data for iSA algorithm}
\description{Prepares data for iSA algorithm. This is a pre-processing step which performs stemming and other cleaning steps.}
\usage{
prep.data(corpus, th=0.99, lang="english", train=NULL,
          use.all=TRUE, shannon=FALSE, verbose=FALSE,
          stripWhite=TRUE, removeNum=TRUE, removePunct=TRUE,
          removeStop=TRUE, toPlain=TRUE, doGC=FALSE)
}
\arguments{
    \item{corpus}{a corpus from the \code{tm} package}
    \item{th}{threshold used to drop stems}
    \item{lang}{language of texts. mainly used for stemming}
    \item{train}{a vector of tags for the training set}
    \item{use.all}{use all data or just the traning set?}
    \item{shannon}{use Shannon entropy?}
    \item{stripWhite}{force stripWhite? if not JP or CN always TRUE}
    \item{removeNum}{removeNum? if not JP or CN always TRUE}
    \item{removePunct}{removePunct? if not JP or CN always TRUE}
    \item{removeStop}{removeStop? if not JP or CN always TRUE}
    \item{toPlain}{convert to plain text internally? if not JP or CN always TRUE}
    \item{doGC}{perform garbage collection? Better TRUE for large corpus}
    \item{verbose}{should show all steps?}
}
\details{This function requires \code{tm} package to performs stemming.}
\value{
A list with components:
  \item{S}{the vector of stem strings}
  \item{dtm}{the document-term matrix}
  \item{train}{the vector of tags for the training data}
  \item{train}{the vselected threshold}
}
\references{
Iacus, S.M., Curini, L., Ceron, A. (2015) iSA (U.S. provisional patent application No. 62/215264)
Ceron, A., Curini, L., Iacus, S.M. (2016) iSA: A fast, scalable and accurate algorithm for sentiment analysis of social media content, Information Sciences, V. 367-368, p. 105-124.
}
\author{Stefano M. Iacus}
\seealso{\code{\link{iSA}}}
\keyword{ data }
