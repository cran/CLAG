# CLAG: an unsupervised non hierarchical clustering algorithm
# Copyright (c) 2013, Linda DIB, Raphael CHAMPEIMONT, Alessandra CARBONE
#                     UMR 7238 Génomique des Microorganismes
#                     CNRS - Université Pierre et Marie Curie
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this list
#   of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Author of R package: Raphael Champeimont
# UMR 7238 Genomique des Microorganismes
# This R package allows for easy use of CLAG.
# CLAG: an unsupervised non hierarchical clustering algorithm
# handling biological data, by Linda Dib and Alessandra Carbone

.onAttach <- function(libname, pkgname) {
	if (system2("perl", args=c("--version"), stdout=FALSE, stderr=FALSE) != 0) {
	  warning("WARNING: Perl not found. You need to install Perl to use CLAG.")
    if (.Platform$OS.type == "windows") {
      warning("You can download a Perl distribution from: http://strawberryperl.com/")
    }
	} else {
	  packageStartupMessage("CLAG ready.")
	}
}

CLAG.path <- system.file("Perl/TOOLCLAG-minimal", package="CLAG")
CLAG.data.path <- system.file("extdata/dataCLAG", package="CLAG")

CLAG.writeInput <- function(A, outfile, rowIds=NULL, colIds=NULL) {
  f <- file(outfile, "w")
  N <- nrow(A)
  M <- ncol(A)
  if (is.null(rowIds)) {
    rowIds <- 1:nrow(A)
  }
  if (is.null(colIds)) {
    colIds <- 1:ncol(A)
  }
  for (i in 1:N) {
    for (j in 1:M) {
      cat(rowIds[[i]], " ", colIds[[j]], " ", A[i,j], "\n", sep="", file=f)
    }
  }
  close(f)
}

CLAG.readInput <- function(infile, p=1) {
  rawInput <- read.table(infile, sep=" ", header=FALSE, stringsAsFactors=FALSE)
  rowIds <- sort(unique(rawInput[,1]))
  colIds <- sort(unique(rawInput[,2]))
  destRows <- match(rawInput[,1], rowIds)
  destCols <- match(rawInput[,2], colIds)
  colIndices <- 
  MAT <- matrix(NA, nrow=length(rowIds), ncol=length(colIds))
  for (i in 1:nrow(rawInput)) {
    MAT[destRows[i], destCols[i]] <- rawInput[i,3]
  }
  DATA <- list(M=MAT, rowIds=rowIds, colIds=colIds)
  
  return(DATA)
}


CLAG.exec <- function(f, p=1, k=0, d=NULL, verbose=TRUE) {
  exefile <- paste(CLAG.path, "/exe-RCommand.pl", sep="")
  if (!file.exists(exefile)) {
    stop(paste(exefile, "does not exist"))
  }
  cargs <- c(paste("-f=", shQuote(f), sep=""),
             paste("-p=", p, sep=""))
  if (!is.null(k)) {
    cargs <- c(cargs, paste("-k=", k, sep=""))
  }
  if (!is.null(d)) {
    cargs <- c(cargs, paste("-d=", d, sep=""))
  }
  if (verbose) {
    cargs <- c(cargs, "-verbose")
  }
  cargs <- c(shQuote(exefile), cargs)
  if (verbose) cat("perl", paste(cargs, collapse=" "), "\n")
  oldwd <- getwd()
  setwd(CLAG.path)
  status <- system2("perl", args=cargs)
  setwd(oldwd)
  
  if (status == 0) {
    return(0)
  } else {
    return(1)
  }
}

CLAG.readClusters <- function(fpath) {
  if (!file.exists(fpath)) {
    stop("No CLAG result file.")
  }
  f <- file(fpath, open="r")
  firstLine <- readLines(con=f, n=1)
  close(f)
  if (length(firstLine) == 0) {
    return(NULL)
  } else {
    return(read.table(fpath, sep=":", header=FALSE, fill=TRUE, stringsAsFactors=FALSE, row.names=NULL))
  }
}

CLAG.removeDir <- function(outputDir) {
  unlink(outputDir, recursive=TRUE)
}


