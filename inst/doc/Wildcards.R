## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----defs---------------------------------------------------------------------
library(csquares, warn.conflicts = FALSE)

csq <- as_csquares("1000:1|1000:2|1000:3|1000:4")

print(csq)

## ----from_wild----------------------------------------------------------------
csqw <- as_csquares("1000:*")

print(csqw)

identical(csq, csqw)

## ----expand-------------------------------------------------------------------
expand_wildcards("1000:*") |>
  as.character()

## ----filter-------------------------------------------------------------------
library(dplyr, warn.conflicts = FALSE)
library(sf, warn.conflicts = FALSE)

orca_sf <-
  orca |>
  as_csquares(csquares = "csquares") |>
  st_as_sf()

plot(orca_sf["orcinus_orca"])

## Note that the first number in the csquares code (1)
## represents the North East quadrant
## The remainder of the code consists of wildcards.
plot(
  orca_sf |>
    filter(
      in_csquares(csquares, "1***:*")
    ) |>
    drop_csquares() |>
    select("orcinus_orca")
)

## ----mode---------------------------------------------------------------------
csq_example <- as_csquares(c("1000:100|1000:111|1000:206|1000:207", "1000:122"))

## ----mode_any-----------------------------------------------------------------
in_csquares(csq_example, "1000:1**")

## ----mode_all-----------------------------------------------------------------
in_csquares(csq_example, "1000:1**", mode = "all")

## ----not_so_strict------------------------------------------------------------
in_csquares(csq_example, "1000:*")

## ----strict-------------------------------------------------------------------
in_csquares(csq_example, "1000:*", strict = TRUE)

