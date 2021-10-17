#####################
### Sample Report ###
#####################
install.packages("tidyr")
library(tidyr)
library(dplyr)
library(plyr)
library(tidyverse)

# Set the working directory #
setwd("C:/Users/bsmea/Documents/USC MS/USC Football Internship/Sample Report/")

# Pulling all the files in and putting them into a list #
temp = list.files(path = "C:/Users/bsmea/Documents/USC MS/USC Football Internship/Sample Report/",pattern="*.csv")

# Putting all the data from a list to a csv file #
Combined_Data = ldply(temp, read_csv, skip = 9)

# Adding the session name to the file
List_data <- data_frame(filename = temp) %>% 
  mutate(file_contents = map(filename, ~ read_csv(skip = 9, file.path("C:/Users/bsmea/Documents/USC MS/USC Football Internship/Sample Report/", .))))  
All_data = unnest(List_data)

# Writing a new csv
write.csv(data_2,"C:/Users/bsmea/Documents/USC MS/USC Football Internship/Sample_Report_Data.csv", row.names = FALSE)



