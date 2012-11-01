url <- "http://c2po.keminglabs.com"

#' @import httr

charname <- function(x){
  if(is.character(x)){
    eval(call("as.name", x))
  }else{
    x 
  }
}

tidy_spec <- function(spec){
  spec$geom <- charname(spec$geom)
  spec$mapping <- lapply(spec$mapping, charname)
  return(spec)
}

#' Compile a C2PO spec by sending to public server
#'
#' @param spec A c2po plot specification
#' @export
c2po <- function(spec){
  POST(url, body = list("c2po" = toEDN(tidy_spec(spec))))
}



