##################
### Snap Count ###
##################
library(pdftables) #convert_pdf
library(reshape2) #dcast
library(magrittr) #%>%
library(tidyr) #spread
library(tidyverse) #seperate



setwd("C:/Users/bsmea/Downloads/")

convert_pdf("Snap_Count.pdf", "Snap_Count.csv", api_key = "duc21qriw9vw")

Snap_Count = read.csv("C:/Users/bsmea/Downloads/Snap_Count.csv", skip = 3)

Snap_Count = Snap_Count[,-c(2,4:6,9,12,15,16)]
Snap_Count = Snap_Count[-c(65:68),]

Snap_Count1 = Snap_Count[,c(1:4)]
colnames(Snap_Count1) = c("Player Name", "Position","Off Def Snaps", "Special Teams Snaps")
Snap_Count1$Date = as.Date("2021-9-4")
Snap_Count1$Game = ("San Jose State")

if(Snap_Count1$Position == "OL|QB|WR|TE|RB"){
  Snap_Count1$`Offensive Snaps` = Snap_Count1$`Off Def Snaps`
  }else{
    Snap_Count1$`Offensive Snaps` = 0
    Snap_Count1$`Defensive Snaps` = 0
  }

    
if(Snap_Count1$Position = c("DL","DE","LB","CB","SAF","ILB","OLB")){
    Snap_Count1$`Defensive Snaps` = Snap_Count1$`Off Def Snaps`
    }else{
      Snap_Count1$`Offensive Snaps` = 0
      Snap_Count1$`Defensive Snaps` = 0
    }
  

Snap_Count2 = Snap_Count[,c(1,2,5,6)]
colnames(Snap_Count2) = c("Player Name", "Position","Off Def Snaps", "Special Teams Snaps")
Snap_Count2$Date = as.Date("2021-9-11")
Snap_Count2$Game = ("Stanford")

Snap_Count3 = Snap_Count[,c(1,2,7,8)]
colnames(Snap_Count3) = c("Player Name", "Position","Off Def Snaps", "Special Teams Snaps")
Snap_Count3$Date = as.Date("2021-9-18")
Snap_Count3$Game = ("Washington State")

Snap_Count4 = bind_rows(Snap_Count1,Snap_Count2)
