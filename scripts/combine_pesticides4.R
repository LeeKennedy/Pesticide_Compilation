# A cut back combinepesticides2.R

# Clean Up environment ---------------------------------------------------
rm(list=ls())

# Packages ---------------------------------------------------------------
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

# Functions --------------------------------------------------------------
mgsub <- function(pattern, replacement, x, ...) {
  n=length(pattern)
  result = x
  for (i in 1:n) {
    result[grep(pattern[i], x, ignore.case = FALSE, ...)] = replacement[i]
  }
  return(result)
}

# Data Input -------------------------------------------------------------
PEST06 <- read_excel("~/Documents/GitHub/Pesticide_Compilation/data/pest_data/PEST06.xlsx", 
                               sheet = "List")

PEST08 <- read_excel("~/Documents/GitHub/Pesticide_Compilation/data/pest_data/PEST08.xlsx", 
                     sheet = "List")

OH_Conv <- read_excel("~/Documents/GitHub/Pesticide_Compilation/data/pest_data/OH_Conventional.xlsx", 
                     sheet = "List")

OH_Super <- read_excel("~/Documents/GitHub/Pesticide_Compilation/data/pest_data/OH_Supermarket.xlsx", 
                     sheet = "List")

Combined <- rbind(PEST06, PEST08, OH_Conv, OH_Super)

Combined$marker <- "X"

Combined <- na.omit(Combined)

write.csv(Combined, "combined_OH_raw.csv")

#### Vocabulary Input -----------------------------
vocab <- read_excel("~/Documents/GitHub/Pesticide_Compilation/data/vocab.xlsx")
vocab <- vocab[,-1]
v <- nrow(vocab)

# Data Cleaning ----------------------------------------------------------

PestName <- Combined$Name


m <- nrow(Combined)

for (i in 1:m) {

  for (j in 1:v) {
    
    list <- (vocab[j,])

    list <- list[colSums(!is.na(list)) > 0]
    
    pref_rep <- length(list)-1
    
    pref <- rep((vocab[j,1]), pref_rep)

    n <- ncol(list)
    
    if (n==2){
      check_list <- list[1,2]
    } else if (n==3) {
      check_list <- c(list[1,2],list[1,3]) 
    } else if (n==4) {
      check_list <- c(list[1,2],list[1,3],list[1,4])
    } else if (n==5) {
      check_list <- c(list[1,2],list[1,3],list[1,4],list[1,5])
    } else if (n==6) {
      check_list <- c(list[1,2],list[1,3],list[1,4],list[1,5], list[1,6])
    } else if (n==7) {
      check_list <- c(list[1,2],list[1,3],list[1,4],list[1,5], list[1,6], list[1,7])
    }
    
    PestName[i] <- mgsub(check_list, pref, PestName[i])  
  }
}
  
PestName2 <- t(data.frame(PestName, stringsAsFactors = FALSE))

Combined$Name <- PestName2[1:m]
write.csv(Combined, "combined_temp.csv")

# Exporting Data -------------------------------------------------------

Wide_Data <- spread(Combined, Screen, marker, fill="")

#Wide_Data <- Wide_Data[,c(1,9,10,8,7,2:6)]

write_csv(Wide_Data, "full_OH_pest_set2.csv")
