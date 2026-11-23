## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  out.width = 300,
  fig.width = 5,
  comment = "#>"
)

## ----setup, message=FALSE, warning=FALSE--------------------------------------
library(csquares)
library(sf)
library(dplyr)

## ----define-points------------------------------------------------------------
pts <-
  expand.grid(
    x = seq(-0.11, 0.11, by = 0.01),
    y = seq(-0.11, 0.11, by = 0.01)
  ) |>
  sf::st_as_sf(coords = c("x", "y"), crs = 4326)

## ----to-csquares--------------------------------------------------------------
csq <- as_csquares(pts, resolution = 0.05)
plot(csq, axes = TRUE)

## ----summarise----------------------------------------------------------------
csq_agg <- summarise(csq |> group_by(csquares), count = n())
plot(csq_agg["count"], axes = TRUE)

