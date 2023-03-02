#' Remove pathr class
#'
#' Simplifies removing the pathr class for situations where the custom class, pathr, is causing issues with workflows.
#'
#' @param x Object to remove pathr class from.
#'
#' @return This function handles two things
#' - Single object: The object, x, returned with [unclass()] called if the class pathr existed
#' - List of objects: The list of objects, x, returned with [unclass()] called on each object if the class of all items in the list of objects are pathr
#' @export
#'
#' @examples
#' url <- "https://github.com/KoderKow/pathr"
#'
#' x <- parse_url(url)
#'
#' class(x)
#'
#' y <- remove_pathr(x)
#'
#' class(y)
remove_pathr <- function(x) {
  res <- x

  if (is_single_pathr(x)) {
    res <- unclass(x)
  } else {
    if (all(vapply(x, is_pathr, logical(1)))) {
      res <- lapply(x, unclass)
    }
  }

  return(res)
}
