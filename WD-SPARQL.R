# A function for getting a dataframe from wikidata

# Use https://query.wikidata.org/ to create query
# and parse it in this function

SPARQL <- function(url = NULL) {
  
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(dplyr, httr)
  
  if(!is.null(url)){
    df = httr::GET(url) %>% 
      httr::content(as = "parsed", type = "application/json") %>% 
      .[["results"]] %>% .[["bindings"]] %>% 
      base::lapply(., data.frame, stringsAsFactors = FALSE) %>% 
      dplyr::bind_rows() %>% 
      dplyr::as_tibble() %>% 
      dplyr::select(contains("value")) %>% 
      dplyr::rename_with(~gsub(".value","", .x))
  } else {
    df = dplyr::tibble()
  }
  
  return(df)
}
