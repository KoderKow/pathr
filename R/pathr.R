#' @export
print.pathr <- function(x, ..., sep = "") {
  if (length(x) > 0) {
    elements <- unlist(x)
    clean_names <- str_replace(names(elements), "\\.", "_")
    names(elements) <- clean_names

    for (i in seq_along(elements)) {
      cat("- ", names(elements[i]), ": ", elements[i], "\n", sep = "")
    }
  }

  invisible(x)
}
