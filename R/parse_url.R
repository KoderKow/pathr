parse_url <- function (url) {
  if (is_pathr(url)) {
    return(url)
  }

  url <- url_original
  url_original <- url

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
    dirs <- sub("/[^/]*$", "", url)
    item <- sub(".*/", "", url)
  } else {
    dirs <- NULL
    item <- NULL
  }

  ret <- structure(
    list(
      scheme = scheme,
      hostname = hostname,
      port = port,
      path = url,
      file = list(
        dirs = dirs,
        file = item
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
