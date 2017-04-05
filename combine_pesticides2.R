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
PEST06 <- read_excel("~/Documents/GitHub/pest_data/PEST06.xlsx", 
                               sheet = "List")

#read_excel("W:/lab/CHEMISTRY/Technical Support Projects/Pesticide Compilation Data/data/PEST06.xlsx", 
#           sheet = "List")

PEST08 <- read_excel("~/Documents/GitHub/pest_data/PEST08.xlsx", 
                     sheet = "List")

PEST08C6 <- read_excel("~/Documents/GitHub/pest_data/PEST08C6.xlsx", 
                     sheet = "List")

Vietnam <- read_excel("~/Documents/GitHub/pest_data/Vietnam.xlsx", 
                       sheet = "List")

Indonesia <- read_excel("~/Documents/GitHub/pest_data/Indonesia.xlsx", 
                      sheet = "List")

VN_Sub <- read_excel("~/Documents/GitHub/pest_data/Vietnam_Sub.xlsx", 
                     sheet = "List")

AAA <- read_excel("~/Documents/GitHub/pest_data/AAA.xlsx", 
                  sheet = "List")

Coles <- read_excel("~/Documents/GitHub/pest_data/Coles.xlsx", 
                    sheet = "List")

NMI <- read_excel("~/Documents/GitHub/pest_data/NMI.xlsx", 
                    sheet = "List")

ALS <- read_excel("~/Documents/GitHub/pest_data/ALS.xlsx", 
                  sheet = "List")

FSANZ <- read_excel("~/Documents/GitHub/pest_data/FSANZ.xlsx", 
                  sheet = "List")

Agrifood <- read_excel("~/Documents/GitHub/pest_data/Agrifood.xlsx", 
                    sheet = "List")

Freshtest <- read_excel("~/Documents/GitHub/pest_data/Freshtest.xlsx", 
                       sheet = "List")

Nuts <- read_excel("~/Documents/GitHub/pest_data/FSANZ_Nuts.xlsx", 
                    sheet = "List")

#Combined <- rbind(PEST06, PEST08, PEST08C6, Vietnam, Indonesia, VN_Sub, AAA, Coles, NMI, ALS, FSANZ, Freshtest)

#Combined <- rbind(PEST06, PEST08, PEST08C6, Vietnam, Indonesia, VN_Sub)

Combined <- rbind(PEST06, PEST08, PEST08C6, AAA, Coles, NMI, ALS, Freshtest)

Combined$marker <- "X"

Combined <- na.omit(Combined)

write.csv(Combined, "combined_raw.csv")

#### Vocabulary Input -----------------------------
vocab <- read_excel("~/Documents/GitHub/Pesticide_Compilation/vocab.xlsx")
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
    }
    
    PestName[i] <- mgsub(check_list, pref, PestName[i])  
  }
}
  
PestName2 <- t(data.frame(PestName, stringsAsFactors = FALSE))

Combined$Name <- PestName2[1:m]

# Exporting Data -------------------------------------------------------

Wide_Data <- spread(Combined, Screen, marker, fill="")

Wide_Data <- Wide_Data[,c(1,9,10,8,7,2:6)]

write_csv(Wide_Data, "full_pest_set.csv")
