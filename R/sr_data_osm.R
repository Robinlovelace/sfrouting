#' Sample road network data for Leeds from OpenStreetMap
#'
#' A dataset containing road network data for Leeds, UK, extracted from
#' OpenStreetMap using the `osmactive` package. The data has been
#' processed for routing applications. It has been filtered to remove columns
#' with a high proportion of missing values (more than 90%) and the geometry
#' has been cast to `LINESTRING`.
#'
#' @format An `sf` data frame with road segments:
#' \describe{
#'   \item{geometry}{`LINESTRING` geometry of the road segment.}
#'   \item{highway}{The type of highway (e.g., 'residential', 'primary').}
#'   \item{...}{Other columns from OpenStreetMap with less than 90% missing values.}
#' }
#' @source <https://www.openstreetmap.org/>
"sr_data_osm"
