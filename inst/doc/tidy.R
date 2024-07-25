## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
ggplot2::theme_set(ggplot2::theme_light())

## ----no-tidy, warning=FALSE, message=FALSE------------------------------------
## Required libraries
library(csquares)
library(dplyr)
library(sf)
library(ggplot2)

## create a simple csquares object:
char_csq <- as_csquares(c("1000", "3000"))

## This simple objects has "character" as parent class.
## So tidyverse is out of the question here.
class(char_csq)

## ----yes-tidy-----------------------------------------------------------------
## create a csquares object with geometries:
orca_csq  <- orca |> as_csquares(csquares = "csquares")

## It inherits the class data.frame.
class(orca_csq)

## ----mutate, warning=FALSE----------------------------------------------------
orca_sum <-
  orca_csq |>
## Add geometries to the object
  st_as_sf() |>
  ## use `mutate` to create a column that contains the csquares' quadrant
  mutate(quadrant = case_match(substr(csquares |> as.character(), 1L, 1L),
                               "1" ~ "NE", "3" ~ "SE", "5" ~ "SW", "7" ~ "NW")) |>
  ## grouping by the column with logical values and summarising
  ## will reduce the number of rows to 4 (one for each quadrant)
  group_by(quadrant) |>
  summarise(realms = sum(orcinus_orca), .groups = "keep")

## Note that csquares are automatically concatted and
## geometries recalculated
ggplot(orca_sum) +
  geom_sf(aes(fill = realms)) +
  geom_sf_text(aes(label = quadrant)) +
  coord_sf() +
  labs(title = "Realm count per quadrant", x = NULL, y = NULL)

## ----show_sum-----------------------------------------------------------------
orca_sum

## ----join---------------------------------------------------------------------
df <- data.frame(foo = "bar", csquares = "3603:3")

left_join(orca_csq, df, by = "csquares") |> print(max = 30)
right_join(orca_csq, df, by = "csquares")

## ----join_extra---------------------------------------------------------------
csq <- data.frame(orcinus_orca = FALSE, csquares = "3603:3") |>
  as_csquares(csquares = "csquares")

left_join(orca_csq, csq, by = "orcinus_orca") |> print(max = 30)

