# Clean Up environment ---------------------------------------------------
rm(list=ls())

# Packages ---------------------------------------------------------------
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

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

Combined <- rbind(PEST06, PEST08, PEST08C6, Vietnam, Indonesia, VN_Sub, AAA, Coles, NMI, ALS, FSANZ, Freshtest)

Combined$marker <- "X"

Combined <- na.omit(Combined)

#### Vocabulary Input -----------------------------
vocab <- read_excel("~/Documents/GitHub/Pesticide_Compilation/vocab.xlsx")
v <- nrow(vocab)

# Data Cleaning ----------------------------------------------------------

m <- nrow(Combined)

for (i in 1:m) {

  for (j in 1:v) {

    
    pref <- as.list(vocab[j,1])
  
    list <- (vocab[j,])

    list <- list[colSums(!is.na(list)) > 0]

    n <- ncol(list)
    
    if (n==2){
      check_list <- list[1,2]
    } else if (n==3) {
      check_list <- paste(list[1,2],"|",list[1,3], sep="") 
    } else if (n==4) {
      check_list <- paste(list[1,2],"|",list[1,3],"|",list[1,4], sep="")
    } else if (n==5) {
      check_list <- paste(list[1,2],"|",list[1,3],"|",list[1,4],"|",list[1,5], sep="")
    }
  
    Combined$Name[i] <- sub(check_list, pref, Combined$Name[i])  
  }
}
  

# Exporting Data -------------------------------------------------------

Wide_Data <- spread(Combined, Screen, marker, fill="")

write_csv(Wide_Data, "pest_set.csv")
