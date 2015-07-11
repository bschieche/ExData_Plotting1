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
png('plot4.png',width = 480, height = 480,units = "px")
# set global plotting parameters: 2x2 plots in one window
par(mfrow=c(2,2))
# fill plots rowwise
with(data,{
        # Plot 1
        plot(DateTime,Global_active_power,type="n",
             ylab="Global Active Power (kilowatts)",xlab="")
        lines(DateTime,Global_active_power)
            
        # Plot 2
        plot(DateTime,Voltage,type="n",ylab="Voltage",xlab="datetime")
        lines(DateTime,Voltage)
            
        # Plot 3
        plot(DateTime,Sub_metering_1,type="n",ylab = "Energy sub metering",xlab="")
        lines(DateTime,Sub_metering_1,col="black")
        lines(DateTime,Sub_metering_2,col="red")
        lines(DateTime,Sub_metering_3,col="blue")
        # get legend names by grepping for "Sub_metering"
        legendNames <- names(data)[grep("Sub_metering",names(data))]
        legend("topright",legendNames,col=c("black","red","blue"),lwd=2)
        
        # Plot 4
        plot(DateTime,Global_reactive_power,type="n",xlab="datetime")
        lines(DateTime,Global_reactive_power)
    })
dev.off() # close file connection