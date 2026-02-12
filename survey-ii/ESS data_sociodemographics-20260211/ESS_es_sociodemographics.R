## ----setup, include=FALSE----------------------------------------------------------------------
knitr::opts_chunk$set(echo=T, message=FALSE, warning=FALSE, knitr.purl.inline = TRUE)


## ----include=FALSE-----------------------------------------------------------------------------
library(haven)
library(tidyverse)
library(knitr)
library(gmodels)
library(ggplot2)
library(openxlsx)
library(skimr)
library(ggplot2)
library(janitor)
library(readr)
library(dplyr)
library(labelled)
library(essurvey)


## ----------------------------------------------------------------------------------------------
data_full <- read_csv("data.csv")
dim(data_full)



## ----------------------------------------------------------------------------------------------
data<- data_full |> select (essround, idno, agea, eduyrs, eisced, gndr, iscoco, isco08, hinctnt, hinctnta)


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(
    male = case_when(
      gndr == 1 ~ 1,  
      gndr == 2 ~ 0,  
      gndr == 9 ~ NA_real_,  
      TRUE ~ NA_real_  
    ),
    male = factor(male, 
                  levels = c(0, 1), 
                  labels = c("female", "male"))
  )

table(data$essround, data$male)


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(
    age = replace(agea, agea > 103, NA)
  )

summary(data$age) 


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(
    age_rec = cut(agea, breaks = c(0, 19, 29, 44, 64, 103),
                  labels = c("<20", "20-29", "30-44", "45-64", ">=65"))
  )

with(data, table(essround, age_rec))


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(years_schooling = replace(eduyrs, eduyrs > 60, NA))

summary(data$years_schooling)


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(
    educ_level = case_when(
      eisced %in% c(1, 2) ~ "Low education",
      eisced %in% c(3, 4) ~ "Secondary education",
      eisced %in% c(5, 6, 7) ~ "High education",
      eisced %in% c(0, 55, 77, 88, 99) ~ NA_character_,
      TRUE ~ NA_character_
    ) |> factor()
  )


with(data, table(essround, educ_level))


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(hincome = case_when(
    essround <= 3 ~ hinctnt,
    essround >= 4 ~ hinctnta,
    TRUE ~ NA_real_
  )) 


## ----------------------------------------------------------------------------------------------
with(data, table(essround, is.na(hincome)))


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(hincome = ifelse(hincome > 10, NA, hincome))

with(data, table(essround, hincome))


## ----------------------------------------------------------------------------------------------
data <- data |>
  mutate(occup = case_when(
    essround <= 5 ~ iscoco,
    essround >= 6 ~ isco08,
    TRUE ~ NA_real_
  )) 


## ----------------------------------------------------------------------------------------------
data <- data |> 
  mutate(
    occup = replace(occup, occup > 10000, NA),
    occup = cut(occup,
      breaks = c(0, 1999, 2999, 3999, 4999, 5999, 6999, 9999),
      labels = c("managers", "professionals", "technicians", 
                 "clerical", "service", "agricultural", "blue-collar")
    ))


## ----------------------------------------------------------------------------------------------
with(data, table(essround, occup))


## ----------------------------------------------------------------------------------------------
options(knitr.duplicate.label = 'allow')
purl("ESS_es_sociodemographics.Rmd", output = "ESS_es_sociodemographics.R")

