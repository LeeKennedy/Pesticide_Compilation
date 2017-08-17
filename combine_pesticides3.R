# Clean Up environment ---------------------------------------------------
rm(list=ls())

# Packages ---------------------------------------------------------------
library(readxl)
library(readr)
library(dplyr)
library(tidyr)

# Functions --------------------------------------------------------------
# Used to substitute pesticide names from the vocab dictionary to give one common name.

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

# Possible pesticide list ------------------------------------------------
data_list <- c("PEST08", 
               "PEST06", 
               "PEST08C6", 
               "PEST00",
               "PEST07",
               "Proposed_C6",
               "Trevor",
               "Vietnam", 
               "Indonesia", 
               "Vietnam_Sub", 
               "AAA", 
               "Coles", 
               "NMI", 
               "ALS", 
               "FSANZ", 
               "Agrifood", 
               "Freshtest_2016",
               "Freshtest_2017",
               "FSANZ_Nuts",
               "FSANZ_COFFEE")

# Select those you wish to compare ---------------------------------------
data_list <- data_list[c(17:18)]

# Create a long list of pesticide sets of interest------------------------
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
  
# Add dummy marker -------------------------------------------------------
Combined$marker <- "X"

# remove NAs -------------------------------------------------------------
Combined <- na.omit(Combined)

# Save interim data ------------------------------------------------------
# Can use Pivot Table at this pont but names have not been standardised---
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
# Cycles through vocab list, comparing to pesticide name------------------

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
    } else if (n==8) {
      check_list <- c(list[1,2],list[1,3],list[1,4],list[1,5], list[1,6], list[1,7], list[1,8])
    }
    
    PestName[i] <- mgsub(check_list, pref, PestName[i])  
  }
}
  
PestName2 <- t(data.frame(PestName, stringsAsFactors = FALSE))

Combined$Name <- PestName2[1:m]

# Exporting Data -------------------------------------------------------

Wide_Data <- spread(Combined, Screen, marker, fill="")

write_csv(Wide_Data, "DTS_full_set_11052017.csv")
