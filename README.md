
<!-- README.md is generated from README.Rmd. Please edit that file -->

``` r
usethis::use_readme_rmd()
usethis::use_description()
usethis::use_package("sf")
usethis::use_package("osmextract", type = "Suggests")
usethis::use_package("zonebuilder", type = "Suggests")
devtools::build_readme()
```

# sfrouting

<!-- badges: start -->

<!-- badges: end -->

The goal of sfrouting is to enable people to generate routes for
reproducible research. The package provides an interface between
{sfnetworks} and {cppRouting} R packages, taking part of its name from
each package: the package takes `sf` and `sfnetworks` objects as inputs,
uses routing packages (and functions in this package TBC), and outputs
`sf` objects.

A design principle is for `sf` to be the *only* package installed by
default when you install this package. You will be asked to install
additional packages when needed.

## Installation

You can install the development version of sfrouting from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Robinlovelace/sfrouting")
```

## Example

Let’s do some routing within a city of your choice. Change the name of
the city and `max_circle_id` and `segment_ids` objects in the code chunk
below to test the package for yourself elsewhere.

``` r
# library(sfrouting)
devtools::load_all()
#> ℹ Loading sfrouting
library(sf)
#> Warning: package 'sf' was built under R version 4.3.3
#> Linking to GEOS 3.11.2, GDAL 3.8.2, PROJ 9.3.1; sf_use_s2() is TRUE
library(tidyverse)
#> Warning: package 'tidyr' was built under R version 4.3.3
#> Warning: package 'readr' was built under R version 4.3.3
#> Warning: package 'purrr' was built under R version 4.3.3
#> Warning: package 'dplyr' was built under R version 4.3.3
#> Warning: package 'stringr' was built under R version 4.3.3
#> Warning: package 'lubridate' was built under R version 4.3.3
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.5.2     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
#> ✔ purrr     1.0.4     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
library(sfnetworks)
#> Warning: package 'sfnetworks' was built under R version 4.3.3
# Get study area boundar
zones_leeds = zonebuilder::zb_zone("Leeds")
#> Loading required namespace: tmaptools
tmap::tmap_mode("view")
#> ℹ tmap mode set to "view".
# zonebuilder::zb_plot(zones_leeds)
max_circle_id = 2 # max diameter of study area
segment_ids = c(0:2, 10:12) # 0:12 for all segments
zones = zones_leeds |> 
  dplyr::select(-centroid) |> 
  dplyr::filter(circle_id <= 2 & segment_id %in% segment_ids)
