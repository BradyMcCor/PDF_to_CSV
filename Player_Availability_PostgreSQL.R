###############################
##### Player Availability #####
###############################

#library(data.table)
library(magrittr)
library(tidyr)
library(lubridate)
library(RPostgreSQL)
library(devtools)
library(remotes)
library(RPostgres)
library(data.table) # setDT
library(easycsv) # loadcsv_multi
library(DBI) # Postgresql
library(dplyr) # tbl
library(readxl)
library(XLConnect)
library(xlsx)

##################################
### All you need to import now ###
##################################

# Pulling all the PFF and Catapult files
dir = setwd("C:/Users/bsmea/Documents/USC MS/USC Football Internship/Player Availability/")

loadcsv_multi(dir, extension = "BOTH")

rm("IR")

memory.limit(size = 4000000000)
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

# Editing the game day data
Game_Day_Data = as.data.frame(tbl(con,"Game_Day_Data"))

# getting rid of NA's
write.csv(Game_Day_Data, 
"C:/Users/bsmea/Documents/USC MS/USC Football Internship/Player Availability/All_Data_Combined/Game_Day_Data.csv",
na = "")

##############################

# To close the connection
# dbDisconnect(con)

######################################
### Keep this for future reference ###
######################################

# # Getting the dates for each sheet of data
# sheetnames = excel_sheets("C:/Users/bsmea/Downloads/Football_Injury_Report.xlsx")
# 
# # Making a list of all the sheets in an excel file
# mylist = lapply(excel_sheets("C:/Users/bsmea/Downloads/Football_Injury_Report.xlsx"), 
#                 read_excel, path = "C:/Users/bsmea/Downloads/Football_Injury_Report.xlsx")
# 
# # Getting a list of dates from the sheetnames
# names(mylist) = sheetnames
# 
# # Getting rid of the 44367
# W = lapply(mylist, function(x) {
#   x[!(x[,1] == "44376"),]
# })
# 
# # Getting rid of the Coach's Report
# W = lapply(W, function(x) {
#   x[!(x[,1] == "Coach's Report"),]
# })
# 
# colnames = c("Name", "Participation_Status", "Side", "Injury", "Rehab", "Practice_Status", 
#              "Weight_Room","Meetings")
# 
# W = lapply(W, setNames, colnames)
# 
# 
# # Putting all the tables into one data frame
# IR = rbindlist(lapply(W, as.data.frame.list), idcol = sheetnames, fill=TRUE)
# 
# IR = as.data.frame(IR)
# 
# write.csv(IR,"C:/Users/bsmea/Documents/USC MS/USC Football Internship/Player Availability/IR.csv", row.names = TRUE)

###########################################
### PFF compared to Player Availability ###
###########################################

# # Setting columns to dates
# PA_PFF_Defense$pff_GAMEDATE = as.Date(PA_PFF_Defense$pff_GAMEDATE)
# PA_PFF_Offense$pff_GAMEDATE = as.Date(PA_PFF_Offense$pff_GAMEDATE)
# 
# # Getting the dates of the injury report right before gameday
# USC_Scores$Date = as.Date(USC_Scores$Date)
# C_Data$date = as.Date(C_Data$date)
# Player_Availability_History$Date = as.Date(Player_Availability_History$Date)
# 
# Sc_Dates = as.Date(c("2020-11-06","2020-11-13","2020-11-20","2020-12-05","2020-12-11",
#              "2020-12-17","2019-08-30","2019-09-06","2019-09-13","2019-09-19",
#              "2019-09-27","2019-10-11","2019-10-18","2019-10-24","2019-11-01",
#              "2019-11-08","2019-11-15","2019-11-22","2019-12-26","2018-08-31",
#              "2018-09-07","2018-09-14","2018-09-20","2018-09-28","2018-10-12",
#              "2018-10-19","2018-10-26","2018-11-02","2018-11-09","2018-11-16",
#              "2018-11-23"))
# 
# 
# GD_1 = Player_Availability_History[Player_Availability_History$Date %in% Sc_Dates,]

####################
## Wins vs Losses ##
####################

