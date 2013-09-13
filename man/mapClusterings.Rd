\name{mapClusterings}
\alias{mapClusterings}
\title{Compare two clusterings of the same elements}
\description{
This function solves this problem:
Given two clusterings of the same elements, how many elements are in a different cluster, when we map for the best the clusters of the first clustering to the second?

The function finds the best mapping between clusters of cl1 with clusters of cl2 (injective in both directions - but not necessarly surjective), that is such that the number of differently clustered elements is minimum.

An element e is identically clustered if one of these conditions is true:
\enumerate{
\item it belongs to a cluster i in cl1 
  and j in cl2 and i is associated with j.
\item e is unclustered in both cl1 and cl2
}
Differently clustered is the opposite.
}
\usage{
mapClusterings(cl1, cl2, verbose=FALSE, use.solve.LSAP=NULL)
}
\arguments{
  \item{cl1}{A vector of integers such that cl1[i] is the number (>= 1) of the cluster in which i is. 0 is a special value that means the element is not clustered. (This is the format of the cluster field returned by \code{\link{CLAG.clust}})}
  \item{cl2}{The same for the other clustering.}
  \item{verbose}{Display information about tested cases.}
  \item{use.solve.LSAP}{Whether to use solve_LSAP function from package clue.
  If NULL (the default), solve_LSAP will be used only if the package clue
  is installed.}
}
\details{
We propose two methods for computing the number of differently
clustered elements: using the solve_LSAP function from package clue
or using our branch and bound algorithm. You can choose which one to use
by setting the use.solve.LSAP parameter.

The solve_LSAP function is much faster both in practice and theory
(it is polynomial) but requires the clue package to be installed.
See its own help page for information about how it works.

The branch and bound algorithm we provide works like this: For a cluster i in the first clustering, it tries to associate it with every cluster j not already associated (and also to leave it alone), and for each of this choices explores recursively the choice for cluster i+1. In the worst case it runs in exponential time.

The exploration is optimized by:
\itemize{
  \item considering only choices of j for which at least one element would be common with i (otherwise it would always be better to not associate i at all)
  \item exploring j other than 0 before 0 (more likely to find solution faster)
  \item keeping in memory the "best association found", cutting a branch if the clusters already associated at the node already generate more differently clustered elements that in the best association found
  \item stopping exploration in case a perfect solution (ndiff=0) is found
}
}
\value{
The returned value is a list with several members:
  \item{ndiff}{The number of elements differently clustered.}
  \item{assoc}{Cluster mapping. assoc[i] = j means cluster i in first
  clustering is associated to cluster j in second clustering.
  If j = 0, i is not associated to any cluster.}
  \item{diffclust}{A vector of integers of length ndiff giving the indices of elements that are differently clustered.}
}
\examples{
mapClusterings(c(0,1,1,1,2,2,2,3,3,3,3,0), c(3,1,3,3,1,1,1,2,0,2,4,0))
}
\seealso{\code{\link{compareClusterings}}}
\keyword{cluster}
