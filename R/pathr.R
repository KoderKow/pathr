#' @export
print.pathr <- function(x, ..., sep = "\n") {
  if (length(x) > 0) {
    cat("Url: ", build_url(x), "\n", ..., sep = sep)
  }

  invisible(x)
}
