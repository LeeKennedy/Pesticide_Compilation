# Clean Up environment ---------------------------------------------------
rm(list=ls())

# Packages ---------------------------------------------------------------
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

# Data Input -------------------------------------------------------------
PEST06 <- read_excel("~/Desktop/Pesticides/data/PEST06.xlsx", 
                     sheet = "List")

#read_excel("W:/lab/CHEMISTRY/Technical Support Projects/Pesticide Compilation Data/data/PEST06.xlsx", 
#           sheet = "List")

PEST08 <- read_excel("~/Desktop/Pesticides/data/PEST08.xlsx", 
                     sheet = "List")

PEST08C6 <- read_excel("~/Desktop/Pesticides/data/PEST08C6.xlsx", 
                     sheet = "List")

Vietnam <- read_excel("~/Desktop/Pesticides/data/Vietnam.xlsx", 
                       sheet = "List")

Indonesia <- read_excel("~/Desktop/Pesticides/data/Indonesia.xlsx", 
                      sheet = "List")

VN_Sub <- read_excel("~/Desktop/Pesticides/data/Vietnam_Sub.xlsx", 
                     sheet = "List")

AAA <- read_excel("~/Desktop/Pesticides/data/AAA.xlsx", 
                  sheet = "List")

Coles <- read_excel("~/Desktop/Pesticides/data/Coles.xlsx", 
                    sheet = "List")

Combined <- rbind(PEST06, PEST08, PEST08C6, Vietnam, Indonesia, VN_Sub, AAA, Coles)

Combined$marker <- "X"

Combined <- na.omit(Combined)

# Data Cleaning ----------------------------------------------------------

for (i in 1:1358) {
Combined$Name[i] <- sub("2-phenyl phenol|O- phenylphenol|o-Phenylphenol", "2-Phenylphenol", Combined$Name[i])
Combined$Name[i] <- sub("2 4 D", "2,4-D", Combined$Name[i])

Combined$Name[i] <- sub("p,p'-DDE|p\"-DDE|DDE - pp", "DDE (p,p)", Combined$Name[i])
Combined$Name[i] <- sub("p,p'-DDD|p\"-DDD|DDD - pp", "DDD (p,p)", Combined$Name[i])
Combined$Name[i] <- sub("p,p'-DDT|p\"-DDT|DDT - pp", "DDT (p,p)", Combined$Name[i])

Combined$Name[i] <- sub("o,p'-DDE", "DDE (o,p)", Combined$Name[i])
Combined$Name[i] <- sub("o,p'-DDD", "DDD (o,p)", Combined$Name[i])
Combined$Name[i] <- sub("o,p'-DDT", "DDT (o,p)", Combined$Name[i])

Combined$Name[i] <- sub("o,o'-DDE|o\"-DDE|DDE - oo", "DDE (o,o)", Combined$Name[i])
Combined$Name[i] <- sub("o,o'-DDD|o\"-DDD|DDD - oo", "DDD (o,o)", Combined$Name[i])
Combined$Name[i] <- sub("o,o'-DDT|o\"-DDT|DDT - oo", "DDT (o,o)", Combined$Name[i])

Combined$Name[i] <- sub("BHC-gamma (Lindane)", "HCH-gamma (Lindane)", Combined$Name[i])
Combined$Name[i] <- sub("BHC-alpha", "HCH-alpha", Combined$Name[i])
Combined$Name[i] <- sub("BHC-beta|Beta HCH|beta-HCH", "HCH-beta", Combined$Name[i])
Combined$Name[i] <- sub("BHC-delta", "HCH-delta", Combined$Name[i])
Combined$Name[i] <- sub("BHC - Total|BHC", "HCH", Combined$Name[i])

}



# Exporting Data -------------------------------------------------------

Wide_Data <- spread(Combined, Screen, marker, fill="")

write_csv(Wide_Data, "pest_set.csv")
