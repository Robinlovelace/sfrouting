#' Get a route from an sfnetwork
#'
#' This function calculates a route between an origin and a destination node
#' in an `sfnetwork` object.
#'
#' @param sfn An `sfnetwork` object.
#' @param from The node ID of the origin.
#' @param to The node ID of the destination.
#'
#' @return An `sf` object representing the route edges.
#' @export
#' @examples
#' \dontrun{
#' if (requireNamespace("sfnetworks", quietly = TRUE) && requireNamespace("sf", quietly = TRUE)) {
#'   data(sr_data_osm)
#'   sfn = sfnetworks::as_sfnetwork(sr_data_osm)
#'   # Ensure nodes have IDs
#'   sfn = sfn |>
#'     tidygraph::activate("nodes") |>
#'     dplyr::mutate(ID = dplyr::row_number())
#'   from_node = 1
#'   to_node = 100
#'   route_sf = sr_route(sfn, from = from_node, to = to_node)
#'   plot(route_sf)
#' }
#' }
sr_route = function(sfn, from, to) {
  if (!"ID" %in% names(sfn |> tidygraph::activate("nodes") |> as.data.frame())) {
    stop("Nodes in the sfnetwork must have an 'ID' column.", call. = FALSE)
  }
  graph = sfn_to_cpprouting(sfn)
  route_nodes_ids = cppRouting::get_path_pair(
    Graph = graph,
    from = from,
    to = to
  )
  ID = NULL # To avoid R CMD check note
  route_sfn = sfn |>
    tidygraph::activate("nodes") |>
    dplyr::filter(ID %in% route_nodes_ids[[1]])
  route_edges = route_sfn |>
    tidygraph::activate("edges") |>
    sf::st_as_sf()
  route_edges
}
