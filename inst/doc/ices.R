## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
ggplot2::theme_set(ggplot2::theme_light())

## ----setup, message = FALSE, warning = FALSE----------------------------------
library(csquares)

## ----ices_to_csquares, warning=FALSE, message=FALSE---------------------------
library(sf)
my_ices_codes <-
  c("31F21", "31F22", "31F23", "31F24", "31F25", "31F26", "31F27", "31F28", "31F29",
      "32F2", "33F2", "34F2", "35F2",
      "31F3", "32F3", "33F3", "34F3", "35F3",
      "31F4", "32F4", "33F4", "34F4", "35F4")

my_ices_rects <- ices_rectangles(my_ices_codes)

## ----ices_plot, warning=FALSE, message=FALSE, echo=FALSE----------------------
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
rnaturalearth::check_rnaturalearthdata()
cur_s2 <- sf_use_s2()
sf_use_s2(FALSE)
world <- ne_countries(scale = "medium", returnclass = "sf") |>
  st_crop(my_ices_rects) |>
  suppressWarnings()
sf_use_s2(cur_s2)

ggplot(my_ices_rects) +
  geom_sf(data = world, fill = "yellowgreen") +
  geom_sf(fill = "transparent") +
  geom_sf_text(aes(label = ICES), size = ifelse(my_ices_rects$subrect, 2, 4)) +
  labs(x = NULL, y = NULL)

## ----ices_to_csq, message=FALSE-----------------------------------------------
library(dplyr)

ices_csq <-
  ## Note that ICES subrects return empty csquares
  ices_to_csquares(my_ices_codes) |>
  ## Remove empty csquares as those can not be converted into geometries
  filter(!is.na(csquares)) |>
  ## add geometries
  st_as_sf()

## ----ices_plot2, warning=FALSE, message=FALSE, echo=FALSE---------------------
ggplot(ices_csq) +
  geom_sf(data = world, fill = "yellowgreen") +
  geom_sf(fill = "transparent") +
  geom_sf_text(aes(label = gsub("[|]", "\n", as.character(csquares))), angle = 30, size = 3) +
  labs(x = NULL, y = NULL)


## ----ices_fom_csq, message=FALSE----------------------------------------------
ices_from_csquares(ices_csq)