# plot(zones)
# mapview::mapview(zones)
area = sf::st_union(zones)
# plot(area)
osm_data = osmactive::get_travel_network(
  place = area,
  boundary = area,
  boundary_type = "clipsrc"
)
#> The input place was matched with West Yorkshire. 
#> Downloading the OSM extract:
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   4%  |                                                                              |===                                                                   |   5%  |                                                                              |====                                                                  |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |=====                                                                 |   8%  |                                                                              |======                                                                |   8%  |                                                                              |======                                                                |   9%  |                                                                              |=======                                                               |   9%  |                                                                              |=======                                                               |  10%  |                                                                              |=======                                                               |  11%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |============                                                          |  18%  |                                                                              |=============                                                         |  18%  |                                                                              |=============                                                         |  19%  |                                                                              |==============                                                        |  19%  |                                                                              |==============                                                        |  20%  |                                                                              |==============                                                        |  21%  |                                                                              |===============                                                       |  21%  |                                                                              |===============                                                       |  22%  |                                                                              |================                                                      |  22%  |                                                                              |================                                                      |  23%  |                                                                              |================                                                      |  24%  |                                                                              |=================                                                     |  24%  |                                                                              |=================                                                     |  25%  |                                                                              |==================                                                    |  25%  |                                                                              |==================                                                    |  26%  |                                                                              |===================                                                   |  27%  |                                                                              |===================                                                   |  28%  |                                                                              |====================                                                  |  28%  |                                                                              |====================                                                  |  29%  |                                                                              |=====================                                                 |  29%  |                                                                              |=====================                                                 |  30%  |                                                                              |=====================                                                 |  31%  |                                                                              |======================                                                |  31%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |=======================                                               |  34%  |                                                                              |========================                                              |  34%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |==========================                                            |  36%  |                                                                              |==========================                                            |  37%  |                                                                              |==========================                                            |  38%  |                                                                              |===========================                                           |  38%  |                                                                              |===========================                                           |  39%  |                                                                              |============================                                          |  39%  |                                                                              |============================                                          |  40%  |                                                                              |============================                                          |  41%  |                                                                              |=============================                                         |  41%  |                                                                              |=============================                                         |  42%  |                                                                              |==============================                                        |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |==============================                                        |  44%  |                                                                              |===============================                                       |  44%  |                                                                              |===============================                                       |  45%  |                                                                              |================================                                      |  45%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |=================================                                     |  48%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |===================================                                   |  49%  |                                                                              |===================================                                   |  50%  |                                                                              |===================================                                   |  51%  |                                                                              |====================================                                  |  51%  |                                                                              |====================================                                  |  52%  |                                                                              |=====================================                                 |  52%  |                                                                              |=====================================                                 |  53%  |                                                                              |=====================================                                 |  54%  |                                                                              |======================================                                |  54%  |                                                                              |======================================                                |  55%  |                                                                              |=======================================                               |  55%  |                                                                              |=======================================                               |  56%  |                                                                              |========================================                              |  57%  |                                                                              |========================================                              |  58%  |                                                                              |=========================================                             |  58%  |                                                                              |=========================================                             |  59%  |                                                                              |==========================================                            |  59%  |                                                                              |==========================================                            |  60%  |                                                                              |==========================================                            |  61%  |                                                                              |===========================================                           |  61%  |                                                                              |===========================================                           |  62%  |                                                                              |============================================                          |  62%  |                                                                              |============================================                          |  63%  |                                                                              |=============================================                         |  64%  |                                                                              |=============================================                         |  65%  |                                                                              |==============================================                        |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |===============================================                       |  66%  |                                                                              |===============================================                       |  67%  |                                                                              |===============================================                       |  68%  |                                                                              |================================================                      |  68%  |                                                                              |================================================                      |  69%  |                                                                              |=================================================                     |  69%  |                                                                              |=================================================                     |  70%  |                                                                              |==================================================                    |  71%  |                                                                              |==================================================                    |  72%  |                                                                              |===================================================                   |  72%  |                                                                              |===================================================                   |  73%  |                                                                              |===================================================                   |  74%  |                                                                              |====================================================                  |  74%  |                                                                              |====================================================                  |  75%  |                                                                              |=====================================================                 |  75%  |                                                                              |=====================================================                 |  76%  |                                                                              |======================================================                |  77%  |                                                                              |======================================================                |  78%  |                                                                              |=======================================================               |  78%  |                                                                              |=======================================================               |  79%  |                                                                              |========================================================              |  79%  |                                                                              |========================================================              |  80%  |                                                                              |=========================================================             |  81%  |                                                                              |=========================================================             |  82%  |                                                                              |==========================================================            |  82%  |                                                                              |==========================================================            |  83%  |                                                                              |===========================================================           |  84%  |                                                                              |===========================================================           |  85%  |                                                                              |============================================================          |  85%  |                                                                              |============================================================          |  86%  |                                                                              |=============================================================         |  87%  |                                                                              |=============================================================         |  88%  |                                                                              |==============================================================        |  88%  |                                                                              |==============================================================        |  89%  |                                                                              |===============================================================       |  89%  |                                                                              |===============================================================       |  90%  |                                                                              |===============================================================       |  91%  |                                                                              |================================================================      |  91%  |                                                                              |================================================================      |  92%  |                                                                              |=================================================================     |  92%  |                                                                              |=================================================================     |  93%  |                                                                              |==================================================================    |  94%  |                                                                              |==================================================================    |  95%  |                                                                              |===================================================================   |  95%  |                                                                              |===================================================================   |  96%  |                                                                              |====================================================================  |  96%  |                                                                              |====================================================================  |  97%  |                                                                              |====================================================================  |  98%  |                                                                              |===================================================================== |  98%  |                                                                              |===================================================================== |  99%  |                                                                              |======================================================================| 100%
#> File downloaded!
#> Starting with the vectortranslate operations on the input file!
#> 0...10...20...30...40...50...60...70...80...90...100 - done.
#> Warning in CPL_gdalvectortranslate(source, destination, options, oo, doo, :
#> GDAL Message 1: A geometry of type MULTILINESTRING is inserted into layer lines
#> of geometry type LINESTRING, which is not normally allowed by the GeoPackage
#> specification, but the driver will however do it. To create a conformant
#> GeoPackage, if using ogr2ogr, the -nlt option can be used to override the layer
#> geometry type. This warning will no longer be emitted for this combination of
#> layer and feature geometry type.
#> Finished the vectortranslate operations on the input file!
#> Reading layer `lines' from data source 
#>   `C:\Users\georl\AppData\Local\Temp\RtmpGQs0v9\geofabrik_west-yorkshire-latest.gpkg' 
#>   using driver `GPKG'
#> Simple feature collection with 10143 features and 67 fields
#> Geometry type: MULTILINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: -1.587293 ymin: 53.78843 xmax: -1.500002 ymax: 53.82436
#> Geodetic CRS:  WGS 84
#> Matched these columns: lanes_psvlanes_buslanes_bus_conditionallanes_bus_backwardlanes_bus_forwardlanes_psv_backwardlanes_psv_forwardlanes_psv_conditionallanes_psv_conditional_backwardlanes_psv_conditional_forwardlanes_psv_conditional_both_wayslanes_psv_both_ways
osm_drive = osmactive::get_driving_network(osm_data)
osm_drive = sf::st_cast(osm_drive, "LINESTRING")
#> Warning in st_cast.sf(osm_drive, "LINESTRING"): repeating attributes for all
#> sub-geometries for which they may not be constant
plot(osm_drive["highway"])
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
sfn = sfnetworks::as_sfnetwork(osm_drive, directed = FALSE)
nodes_sf = st_as_sf(sfn)
edges_sf = sf::st_as_sf(sfn, "edges")
edges_sf$length = sf::st_length(edges_sf) |> 
  as.numeric()
nodes_coords = sf::st_coordinates(nodes_sf)
nodes = data.frame(
  ID = seq(nrow(nodes_sf)),
  X = nodes_coords[, 1],
  Y = nodes_coords[, 2]
)
head(nodes)
#>   ID         X        Y
#> 1  1 -1.557540 53.79996
#> 2  2 -1.557453 53.80107
#> 3  3 -1.558721 53.80308
#> 4  4 -1.558404 53.80368
#> 5  5 -1.573466 53.81692
#> 6  6 -1.571726 53.81662
edges = data.frame(
  from = edges_sf$from,
  to = edges_sf$to,
  weight = edges_sf$length
)
head(edges)
#>   from to    weight
#> 1    1  2 123.73172
#> 2    3  4  69.67965
#> 3    5  6 119.14023
#> 4    7  8 126.62139
#> 5    9 10 165.67475
#> 6   11 12 148.85676
```

``` r
graph = cppRouting::makegraph(edges, nodes, directed = FALSE)
```

Let’s calculate a route from Scott Hall Road to University Road:

``` r
origin_road = sfn |> 
  activate("edges")
```
