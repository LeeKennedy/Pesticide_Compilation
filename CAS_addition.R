

# Packages ---------------------------------------------------------------
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

# Functions --------------------------------------------------------------

# Data Input -------------------------------------------------------------

if("Windows" %in% Sys.info()['sysname'] == TRUE){ 
  cas_list <- "W:/lab/CHEMISTRY/Technical Support Projects/Pesticide Compilation Data/data/"
} else { 
  cas_list <-read_excel("~/Documents/GitHub/pest_data/Trevor.xlsx", 
                        sheet = "CAS", col_types = c("text", 
                                                     "text", "text"))
}

cas_list <- cas_list[,1:2]

Wide_Data_CAS <- merge(Wide_Data, cas_list, by.x = "Name", by.y = "Name", all = TRUE)
Wide_Data_CAS <- Wide_Data_CAS[,c(1,8,5,6,7,3,2,4)]

Wide_Data_CAS <- replace(Wide_Data_CAS, is.na(Wide_Data_CAS), "") 

write.csv(Wide_Data_CAS, "DTS_CAS.csv")
