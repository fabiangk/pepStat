% Generated by roxygen2 (4.0.0): do not edit by hand
\name{summarizePeptides}
\alias{summarizePeptides}
\title{Add information to a peptideSet and summarize peptides}
\usage{
summarizePeptides(peptideSet, summary = "median", position = NULL)
}
\arguments{
\item{peptideSet}{A \code{peptideSet}, as created by \code{makePeptideSet}}

\item{summary}{A \code{character} string. The method used for merging replicates.
Available are: "mean" and "median".}

\item{position}{A \code{data.frame} or \code{GRanges} object. A peptide
collection such as the ones available in \code{pepDat}. See details below
and vignettes for more information.}
}
\value{
An object of class \code{peptideSet} with added columns and updated ranges.
}
\description{
This function merges the replicates and adds information from a peptide collection
to a peptideSet. This collection can include coordinates, alignment information,
Z-scales, and other peptide information.
}
\details{
The object in the position argument will be passed to \code{create_db}, it
can either be a \code{GRanges} object with a peptide as a metadata column, or
a \code{data.frame} that can be used to create such \code{GRanges}.

Some peptide collections can be found in the \code{pepDat} package.
}
\examples{
## This example curated from the vignette -- please see vignette("pepStat")
## for more information
if (require("pepDat")) {

  ## Get example GPR files + associated mapping file
  dirToParse <- system.file("extdata/gpr_samples", package = "pepDat")
  mapFile <- system.file("extdata/mapping.csv", package = "pepDat")

  ## Make a peptide set
  pSet <- makePeptideSet(files = NULL, path = dirToParse,
                         mapping.file = mapFile, log=TRUE)

  ## Plot array images -- useful for quality control
  plotArrayImage(pSet, array.index = 1)
  plotArrayResiduals(pSet, array.index = 1, smooth = TRUE)

  ## Summarize peptides, using pep_hxb2 as the position database
  data(pep_hxb2)
  psSet <- summarizePeptides(pSet, summary = "mean", position = pep_hxb2)

  ## Normalize the peptide set
  pnSet <- normalizeArray(psSet)

  ## Smooth
  psmSet <- slidingMean(pnSet, width = 9)

  ## Make calls
  calls <- makeCalls(psmSet, freq = TRUE, group = "treatment",
                     cutoff = .1, method = "FDR", verbose = TRUE)

  ## Produce a summary of the results
  summary <- restab(psmSet, calls)

}
}
\author{
Raphael Gottardo, Greory Imholte
}
\seealso{
\code{\link{makePeptideSet}}, \code{\link{create_db}},
\code{\link{create_db}}
}

