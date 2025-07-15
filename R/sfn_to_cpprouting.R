#' Convert an sfnetwork object to a cppRouting graph
#'
#' This function takes an `sfnetwork` object and converts it into a graph
#' format that is usable by the `cppRouting` package.
#'
#' @param sfn An `sfnetwork` object.
#' @param directed Logical, whether the graph should be directed. Defaults to `FALSE`.
#' @return A `cppRouting` graph object.
#' @export
#' @examples
#' \dontrun{
#' if (requireNamespace("sfnetworks", quietly = TRUE) && requireNamespace("sf", quietly = TRUE)) {
#'   data(sr_data_osm)
#'   sfn = sfnetworks::as_sfnetwork(sr_data_osm)
#'   graph = sfn_to_cpprouting(sfn)
#' }
#' }
sfn_to_cpprouting = function(sfn, directed = FALSE) {
 
  # Ensure nodes have a unique ID
  sfn = sfn |>
    tidygraph::activate("nodes") |>
    dplyr::mutate(ID = dplyr::row_number())
  
  nodes_sf = sf::st_as_sf(sfn, "nodes")
  edges_sf = sf::st_as_sf(sfn, "edges")
  
  # Ensure edges have a weight attribute, use length if not present
  if (!"weight" %in% names(edges_sf)) {
    edges_sf$weight = sf::st_length(edges_sf)
  }
  
  nodes_coords = sf::st_coordinates(nodes_sf)
  nodes = data.frame(
    ID = nodes_sf$ID,
    X = nodes_coords[, 1],
    Y = nodes_coords[, 2]
  )
  
  edges = data.frame(
    from = edges_sf$from,
    to = edges_sf$to,
    weight = edges_sf$weight
  )
  
  cppRouting::makegraph(edges, nodes, directed = directed)
}
