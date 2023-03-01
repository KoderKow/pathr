parse_query <- function(query) {
  params <- vapply(
    X = strsplit(query, "&")[[1]],
    FUN = str_split_fixed,
    pattern = "=",
    n = 2,
    FUN.VALUE = character(2)
  )

  values <- as.list(curl::curl_unescape(params[2, ]))

  names(values) <- curl::curl_unescape(params[1, ])

  return(values)
}
