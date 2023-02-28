#' @inherit httr::build_url
build_url <- function (url) {
  stopifnot(is_pathr(url))

  scheme <- url$scheme
  hostname <- url$hostname

  if (!is.null(url$port)) {
    port <- paste0(":", url$port)
  } else {
    port <- NULL
  }

  path <- paste(gsub("^/", "", url$path), collapse = "/")

  if (!is.null(url$params)) {
    params <- paste0(";", url$params)
  } else {
    params <- NULL
  }

  if (is.list(url$query)) {
    query <- compose_query(compact(url$query))
  } else {
    query <- url$query
  }

  if (!is.null(query) && nzchar(query)) {
    stopifnot(is.character(query), length(query) == 1)
    query <- paste0("?", query)
  }

  if (is.null(url$username) && !is.null(url$password)) {
    stop("Cannot set password without username")
  }

  paste0(
    scheme, "://", url$username, if (!is.null(url$password))
    ":", url$password, if (!is.null(url$username))
      "@", hostname, port, "/", path, params, query, if (!is.null(url$fragment))
        "#", url$fragment
    )
}
