#Generate EDN from R data structures.
#Much code here shamelessly modified from the rjson package.


#convert a data frame to a list of lists.
df_to_list <- function(ds) apply(ds, 1, function(x) as.list(x))

map_kv_separator <- " "
map_item_separator <- " "
vector_item_separator <- " "
key_prefix <- ":"
key_suffix <- ""

toEDN <- function(x){
  
  #convert factors to characters
  if( is.factor( x ) == TRUE ) {
    tmp_names <- names( x )
    x = as.character( x )
    names( x ) <- tmp_names
  }

  #convert data frames to list of lists
  if( is.data.frame(x) ) {
    x <- df_to_list( x )
  }

  #convert quoted things to keywords
  if( is.name(x) ) {
    return( paste(":", x, sep="") )
  }
  
  if( !is.vector(x) && !is.null(x) && !is.list(x) ) {
    x <- as.list( x )
    warning("EDN only supports vectors and lists - But I'll try anyways")
  }

  if( is.null(x) )
    return( "null" )

  #treat named vectors as lists
  if( is.null( names( x ) ) == FALSE ) {
    x <- as.list( x )
  }

  #named lists only
  if( is.list(x) && !is.null(names(x)) ) {
    if( any(duplicated(names(x))) )
      stop( "An EDN list must have unique names" );
    str = "{"
    first_elem = TRUE
    for( n in names(x) ) {
      if( first_elem )
        first_elem = FALSE
      else
        str = paste(str, map_item_separator, sep="")
      str = paste(str, key_prefix, n, key_suffix, map_kv_separator, toEDN(x[[n]]), sep="")
    }
    str = paste( str, "}", sep="" )
    return( str )
  }

  #treat lists without names as a vector
  if( length(x) != 1 || is.list(x) ) {
    if( !is.null(names(x)) )
      return( toEDN(as.list(x)) ) #vector with names - treat as vector
    str = "["
    first_elem = TRUE
    for( val in x ) {
      if( first_elem )
        first_elem = FALSE
      else
        str = paste(str, vector_item_separator, sep="")
      str = paste(str, toEDN(val), sep="")
    }
    str = paste( str, "]", sep="" )
    return( str )
  }

  if( is.nan(x) )
    return( "\"NaN\"" )

  if( is.na(x) )
    return( "\"NA\"" )

  if( is.infinite(x) )
    return( ifelse( x == Inf, "\"Inf\"", "\"-Inf\"" ) )

  if( is.logical(x) )
    return( ifelse(x, "true", "false") )

  if( is.character(x) )
    return( gsub("\\/", "\\\\/", deparse(x)) )

  if( is.numeric(x) )
    return( as.character(x) )

  stop( "shouldnt make it here - unhandled type not caught" )
}
