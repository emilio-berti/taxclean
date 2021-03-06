% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxclean.R
\name{gbif_tax_res}
\alias{gbif_tax_res}
\title{Get GBIF taxonomy resolution
Retrieve the taxonomy resolution according to GBIF.}
\usage{
gbif_tax_res(sp, parallel = FALSE, n_cores = 6)
}
\arguments{
\item{sp}{species name.}

\item{parallel}{logical, weather to parallelize or not.}

\item{n_cores}{number of cores to use in parallilization.}
}
\value{
a string with the taxonomic level of the organism.
}
\description{
Get GBIF taxonomy resolution
Retrieve the taxonomy resolution according to GBIF.
}
\details{
Calls sequentially \code{rm_whitespace()}, \code{rm_extra()},
\code{rm_abbr()}, \code{rm_punct()}, \code{rm_whitespace()},
\code{rm_cf()}, and \code{rm_var()}.
}
