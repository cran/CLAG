# Author of R package: Raphael Champeimont
# UMR 7238 Genomique des Microorganismes
# This R package allows for easy use of CLAG.
# CLAG: an unsupervised non hierarchical clustering algorithm
# handling biological data, by Linda Dib and Alessandra Carbone

This is a version of CLAG modified by Raphael Champeimont
that is meant to be used as a backend for the R CLAG package.

Differences with original CLAG:
- plot generation by Perl scripts disabled
- fix "binary" mode
- remove pretreatement as it is done by the R code
- Windows compatibility added
- added -verbose argument
