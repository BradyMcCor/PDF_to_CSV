####################################################
###### Lineman Contacts -> Player Performance ######
####################################################
library(easycsv)
library(dplyr)

# Setting the working directory
directory = setwd("C:/Users/bsmea/Documents/USC MS/USC Football Internship/Impact Performance/")

# Pulling all the files in and putting them into separate data frames
loadcsv_multi(directory, extension = "BOTH")

# Renaming the dataframes
LM_2015_C = `Lineman_2015_C`

# Removing old dataframes
rm(`Lineman_2015_C`)

# Renaming the columns
colnames(DL_2015_PFF) = sub("pff.*", "", sub(".*_", "", colnames(DL_2015_PFF)))

colnames(LM_2015_C) = gsub("\\."," ", colnames(LM_2015_C))

names(LM_2015_C)[names(LM_2015_C) == "ï  Name"] <- "Name"


############################################
### Separating out the name column in LC ###
############################################

LM_2015_C$`Period` = sub("\\ - .*", "", sub(".*\\ - ", "", LM_2015_C$Name))
LM_2015_C$`Player Name` = sub(".*\\ - ", "", sub("\\ - .*", "", LM_2015_C$Name))
LM_2015_C$Date = sub(".+? -", "", LM_2015_C$Name)
LM_2015_C$Date = gsub(" ", "", LM_2015_C$Date)
LM_2015_C$Date = gsub("-.*", "", LM_2015_C$Date)

LM_2015_C = LM_2015_C %>% dplyr::select("Player Name", everything())
LM_2015_C = LM_2015_C %>% dplyr::select("Date", everything())
LM_2015_C = LM_2015_C %>% dplyr::select("Period", everything())

# Removing the old column
LM_2015_C = LM_2015_C[,-c(4)]

# Setting the date columns as dates
LM_2015_C$Date = as.Date(LM_2015_C$Date, format = "%m/%d/%Y")
DL_2015_PFF$GAMEDATE = as.Date(DL_2015_PFF$GAMEDATE)

#################################################################
### Do impacts have a strong correlation to time to pressure? ###
#################################################################

# Creating the cutoff to get rid of any contact load periods below 0
LM_2015_C_F = dplyr::filter(LM_2015_C, Period != 'Pregame Warm-Up' & `Position Name` == 'DL' 
                            & `Average Contact Load` > 0)

# Correcting the dates for the Catapult file
LM_2015_C_F$Date = sub('2015-09-06', '2015-09-05', LM_2015_C_F$Date)
LM_2015_C_F$Date = sub('2015-12-31', '2015-12-30', LM_2015_C_F$Date)
LM_2015_C_F$Date = sub('2015-11-08', '2015-11-07', LM_2015_C_F$Date)

# Moving columns
LM_2015_C_F = LM_2015_C_F %>% dplyr::relocate('Position Name', .before = 'Average Contact Load')

# Creating the reference average time to pressure average per game
DL_ATTP = aggregate(x = DL_2015_PFF$TIMETOPRESSURE, by = list(DL_2015_PFF$GAMEDATE), FUN = mean, na.rm = TRUE)
colnames(DL_ATTP) = c("Date", "Avg Time to Pressure")

## Looking at AVG Impact Load Session
DL_All_Variables = aggregate(x = LM_2015_C_F[,5:18], by = list(LM_2015_C_F$Date), FUN = mean)
All_TTP_Impact = as.data.frame(c(DL_All_Variables,DL_ATTP))
All_TTP_Impact = All_TTP_Impact[,-c(1,16)]

Cor_TTP_Impact = as.data.frame(cor(All_TTP_Impact))

# Not really, everything was under a 0.5




