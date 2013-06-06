\name{CLAG.clust}
\alias{CLAG.clust}
\title{Run cluster analysis with CLAG}
\description{
  This function computes clusters with the CLAG algorithm.
  CLAG is an unsupervised non hierarchical clustering algorithm, especially adapted for data sets with many variables, like is often the case with biological data. It does not ask for all data points to cluster.
  To understand what the parameters are, please refer to the reference
  article (see below). This function returns what is called "key aggregates" in the article.
}
\usage{
CLAG.clust(M, delta=0.05, threshold=0, analysisType=1,
  normalization="affine-global", rowIds=NULL, colIds=NULL,
  verbose=FALSE, keepTempFiles=FALSE)
}
\arguments{
  \item{M}{A matrix or data frame where rows are points to cluster and columns are variables.}
  \item{delta}{Delta is a parameter which influences how CLAG decides whether two values are near or not. This parameter is ignored if we are analyzing a discrete matrix (if analysisType=2). Examples: 0.05, 0.1, 0.2}
  \item{threshold}{Threshold to apply to the environment score
(if analysisType is 1 or 2) or to both symmetric and environment
scores (if analysisType is 3). Examples: 0, 0.5, 1}
  \item{analysisType}{Set to 1 for a general matrix where rows are points and columns are real variables. Set to 2 for the case when the variables are discrete (can be strings, integers or boolean). Set to 3 if the variables are real and are themselves a (strict or not) superset of the points AND you want to take in account the symmetric score. In that case the matching between rows and colums is specified using the rowIds and colIds parameters.}
  \item{normalization}{Only relevent for real variables (analysisType is 1 or 3). A string in "affine-global", "affine-column", "rank-column". CLAG works by first computing a global distribution for all values in the matrix, assumed to be in [0,1]. By default, it performs a single affine transform on all values on the matrix ("affine-global"), that is the minimum value in the matrix is mapped to 0 while the maximum is mapped to 1. While this is relevant if variables are in comparable units, it is innapropriate if they represent very different magnitudes. For this latter case, two other normalization methods are provided. The first, "affine-column", does the same affine transform but independently for every column, that is it maps minima of columns to 0 and maxima of columns to 1. This might be inappropriate if distribution shapes are very different between columns. The second method, "rank-column", replaces values by their ranks in the specific column, therefore making every columns distribution uniform.}
  \item{rowIds}{When analysisType=3, used to specify integer ids for rows. Its length must be equal to the number of rows un the matrix. Not necessary for a square matrix.}
  \item{colIds}{When analysisType=3, used to specify integer ids for columns. Its length must be equal to the number of columns un the matrix. If not given, it is assumed to be 1:nrow(M).}
  \item{verbose}{Display the underlying CLAG program output during computation.}
  \item{keepTempFiles}{Keep temporary files created by CLAG execution (useful for debugging).}
}
\value{
The returned value is a list with several members:
  \item{nclusters}{Number of final clusters found by CLAG (called "key aggregates" in the article)}
  \item{cluster}{A vector of integers indicating the cluster id (from 1 to nclusters) to which each point is allocated. Value 0 means the point is not in any cluster (there may or may not be such points).}
  \item{firstEnvScore}{Environmental score of the first before-aggregation cluster in each aggregated cluster.}
  \item{lastEnvScore}{Environmental score of the last before-aggregation cluster in each aggregated cluster.}
  \item{firstSymScore}{Symmetric score of the first before-aggregation cluster in each aggregated cluster. Only when analysisType=3.}
  \item{lastSymScore}{Symmetric score of the last before-aggregation cluster in each aggregated cluster. Only when analysisType=3.}
  \item{A}{The input matrix normalized with the method chosen.
  (except when analyzing discrete variables)}
  Members \code{delta}, \code{threshold}, \code{analysisType}, \code{M}, \code{rowIds} and \code{colIds} contain the original arguments given to CLAG. 
}
\references{
CLAG: an unsupervised non hierarchical clustering algorithm handling biological data, Linda Dib, Alessandra Carbone, BMC Bioinformatics 2012, 13:194
}
\examples{
# Example with real variables
data(DIM128, package="CLAG")
# Take a subset (this is to make the example fast
# but you can use the entire dataset)
M <- DIM128[seq(1, nrow(DIM128), by=20),]
# Run the cluster analysis
RES <- CLAG.clust(M)
# Display points in 2D using a PCA and color them by cluster
# except unclunsted points which are left black.
PCA <- prcomp(M)
clusterColors <- c("black", rainbow(RES$ncluster))
plot(PCA$x[,1], PCA$x[,2], col=clusterColors[RES$cluster+1], main=paste(RES$nclusters, "clusters"))
}
\keyword{cluster}
