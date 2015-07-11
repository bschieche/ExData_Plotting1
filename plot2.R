library(dplyr)
# This command is used to change the weekdays output from German to 
# English for POSIXct variables
# uncomment if necessary
Sys.setlocale("LC_TIME", "C")

# read the data
data <- read.csv("household_power_consumption.txt",
                 sep=";",
                 stringsAsFactors=FALSE,
                 na.strings = "?",
                 colClasses = c(rep("character",2),rep("numeric",7)))

# data conversion in 3 steps:
# 1. add DateTime variable to data by pasting Date and Time variables together and
# convert it to POSIXct format with appropriate format string
# 2. delete Date and Time columns
# 3. extract data corresponding to 2007-02-01 and 2007-02-02
data <- data %>%
        mutate(DateTime = as.POSIXct(paste(Date,Time),format = "%d/%m/%Y %H:%M:%S")) %>%
        select(-(Date:Time)) %>%
        filter(as.Date(DateTime)==as.Date("2007-02-01") | as.Date(DateTime)==as.Date("2007-02-02"))

# open connection to PNG file
png('plot2.png',width = 480, height = 480,units = "px")
plot(data$DateTime,data$Global_active_power,
     type="n",ylab="Global Active Power (kilowatts)",xlab="")
lines(data$DateTime,data$Global_active_power)
dev.off() # close file connection