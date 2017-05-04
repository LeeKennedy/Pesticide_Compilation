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

if("Windows" %in% Sys.info()['sysname'] == TRUE){ 
loc <- "W:/lab/CHEMISTRY/Technical Support Projects/Pesticide Compilation Data/data/"
} else { 
loc <-"~/Documents/GitHub/pest_data/"
}


data_list <- c("PEST08", 
               "PEST06", 
               "PEST08C6", 
               "PEST00",
               "Proposed_C6",
               "Vietnam", 
               "Indonesia", 
               "Vietnam_Sub", 
               "AAA", 
               "Coles", 
               "NMI", 
               "ALS", 
               "FSANZ", 
               "Agrifood", 
               "Freshtest",
               "FSANZ_Nuts" )


data_list <- data_list[c(1:5)]


dl <- length(data_list)

i=1

for (i in 1:dl) {
  
  pestx <- paste(loc, data_list[i],".xlsx", sep="")
  pestin <- read_excel(pestx, sheet = "List")
  if (i==1){
    Combined <- pestin
  } else {
    Combined <- rbind(Combined, pestin)
  }
}
  

Combined$marker <- "X"

Combined <- na.omit(Combined)

write.csv(Combined, "combined_raw.csv")

#### Vocabulary Input -----------------------------


if("Windows" %in% Sys.info()['sysname'] == TRUE){ 
  vocab <- read_excel("H:/GitHub Projects/Pesticide_Compilation/vocab.xlsx")
} else { 
  vocab <- read_excel("~/Documents/GitHub/Pesticide_Compilation/vocab.xlsx")
}


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

# Optional ordering of wide_data : adjust for included columns ---------
#Wide_Data <- Wide_Data[,c(1,9,10,8,7,2:6)]


write_csv(Wide_Data, "DTS_pest_set.csv")