CLAG.clust <- function(M,
                       delta=0.05,
                       threshold=0,
                       analysisType=1,
                       normalization="affine-global",
                       rowIds=NULL,
                       colIds=NULL,
                       verbose=FALSE,
                       keepTempFiles=FALSE) {
  
  RES <- list()
  RES$M <- M
  
  if (analysisType != 1 && analysisType != 2 && analysisType != 3) {
    stop("analysisType must be 1, 2, or 3")
  } else {
    analysisType <- as.integer(analysisType)
  }
  
  
  if (analysisType != 2) {
    # Variables are real
    if (delta <= 0 || delta > 1) {
      stop("delta must be between 0 and 1")
    }
    d <- 100*delta
  } else {
    d <- 0
  }
  
  if (analysisType == 3) {
    if (is.null(colIds) && nrow(M) != ncol(M)) {
      stop("No column ids provided although analysisType=3 and matrix is non-square")
    }
  }
  
  if (is.null(rowIds)) {
    rowIds <- 1:nrow(M)
  } else {
    if (nrow(M) != length(rowIds)) {
      stop("rowIds need to contain as many elements as rows in matrix")
    }
    if (anyDuplicated(rowIds)) {
      stop("rowIds need to be unique")
    }
  }
  
  if (is.null(colIds)) {
    colIds <- 1:ncol(M)
  } else {
    if (ncol(M) != length(colIds)) {
      stop("colIds need to contain as many elements as columns in matrix")
    }
    if (anyDuplicated(colIds)) {
      stop("colIds need to be unique")
    }
  }
  
  if (analysisType == 3) {
    if (!all(colIds %in% rowIds)) {
      stop("column ids need to be a subset of row ids when analysisType=3")
    }
  }
  
  if (analysisType != 2) {
    if (normalization == "affine-global") {
      r <- range(M, na.rm=TRUE)
      M <- (M - r[1])/(r[2] - r[1])
    } else if (normalization == "affine-column") {
      for (j in 1:ncol(M)) {
        r <- range(M[,j], na.rm=TRUE)
        M[,j] <- (M[,j] - r[1])/(r[2] - r[1])
      }
    } else if (normalization == "rank-column") {
      for (j in 1:ncol(M)) {
        M[,j] <- (rank(M[,j]) - 1)/(nrow(M) - 1)
      }
    } else {
      stop("invalid normalization method specified")
    }
    RES$A <- M
  } else {
    normalization <- NULL
  }

  outdir <- tempfile("CLAG_")
  dir.create(outdir)
  if (verbose) cat("Writing to", outdir, "\n")
  fn <- paste(outdir, "/input.txt", sep="")
  CLAG.writeInput(M, fn, rowIds=rowIds, colIds=colIds)
  
  status <- CLAG.exec(f=outdir, p=analysisType, k=threshold, d=d, verbose=verbose)
  
  if (status == 0) {
    if (analysisType != 2) {
      respath <- paste(outdir, "/aggregation-", d, ".txt", sep="")
    } else {
      respath <- paste(outdir, "/aggregation.txt", sep="")
    }
    rawClusters <- CLAG.readClusters(respath)
  }
  
  if (!keepTempFiles) {
    CLAG.removeDir(outdir)
  }
  
  if (status != 0) {
    stop("CLAG failed")
  }
  
  RES$cluster <- rep(0L, nrow(M))
  if (!is.null(rawClusters) && nrow(rawClusters) > 0) {
    for (i in 1:nrow(rawClusters)) {
      elements <- as.integer(strsplit(rawClusters[i,1], split=" ")[[1]])
      indices <- match(elements, rowIds)
      if (any(RES$cluster[indices] != 0L)) {
        stop("unexpected error: element in 2 key aggregates")
      }
      RES$cluster[indices] <- i
      if (analysisType == 3) {
        RES$firstSymScore <- c(RES$firstScores, as.numeric(rawClusters[i,3]))
        RES$lastSymScore <- c(RES$lastScores, as.numeric(rawClusters[i,4]))
        RES$firstEnvScore <- c(RES$firstScores, as.numeric(rawClusters[i,5]))
        RES$lastEnvScore <- c(RES$lastScores, as.numeric(rawClusters[i,6]))
      } else {
        RES$firstEnvScore <- c(RES$firstScores, as.numeric(rawClusters[i,3]))
        RES$lastEnvScore <- c(RES$lastScores, as.numeric(rawClusters[i,4]))
      }
    }
    RES$nclusters <- nrow(rawClusters)
  } else {
    RES$nclusters <- 0
  }
  RES$delta <- delta
  RES$threshold <- threshold
  RES$analysisType <- analysisType
  RES$rowIds <- rowIds
  RES$colIds <- colIds
  RES$rawClusters <- rawClusters
  return(RES)
}



CLAG.loadExampleData <- function(set=NULL) {
  if (is.null(set)) {
    cat("Available data sets: BREAST, GLOBINE, DIM128, DIM128-subset\n")
    return(NULL)
  }
  if (set %in% c("BREAST","GLOBINE")) {
    return(CLAG.readInput(paste(CLAG.data.path, "/", set, ".txt", sep="")))
  } else if (set == "DIM128") {
    return(read.table(paste(CLAG.data.path, "/DIM128.txt", sep="")))
  } else if (set == "DIM128-subset") {
    return(read.table(paste(CLAG.data.path, "/DIM128-subset.txt", sep="")))
  } else {
    stop(paste("unknown CLAG example data set:", set))
  }
}

