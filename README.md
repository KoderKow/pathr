
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

The goal of {pathr} is to simplify the process of string manipulations
for URLs and file paths. This uses modified functions from the
[{httr}](https://github.com/r-lib/httr) to create opinionated functions
that allow working with URLs and paths easier.

## Installation

You can install the development version of {pathr} like so:

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
#> - url: https://github.com/KoderKow/pathr
#> - scheme: https
#> - hostname: github.com
#> - host_info_name: github
#> - host_info_extension: com
#> - path: KoderKow/pathr

str(x)
#> List of 15
#>  $ url                : chr "https://github.com/KoderKow/pathr"
#>  $ scheme             : chr "https"
#>  $ hostname           : chr "github.com"
#>  $ host_info_name     : chr "github"
#>  $ host_info_extension: chr "com"
#>  $ port               : NULL
#>  $ path               : chr "KoderKow/pathr"
#>  $ file_dir           : NULL
#>  $ file_name          : NULL
#>  $ file_ext           : NULL
#>  $ query              : NULL
#>  $ params             : NULL
#>  $ fragment           : NULL
#>  $ username           : NULL
#>  $ password           : NULL
#>  - attr(*, "class")= chr [1:2] "list" "pathr"
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
#> - url: https://github.com/KoderKow/pathr/example-folder/my-data.csv
#> - scheme: https
#> - hostname: github.com
#> - host_info_name: github
#> - host_info_extension: com
#> - path: KoderKow/pathr/example-folder/my-data.csv
#> - file_dir: KoderKow/pathr/example-folder
#> - file_name: my-data
#> - file_ext: csv

str(x)
#> List of 15
#>  $ url                : chr "https://github.com/KoderKow/pathr/example-folder/my-data.csv"
#>  $ scheme             : chr "https"
#>  $ hostname           : chr "github.com"
#>  $ host_info_name     : chr "github"
#>  $ host_info_extension: chr "com"
#>  $ port               : NULL
#>  $ path               : chr "KoderKow/pathr/example-folder/my-data.csv"
#>  $ file_dir           : chr "KoderKow/pathr/example-folder"
#>  $ file_name          : chr "my-data"
#>  $ file_ext           : chr "csv"
#>  $ query              : NULL
#>  $ params             : NULL
#>  $ fragment           : NULL
#>  $ username           : NULL
#>  $ password           : NULL
#>  - attr(*, "class")= chr [1:2] "list" "pathr"
```

Building the URL ignores the file element

``` r
build_url(x)
#> [1] "https://github.com/KoderKow/pathr/example-folder/my-data.csv"
```

### Vector of URLS

``` r
urls <- c(
  "https://github.com/KoderKow/pathr1",
  "https://github.com/KoderKow/pathr2"
)

x <- parse_url(urls)

x
#> [[1]]
#> - url: https://github.com/KoderKow/pathr1
#> - scheme: https
#> - hostname: github.com
#> - host_info_name: github
#> - host_info_extension: com
#> - path: KoderKow/pathr1
#> 
#> [[2]]
#> - url: https://github.com/KoderKow/pathr2
#> - scheme: https
#> - hostname: github.com
#> - host_info_name: github
#> - host_info_extension: com
#> - path: KoderKow/pathr2

str(x)
#> List of 2
#>  $ :List of 15
#>   ..$ url                : chr "https://github.com/KoderKow/pathr1"
#>   ..$ scheme             : chr "https"
#>   ..$ hostname           : chr "github.com"
#>   ..$ host_info_name     : chr "github"
#>   ..$ host_info_extension: chr "com"
#>   ..$ port               : NULL
#>   ..$ path               : chr "KoderKow/pathr1"
#>   ..$ file_dir           : NULL
#>   ..$ file_name          : NULL
#>   ..$ file_ext           : NULL
#>   ..$ query              : NULL
#>   ..$ params             : NULL
#>   ..$ fragment           : NULL
#>   ..$ username           : NULL
#>   ..$ password           : NULL
#>   ..- attr(*, "class")= chr [1:2] "list" "pathr"
#>  $ :List of 15
#>   ..$ url                : chr "https://github.com/KoderKow/pathr2"
#>   ..$ scheme             : chr "https"
#>   ..$ hostname           : chr "github.com"
#>   ..$ host_info_name     : chr "github"
#>   ..$ host_info_extension: chr "com"
#>   ..$ port               : NULL
#>   ..$ path               : chr "KoderKow/pathr2"
#>   ..$ file_dir           : NULL
#>   ..$ file_name          : NULL
#>   ..$ file_ext           : NULL
#>   ..$ query              : NULL
#>   ..$ params             : NULL
#>   ..$ fragment           : NULL
#>   ..$ username           : NULL
#>   ..$ password           : NULL
#>   ..- attr(*, "class")= chr [1:2] "list" "pathr"
```

#### Working with a *pathr* object

Below are three common methods for turning a lists of lists into a data
frame. The base R method is built into the {pathr} package due to it
needing no dependencies. The other methods, data.table and dplyr, go
over the process for those work flows.

#### Base R

``` r
pathr_to_df(x)
#>                                  url scheme   hostname host_info_name
#> 1 https://github.com/KoderKow/pathr1  https github.com         github
#> 2 https://github.com/KoderKow/pathr2  https github.com         github
#>   host_info_extension port            path file_dir file_name file_ext query
#> 1                 com   NA KoderKow/pathr1       NA        NA       NA    NA
#> 2                 com   NA KoderKow/pathr2       NA        NA       NA    NA
#>   params fragment username password
#> 1     NA       NA       NA       NA
#> 2     NA       NA       NA       NA
```

##### data.table

``` r
d <- data.table::rbindlist(x)

#> Warning message:
#> In data.table::rbindlist(x) :
#>   Column 6 ['port'] of item 1 is length 0. This (and 17 others like it) has been filled with NA (NULL for list columns) to make each item uniform.
```

##### dplyr

The *pathr* class does not play nicely with `dplyr::bind_rows`.

``` r
d <- 
  x |> 
  dplyr::bind_rows()
  
#> Error in `dplyr::bind_rows()`:
#> ! Argument 1 must be a data frame or a named atomic vector.
#> Run `rlang::last_error()` to see where the error occurred.
```

The function `remove_pathr()` will unclass any *pathr* object or a list
containing nothing but *pathr* objects. This makes it easy to move the
object into Rs default class, list.

``` r
d <-
  x |>
  remove_pathr() |>
  dplyr::bind_rows()
```

## Thanks to

- [{httr}](https://github.com/r-lib/httr) package for the code for
  `parse_url()` and `build_url()`
