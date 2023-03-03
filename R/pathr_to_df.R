#' Turn pathr object to a data.frame
#'
#' Turn a single of list of pathr objects in a data.frame for analysis.
#'
#' @param x A pathr object.
#'
#' @return A data.frame with as many rows as there were pathr objects.
#' @export
#'
#' @examples
#' urls <- c(
#'   "https://github.com/KoderKow/pathr1",
#'   "https://github.com/KoderKow/pathr2"
#' )
#'
#' x <- parse_url(urls)
#'
#' d <- pathr_to_df(x)
#'
#' d
pathr_to_df <- function(x) {
  is_pathr(x)

  if (is_single_pathr(x)) {
    d <- as.data.frame(lapply(x, null_to_na))
  } else {
    l_x <- lapply(x, \(.x) lapply(.x, null_to_na))
    d <- as.data.frame(do.call(rbind, lapply(l_x, unlist)))
  }

  d[d == "NULL"] <- NA

  return(d)
}