# # Status count on Game Day counts
# GD_IR = plyr::count(GD_1, c("Date", "Status"))
# 
# # Getting dates for wins and loses
# D_W = subset(Scores, Scores$Result == "W")
# D_L = subset(Scores, Scores$Result == "L")
# 
# # Status count on Game Day by wins or loses
# D_W_D = tidyr::spread(GD_IR, Status, freq)
# D_W_V = (D_W$Date - 1)
# GD_IR_W = D_W_D[D_W_D$Date %in% D_W_V,]
# D_L_V = (D_L$Date - 1)
# GD_IR_L = D_W_D[D_W_D$Date %in% D_L_V,]
# 
# # Converting IR dates to game day dates
# D_W$Date = (D_W$Date - 1)
# D_L$Date = (D_L$Date - 1)
# 
# # Adding the player status to game stats
# D_W = merge(D_W, GD_IR_W, by = "Date")
# D_L = merge(D_L, GD_IR_L, by = "Date")
# D = rbind(D_L, D_W)
# 
# # Moving columns around
# D = D %>% dplyr::relocate(Result, .before = USC.Score)
# 
# # Converting columns to numeric
# i = c(5:47)
# D[ , i] <- apply(D[ , i], 2, function(x) as.numeric(as.character(x)))
# 
# # Statistics
# median(D_W$Out) # 17.5
# median(D_L$Out) # 18
# 
# median(D_W$Limited, na.rm = TRUE) # 1
# median(D_L$Limited, na.rm = TRUE) # 1
# 
# cor(D_W$Out, D_W$Diff) # 0.1164607
# cor(D_L$Out, D_L$Diff) # 0.2528398
# 
# cor(D$Out, D$Diff) # 0.1747525
# COR_IR = cor(D[5:47])




#########################################################
### Pulling in all the new PFF Data and Catapult Data ###
#########################################################

