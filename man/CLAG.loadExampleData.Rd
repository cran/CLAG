\name{CLAG.loadExampleData}
\alias{CLAG.loadExampleData}
\title{Load example data set provided with CLAG}
\description{
  Load an example data set provided with CLAG.
  See the referene article for a description of the sets.
}
\usage{
CLAG.loadExampleData(set)
}
\arguments{
  \item{set}{The name of the data set to load.
  If not given, prints the names of the available data sets.}
}
\value{
  The returned value is a data frame,
  or a list with the data frame and row and column ids.
  The data sets are discribed in the article (see below).
}
\references{
CLAG: an unsupervised non hierarchical clustering algorithm handling biological data, Linda Dib, Alessandra Carbone, BMC Bioinformatics 2012, 13:194
}
\examples{
BREAST <- CLAG.loadExampleData("BREAST")
GLOBINE <- CLAG.loadExampleData("GLOBINE")
DIM128 <- CLAG.loadExampleData("DIM128")
}
\keyword{cluster}
