#######################
### Nordbord Report ###
#######################
library(DBI)
library(dplyr)
library(lubridate)
library(data.table)
library(tibble)

##################
### Postgresql ###
##################



remotes::install_github("r-dbi/RPostgres")

con = dbConnect(RPostgres::Postgres())

# Connecting to the specfic database

db = 'postgres'  #provide the name of your db

host_db = 'localhost' # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'  

db_port = '5433'  # or any other port specified by the DBA

db_user = 'postgres'

db_password = 'Trojans_Nation24'

con = dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password) 

# Check to see if the connection has been made
dbListTables(con)

# Making a data frame from a table in postgresql
C_Data = as.data.frame(tbl(con, "fb_demands_18_20"))


# To close the connection
dbDisconnect(con) 

#######################################
### Pulling in the data (Temporary) ###
#######################################

dir = setwd("C:/Users/bsmea/Documents/USC MS/USC Football Internship/Nordbord/N_Data.csv")

N_Data = read.csv(file.choose())
N_Data = N_Data[,-c(2,20)]
colnames(N_Data) = c("Name","Date_UTC","Time_UTC","Device","Test","L_Reps","R_Reps",
                     "L_Max_Force","R_Max_Force","Max_Imbalance","L_Max_Torque",
                     "R_Max_Torque","L_Avg_Force","R_Avg_Force","Avg_Imbalance",
                     "L_Max_Impulse","R_Max_Impulse","Impulse_Imbalance")

N_Report = data.frame(matrix(NA, nrow = 1, ncol = 34))
colnames(N_Report) = c("Recent_Date","L_Max_Force","3_Month_Change","3_Month_Sig",
                       "R_Max_Force","3_Month_Change","3_Month_Sig","Max_Imbalance",
                       "3_Month_Change","3_Month_Sig","L_Max_Torque","3_Month_Change",
                       "3_Month_Sig","R_Max_Torque","3_Month_Change","3_Month_Sig",
                       "L_Avg_Force","3_Month_Change","3_Month_Sig","R_Avg_Force",
                       "3_Month_Change","3_Month_Sig","Avg_Imbalance","3_Month_Change",
                       "3_Month_Sig","L_Max_Impulse","3_Month_Change","3_Month_Sig",
                       "R_Max_Impulse","3_Month_Change","3_Month_Sig","Impulse_Imbalance",
                       "3_Month_Change","3_Month_Sig")

# Converting to dates #
N_Data$Date_UTC = as.Date(N_Data$Date_UTC, '%d/%m/%Y')

# Making the stats table #

a = as.data.frame(unique(N_Data$Name))
colnames(a) = c("Name")
N_Report1 = cbind(a,N_Report)

# Creating the table with the most recent test results
N_Recent = N_Data[tapply(1:nrow(N_Data),N_Data$Name,function(ii) 
  ii[which.max(N_Data$Date_UTC[ii])]),]

# Getting the last 3 months worth of test data
N_3M = setDT(N_Data)[, .SD[Date_UTC >= max(Date_UTC) %m-% months(3)], by = Name]
# Getting the last 3 month averages for each metric
N_3MA = aggregate(N_3M[, 8:18], list(N_3M$Name), mean)
colnames(N_3MA)[1] = "Name"

N_R = N_Recent[,c(1,8:18)]
# Merging the data frames with recent and 3 month avg
N_Report1 = merge(N_R, N_3MA, by = 'Name')

# Renaming the columns
colnames(N_Report1) = gsub("x", "Recent", colnames(N_Report1))
colnames(N_Report1) = gsub("y", "3_Month_AVG", colnames(N_Report1))

# Getting the differences
dplyr::mutate_each(iris, funs(min_rank))


