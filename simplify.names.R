#### Clean Up environment -----------------------------
rm(list=ls())

#### Packages -----------------------------
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(dts.quality)




#### Data Input -----------------------------
vocab <- read_excel("H:/GitHub Projects/Pesticide_Compilation/vocab.xlsx")

#### -----------------------------
pref <- vocab[1,1]

L <- ncol((vocab[1,]))


check_list <- paste(vocab[1,2],"|",vocab[1,3],"|",vocab[1,4],"|",vocab[1,5], sep="")


