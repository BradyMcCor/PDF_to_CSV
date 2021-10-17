###########################
### Moticon x Athletics ###
###########################

library(easycsv) #loadcsv_multi
library(tidyr) #seperate
library(plyr)


setwd("C:/Users/bsmea/Documents/USC MS/USC Football Internship/Moticon/Moticon_Data/")



# Golden
filelist <- list.files(pattern = ".txt",)
someVar <- lapply(filelist, function(x) { 
  textfile <- read.table(x,fill = TRUE)
  write.csv(textfile, 
            file = sub(pattern = "\\.txt$", replacement = ".csv", x = x))
})

# Pulling all the CMJ files into one data frame
files = list.files(path = "C:/Users/bsmea/Documents/USC MS/USC Football Internship/Moticon/Moticon_Data/",
                   pattern = '.csv', full.names = TRUE)

Moticon_Data = do.call(rbind.fill, lapply(files, function(x) 
  transform(read.csv(x), File = basename(x))))

Moticon_Data = Moticon_Data %>% relocate(File, .before = "X")

Moticon_Data = Moticon_Data[,-c(2)]

colnames(Moticon_Data) = c("Name","time","left pressure 1[N/cm²]","left pressure 2[N/cm²]",
    "left pressure 3[N/cm²]","left pressure 4[N/cm²]","left pressure 5[N/cm²]",
    "left pressure 6[N/cm²]","left pressure 7[N/cm²]","left pressure 8[N/cm²]",
    "left pressure 9[N/cm²]","left pressure 10[N/cm²]","left pressure 11[N/cm²]",
    "left pressure 12[N/cm²]","left pressure 13[N/cm²]","left pressure 14[N/cm²]",	
    "left pressure 15[N/cm²]","left pressure 16[N/cm²]","left acceleration X[g]",	
    "left acceleration Y[g]","left acceleration Z[g]","left angular X[dps]",
    "left angular Y[dps]","left angular Z[dps]","left total force[N]",	
    "left center of pressure X[%]","left center of pressure Y[%]","right pressure 1[N/cm²]",
    "right pressure 2[N/cm²]","right pressure 3[N/cm²]","right pressure 4[N/cm²]",	
    "right pressure 5[N/cm²]","right pressure 6[N/cm²]","right pressure 7[N/cm²]",
    "right pressure 8[N/cm²]","right pressure 9[N/cm²]","right pressure 10[N/cm²]",
    "right pressure 11[N/cm²]","right pressure 12[N/cm²]","right pressure 13[N/cm²]",
    "right pressure 14[N/cm²]","right pressure 15[N/cm²]","right pressure 16[N/cm²]",
    "right acceleration X[g]","right acceleration Y[g]","right acceleration Z[g]",
    "right angular X[dps]","right angular Y[dps]","right angular Z[dps]",
    "right total force[N]","right center of pressure X[%]","right center of pressure Y[%]")

Moticon_Data[,5:55] = as.data.frame.numeric(Moticon_Data[,5:55])

Impulse_Data = Moticon_Data %>% group_by(Test,Trial) %>%
               sum(Moticon_Data$`right total force[N]`)




# Cleaning the file name
Moticon_Data$Name = gsub(".csv", "", Moticon_Data$Name)

# Seperating the file name out
Moticon_Data = Moticon_Data %>% separate(Name, c("Name", "Test", "Side", "Trial"),sep = "_")

# Writing a csv
write.csv(Moticon_Data, "C:/Users/bsmea/Documents/USC MS/USC Football Internship/Moticon/Moticon_Data.csv", row.names = F)




