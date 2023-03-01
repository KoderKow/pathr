
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pathr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pathr)](https://CRAN.R-project.org/package=pathr)
[![Codecov test
coverage](https://codecov.io/gh/KoderKow/pathr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/KoderKow/pathr?branch=main)
[![R-CMD-check](https://github.com/KoderKow/pathr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KoderKow/pathr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of pathr is to simplify the process of string manipulations for
URLs and file paths. This uses modified functions from the
[{httr}](https://github.com/r-lib/httr) to create opinionated functions
that allow working with URLs and paths easier.

## Installation

You can install the development version of pathr like so:

``` r
devtools::install_github("koderkow/pathr")
```

## URLs

### Basic URLs

``` r
library(pathr)
```

Sort components of a URL

``` r
url <- "https://github.com/KoderKow/pathr"

x <- parse_url(url)

x
#> Url: https://github.com/KoderKow/pathr
#> - scheme: https
#> - hostname: github.com
#> - path: KoderKow/pathr

str(x)
#> List of 10
#>  $ scheme  : chr "https"
#>  $ hostname: chr "github.com"
#>  $ port    : NULL
#>  $ path    : chr "KoderKow/pathr"
#>  $ file    :List of 3
#>   ..$ dir : NULL
#>   ..$ file: NULL
#>   ..$ ext : NULL
#>  $ query   : NULL
#>  $ params  : NULL
#>  $ fragment: NULL
#>  $ username: NULL
#>  $ password: NULL
#>  - attr(*, "class")= chr [1:2] "pathr" "character"
```

Put it back to together

``` r
build_url(x)
#> [1] "https://github.com/KoderKow/pathr"
```

### URLs with a file path

URLs with item paths will be detected

``` r
url <- "https://github.com/KoderKow/pathr/example-folder/my-data.csv"

x <- parse_url(url)

x
#> Url: https://github.com/KoderKow/pathr/example-folder/my-data.csv
#> - scheme: https
#> - hostname: github.com
#> - path: KoderKow/pathr/example-folder/my-data.csv
#> - file_dir: KoderKow/pathr/example-folder
#> - file_file: my-data
#> - file_ext: csv

str(x)
#> List of 10
#>  $ scheme  : chr "https"
#>  $ hostname: chr "github.com"
#>  $ port    : NULL
#>  $ path    : chr "KoderKow/pathr/example-folder/my-data.csv"
#>  $ file    :List of 3
#>   ..$ dir : chr "KoderKow/pathr/example-folder"
#>   ..$ file: chr "my-data"
#>   ..$ ext : chr "csv"
#>  $ query   : NULL
#>  $ params  : NULL
#>  $ fragment: NULL
#>  $ username: NULL
#>  $ password: NULL
#>  - attr(*, "class")= chr [1:2] "pathr" "character"
```

Building the URL ignores the file element

``` r
build_url(x)
#> [1] "https://github.com/KoderKow/pathr/example-folder/my-data.csv"
```

## Thanks to

- [{httr}](https://github.com/r-lib/httr) package for the code for
  `parse_url()` and `build_url()`
