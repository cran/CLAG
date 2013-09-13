\name{compareClusterings}
\alias{compareClusterings}
\title{Compare two clusterings of the same elements (and print results)}
\description{
Same as \code{\link{mapClusterings}} except that is prints nicely the result
instead of just returning it.
}
\usage{
compareClusterings(cl1, cl2, verbose=FALSE, use.solve.LSAP=NULL)
}
\arguments{
  \item{cl1}{First clustering, see \code{\link{mapClusterings}}.}
  \item{cl2}{Second clustering.}
  \item{verbose}{Display information about tested cases.}
  \item{use.solve.LSAP}{Whether to use solve_LSAP function from package clue.
  If NULL (the default), solve_LSAP will be used only if the package clue
  is installed.}
}
\examples{
compareClusterings(c(0,1,1,1,2,2,2,3,3,3,3), c(0,3,3,3,1,1,1,2,2,2,2), verbose=TRUE)

compareClusterings(c(0,1,1,1,2,2,2,3,3,3,3,0), c(3,1,3,3,1,1,1,2,0,2,4,0), verbose=TRUE)
}
\keyword{cluster}
