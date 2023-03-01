# 2023-03-01 Copied from https://github.com/r-lib/httr/blob/main/R/url.r

#' Parse and build urls according to RFC3986.
#'
#' See <https://www.rfc-editor.org/rfc/rfc3986> for details of parsing algorithm.
#'
#' @param url Character. For `parse_url` a character vector (of length 1) to parse
#'   into components; for `build_url` a list of components to turn back
#'   into a string.
#' @return a list containing:
#' * scheme
#' * hostname
#' * port
#' * path
#' * item, a list containing dir, file, and extension
#' * params
#' * fragment
#' * query, a list
#' * username
#' * password
#' @export
#' @examples
#' parse_url("http://google.com/")
#' parse_url("http://google.com:80/")
#' parse_url("http://google.com:80/?a=1&b=2")
#'
#' url <- parse_url("http://google.com/")
#' url$scheme <- "https"
#' url$query <- list(q = "hello")
#' build_url(url)
parse_url <- function(url) {
  if (is_pathr(url)) {
    return(url)
  }

  # url <- url_original
  # url_original <- url

  url <- as.character(url)

  stopifnot(length(url) == 1)

  pull_off <- function(pattern) {
    if (!str_detect(url, pattern)) {
      return(NULL)
    }

    piece <- str_match(url, pattern)[, 2]
    url <<- str_replace(url, pattern, "")

    return(piece)
  }

  fragment <- pull_off("#(.*)$")
  scheme <- pull_off("^([[:alpha:]][[:alpha:][:digit:]+.-]*):")
  netloc <- pull_off("^//([^/?]*)/?")

  if (identical(netloc, "")) {
    url <- paste0("/", url)
    port <- username <- password <- hostname <- NULL
  } else if (!is.null(netloc)) {
    pieces <- strsplit(netloc, "@")[[1]]

    if (length(pieces) == 1) {
      username <- NULL
      password <- NULL
      host <- pieces
    } else {
      user_pass <- strsplit(pieces[[1]], ":")[[1]]
      username <- user_pass[1]

      if (length(user_pass) == 1) {
        password <- NULL
      } else {
        password <- user_pass[2]
      }

      host <- pieces[2]
    }

    host_pieces <- str_split(host, ":")[[1]]

    hostname <- host_pieces[1]

    port <- if (length(host_pieces) > 1) {
      host_pieces[2]
    }
  } else {
    port <- username <- password <- hostname <- NULL
  }

  query <- pull_off("\\?(.*)$")

  if (!is.null(query)) {
    query <- parse_query(query)
  }

  params <- pull_off(";(.*)$")

  # Is path a file?
  if (grepl("\\.\\w+$", url)) {
    dir <- sub("/[^/]*$", "", url)
    item <- sub(".*/([^/]*?)\\..*", "\\1", url)
    ext <- sub("^.*\\.", "", url)
  } else {
    dir <- item <- ext <- NULL
  }

  ret <- structure(
    list(
      scheme = scheme,
      hostname = hostname,
      port = port,
      path = url,
      file = list(
        dir = dir,
        file = item,
        ext = ext
      ),
      query = query,
      params = params,
      fragment = fragment,
      username = username,
      password = password
    ),
    class = c("pathr", "character")
  )

  return(ret)
}

#' @export
#' @rdname parse_url
build_url <- function(url) {
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
    scheme,
    "://",
    url$username,
    if (!is.null(url$password)) {
      ":"
    },
    url$password,
    if (!is.null(url$username)) {
      "@"
    },
    hostname,
    port,
    "/",
    path,
    params,
    query,
    if (!is.null(url$fragment)) {
      "#"
    },
    url$fragment
  )
}
