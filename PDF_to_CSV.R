##################
### PDF to csv ###
##################


install.packages("pdftables")
library(pdftables)

# Set the working directory #
setwd("Insert path here")

# Converting from pdf to csv
convert_pdf("Name of the file", output_file = NULL, format = "xlsx-single", message = TRUE, api_key = "duc21qriw9vw")
