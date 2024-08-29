## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(csquares)

## ----csquares-schematic, echo=FALSE, warning=FALSE, result='asis'-------------
library(DiagrammeR)
library(DiagrammeRsvg)
library(xml2)
grViz(
"
digraph 'Csquares schematic' {
layout = 'dot';
splines = spline;
node [fontname = Helvetica shape = box style = filled fillcolor = white class = 'csquare_nodes'];

csquares   [label = 'csquares' fillcolor = palegreen];
strucstrs  [label = '{<stars>stars::stars|<starscsq>csquares}' URL='#using-spatiotemporal-arrays-stars' shape = record];

subgraph cluster_dfc {
style = filled;
fontname = Helvetica;
fillcolor = lightcyan;
label = 'data.frame csquare';
strucdf    [label = '{<df>data.frame|<dfcsq>csquares}' URL='#using-data-frames' shape = record];
strucsf    [label = '{<sf>sf::sf|<sfcsq>csquares}' URL='#using-simple-features-sf' shape = record];
}
subgraph cluster_char {
style = filled;
fontname = Helvetica;
fillcolor = lightcyan;
label = 'character csquare';
strucchar  [label = '{<character>character|<charcsq>csquares}' URL='#using-characters' shape = record];
vctr       [label = 'vctrs::vctrs_vctr'];
}

vctr -> strucchar:character
strucchar:charcsq  -> csquares;
strucdf:dfcsq      -> csquares;
strucsf:sfcsq      -> csquares;
strucstrs:starscsq -> csquares;
strucdf:df -> strucsf:sf;
strucchar:charcsq -> strucdf:dfcsq;
strucchar:charcsq -> strucsf:sfcsq;
}
") |>
  export_svg() |>
  read_xml() |>
  as.character() |>
  ## By rendering it as html instead of a Graphviz object
  ## we save a huge chunk of javascript that we don't need (~600 kB)
  ## the result is still the same
  htmltools::HTML()

## ----create-csquares----------------------------------------------------------
csquares_char <- as_csquares(c("1000", "3000", "5000", "7000"))

## ----csquares-data.frame------------------------------------------------------
csquares_df <- as.data.frame(csquares_char)

class(csquares_df)

## ----csquares-obj-mut, message=FALSE------------------------------------------
library(dplyr)

csquares_df <-
  csquares_df |>
  mutate(dummy = 1:4)

## ----plain-df-----------------------------------------------------------------
orca_csq <- as_csquares(orca, csquares = "csquares")

## ----csquares-sf, message=FALSE-----------------------------------------------
library(sf)
csquares_sf <- st_as_sf(csquares_df)

## ----csquares-stars, message=FALSE--------------------------------------------
library(stars)

csquares_stars <- new_csquares(csquares_sf, resolution = 10L)

## ----csquares-stars-fill------------------------------------------------------
## create an empty column:
csquares_stars[["dummy"]] <- NA
csquares_stars[["dummy"]] <-
  csquares_df[["dummy"]] [
    match(csquares_stars[["csquares"]], csquares_df[["csquares"]])
  ]

## ----csquares-stars-join------------------------------------------------------
csquares_stars <-
  left_join(csquares_stars,
            data.frame(csquares = "1000", foo = "bar"),
            by = "csquares")

## ----validate-----------------------------------------------------------------
## Let's create a fake csquares object with a code that is merely impossible:
fake_csquares <- "1099"
class(fake_csquares) <- "csquares"

## Of course this isn't valid
validate_csquares(fake_csquares)

## This one is:
validate_csquares(csquares_char)

