n_pathr <- function(x) {
  if (length(x) == 0) {
    n <- 0
  } else if (is_single_pathr(x)) {
    n <- 1
  } else {
    n <- length(x)
  }

  return(n)
}
