## WEEK 1 ASSIGNMENT
if(!file.exists("week1/data")){
  dir.create("week1/data")
}
if(!file.exists("week1/plots")){
  dir.create("week1/plots")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./week1/data/hpc.zip")
utils::unzip("./week1/data/hpc.zip", exdir = "./week1/data") # household_power_consumption.txt

library(dplyr)
hpctable <- tbl_df(read.table(file = "./data/household_power_consumption.txt", sep = ";", header = TRUE))
head(hpctable)

hpctable %>% mutate_at(c(1,2), c(as.Date(format = "%d/%m/%Y"),as.POSIXlt(format = "%T")))
# in the whole dataset missing values are flagged with "?"

# convert columns to proper data types, while filtering out the unneccessary dates
library(hms)
twoday <- hpctable %>% 
  mutate(Date = as.POSIXlt(Date, format = "%d/%m/%Y")) %>% 
  filter(Date >= '2007-02-01' & Date <= '2007-02-02') %>%
  mutate(Time = as_hms(Time)) %>% 
  mutate_at(3:9, as.double) %>%
  mutate(datetime = Date + Time)



# Plot 1: Global Active Power Histogram
png(filename = "./week1/plots/plot1.png", width = 480, height = 480) # open png device
hist(twoday$Global_active_power, col = 'red', 
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off() # close the png device and save the image

# Plot 2: Global Active Power over Two Days
png(filename = "./week1/plots/plot2.png", width = 480, height = 480) # open png device
with(twoday, plot(datetime, Global_active_power,
                  type = 'l', xlab = NA, ylab = "Global Active Power (kilowatts)"))
dev.off() # close the png device and save the image

# Plot 3: Overlapping sub_metering
png(filename = "./week1/plots/plot3.png", width = 480, height = 480) # open png device
with(twoday, {
  plot(datetime, Sub_metering_1,
       type = 'l', xlab = NA, ylab = "Energy sub metering")
  lines(datetime, Sub_metering_2, col = "red")
  lines(datetime, Sub_metering_3, col = "blue")
  legend("topright",col=c("black","red","blue"), lwd = 2,
         legend=c("sub metering 1","sub metering 2", "sub metering 3"))
})
dev.off() # close the png device and save the image

# Plot 4: Four Subplots -> global active power, sub metering, voltage, reactive power
png(filename = "./week1/plots/plot4.png", width = 480, height = 480) # open png device
with(twoday, {
  plot.new()
  par(mfcol= c(2,2)) # sets plots by columns
  
  plot(datetime, Global_active_power, type = 'l', ylab = "Global Active Power")
  
  plot(datetime, Sub_metering_1,
       type = 'l', ylab = "Energy sub metering")
  lines(datetime, Sub_metering_2, col = "red")
  lines(datetime, Sub_metering_3, col = "blue")
  legend("topright",col=c("black","red","blue"), lwd = 2, border = NULL,
         legend=c("sub metering 1","sub metering 2", "sub metering 3"))
  
  plot(datetime, Voltage, type = 'l', ylab = "Global Active Power")
  
  plot(datetime, Global_reactive_power, type = 'l', ylab = "Global Reactive Power")
})
dev.off() # close the png device and save the image