# # Getting a list of dates between game days
# B_GD = D_W_D %>%
#   mutate(Date = as.Date(Date)) %>%
#   complete(Date = seq.Date(min(Date)-7, max(Date), by = "day"))
# 
# B_GD = B_GD[-c(93:364,491:798),]
# 
# # Subsetting Catapult Data by date
# a = as.Date(B_GD$Date)
# GD_Catapult = C_Data[C_Data$date %in% as.Date(a),]
# 
# write.csv(GD_Catapult, "C:/Users/bsmea/Documents/USC MS/USC Football Internship/Player Availability/GD_Cat.csv", row.names = TRUE)
# 
# 
# 
# Game_Day = merge(GD_Cat,PA_PFF_Blocking,PA_PFF_Defense,
#               PA_PFF_Game_Grade, PA_PFF_Offense, PA_PFF_Pass_Protect,
#               PA_PFF_Pass_Rush, PA_PFF_Passing, PA_PFF_Penalty, 
#               PA_PFF_Pressure, PA_PFF_QB_Charting, PA_PFF_Rushing,
#               PA_PFF_Team_Analysis, PA_PFF_Team_Main, PA_PFF_Team_Play,
#               Player_Availability_History, USC_Scores,by.x = "game_id" ,all.x = TRUE)
# 
# Game_Day1 = dplyr::full_join(GD_Cat,PA_PFF_Blocking, by = "game_id")
# 
# Game_Day2 = dplyr::full_join(Game_Day1,PA_PFF_Game_Grade, by = c("game_id",
#             "position","season","week","player_id","team"))
# rm(Game_Day1)
# Game_Day3 = dplyr::full_join(Game_Day2,PA_PFF_Offense, by = c("game_id", "play_id"))
# 
# rm(Game_Day2)
# Game_Day3$offense = as.character(Game_Day3$offense)
# Game_Day4 = dplyr::full_join(Game_Day3,PA_PFF_Pass_Protect, by = c("game_id",
#             "name","position","gsis_game_id","gsis_play_id","play_id","quarter",
#             "down","distance","game_clock","player_id","gsis_player_id","offense"))
# 
# rm(Game_Day3)
# Game_Day4$defense = as.character(Game_Day4$defense)
# Game_Day5 = dplyr::full_join(Game_Day4,PA_PFF_Pass_Rush, by = c("game_id","name",
#                    "position","gsis_game_id","gsis_play_id","play_id","quarter",
#                    "down","distance","game_clock","player_id","gsis_player_id",
#                    "defense","third_down_group","turn_of_center","play_action",
#                    "shotgun","blitz","dropback_type","dropback_depth","step_drop",
#                    "defensive_backs","no_play","side","toc_to_away","time_to_throw",
#                    "time_to_throw_group","time_to_pressure"))
# 
# rm(Game_Day4)
# Game_Day5$shotgun = as.character(Game_Day5$shotgun)
# Game_Day5$step_drop = as.integer(Game_Day5$step_drop)
# Game_Day6 = dplyr::full_join(Game_Day5,PA_PFF_Passing, by = c("game_id","gsis_game_id",
#                              "gsis_play_id","play_id","season","week","quarter",
#                              "down","distance","game_clock","fieldpos","offense",
#                              "defense","run","play_action","shotgun","blitz",
#                              "dropback_depth","step_drop","no_play","time_to_throw",
#                              "time_to_pressure"))
# 
# rm(Game_Day5)
# Game_Day7 = dplyr::full_join(Game_Day6,PA_PFF_Penalty, by = c("game_id","name","game_key",
#                              "play_gsis_id","gsis_game_id","gsis_play_id","play_id",
#                              "seq","quarter","down","distance","game_clock","fieldpos",
#                              "rps","player_id","gsis_player_id","pos_group","pos",
#                              "role","offense","defense"))
# 
# rm(Game_Day6)
# Game_Day7$shotgun = as.integer(Game_Day7$shotgun)
# Game_Day7$step_drop = as.character(Game_Day7$step_drop)
# Game_Day8 = dplyr::full_join(Game_Day7,PA_PFF_Pressure, by = c("game_id","gsis_game_id",
#                              "gsis_play_id","play_id","quarter","down","distance",
#                              "game_clock","offense","defense","third_down_group",
#                              "turn_of_center","play_action","shotgun","blitz",
#                              "dropback_type","dropback_depth","step_drop",
#                              "defensive_backs","no_play","time_to_throw",
#                              "time_to_throw_group","time_to_pressure","stance",
#                              "shade","tech","comment" ))
# rm(Game_Day7)
# Game_Day9 = dplyr::full_join(Game_Day8,PA_PFF_QB_Charting, by = c("game_id",
#                             "game_key","gsis_game_id","gsis_play_id","play_id",
#                             "season","week","quarter","down","distance",
#                             "game_clock","fieldpos","team","passer_player_id",
#                             "passer_player_gsis_id","passer_name"))
# 
# rm(Game_Day8)
# PA_PFF_Rushing$shotgun = as.integer(PA_PFF_Rushing$shotgun)
# Game_Day10 = dplyr::full_join(Game_Day9,PA_PFF_Rushing, by = c("game_id",
#                             "gsis_game_id","gsis_play_id","play_id","season",
#                             "week","quarter","down","distance","game_clock",
#                             "fieldpos","offense","defense","play_action","shotgun",
#                             "blitz","no_play","is_preseason","away_team","home_team",
#                             "game_sequence","attempt","yards","touchdown","extra_point",
#                             "ing_pen","off_package","def_package","pistol","pump_fake",
#                             "screen","first_down_conv","hash","shift_motion",
#                             "mofo_coverage_played","mofo_coverage_shown","comment"))
# 
# rm(Game_Day9)
# Game_Day11 = dplyr::full_join(Game_Day10,PA_PFF_Team_Analysis, by = c("game_id","gsis_game_id",
#                               "gsis_play_id","play_id","season","week","quarter",
#                               "down","distance","game_clock","rps","offense","defense",
#                               "away_team","home_team","comment"))
# 
# rm(Game_Day10)
# Game_Day12 = dplyr::full_join(Game_Day11,PA_PFF_Team_Main, by = c("game_id","position",
#                               "gsis_game_id","gsis_play_id","play_id","player_id",
#                               "gsis_player_id","team","role","player","stance",
#                               "pass_direction","pass_depth","first_contact_blocked"))
# 
# rm(Game_Day11)
# PA_PFF_Team_Play$dropback = as.integer(PA_PFF_Team_Play$dropback)
# Game_Day12$pistol = as.integer(Game_Day12$pistol)
# PA_PFF_Team_Play$motion = as.character(PA_PFF_Team_Play$motion)
# Game_Day13 = dplyr::full_join(Game_Day12,PA_PFF_Team_Play, by = c("game_id",
#                               "gsis_game_id","gsis_play_id","play_id","quarter",
#                               "down","distance","game_clock","offense","defense",
#                               "turn_of_center","play_action","shotgun","dropback_depth",
#                               "time_to_throw","time_to_pressure","dropback","pistol",
#                               "pump_fake","screen","route","run_concept_1","run_concept_2",
#                               "run_concept_3","motion"))
# 
# #Game_Day14 = dplyr::full_join(Game_Day13,Player_Availability_History, by = c("game_id"))
# 
# #rm(Game_Day13)
# Game_Day15 = dplyr::full_join(Game_Day13,USC_Scores, by = c("game_id","week","away_team"))
# 
# # Writing a csv with all the data
# write.csv(Game_Day_Data, "C:/Users/bsmea/Documents/USC MS/USC Football Internship/Player Availability/All_Data_Combined/Game_Day_Data.csv")
# 
# ## Putting the table into postgresql ##
# dbWriteTable(con,'Game_Day_Data',Game_Day15, row.names = FALSE)














