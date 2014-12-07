## Load data.table library
library(data.table)

## Read data from raw file selecting dates we care about into data frame
data <- (fread("household_power_consumption.txt", colClasses="character")
         [(Date == "1/2/2007" | Date == "2/2/2007")])

## Convert to one master time combining date and time
mastertime <- data.table(paste(data$Date, data$Time))

## Re-configure columns to numeric
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Global_intensity <- as.numeric(data$Global_intensity)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

## Convert master time string into POSIXct
data[,"mastertime"] <- mastertime
data$mastertime <- as.POSIXct(strptime(data$mastertime, format="%d/%m/%Y %H:%M:%S"))

## Set layout of graphs
par(mfrow = c(2,2))

## Plot top left
## Plot Global Active Power over time
plot(x = data[,mastertime], y = data[,Global_active_power], type = "l",
     xlab = "", ylab = "Global Active Power (kilowatts)")

## Plot Top Right
## Plot voltage over time
plot(data[,mastertime],data[,Voltage], type = "l",
     xlab = "datetime", ylab = "Voltage")

## Plot Bottom Left
## Plot Submetering
#### Build empty shell
plot(x = data[,mastertime], y = data[,Sub_metering_1], type = "n",
     xlab = "", ylab = "Energy Sub Metering",)

#### Plot three lines
lines(data[,mastertime], data[,Sub_metering_1], type = "l",
      ylim = c(0,38), col = "black")
lines(data[,mastertime], data[,Sub_metering_2], type = "l",
      ylim = c(0,38), col = "red")
lines(data[,mastertime], data[,Sub_metering_3], type = "l",
      ylim = c(0,38), col = "blue")
#### Build Legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1, cex = 0.7, bty = "n")

## Plot Bottom Right
##Global_reactive_power over time (datetime)
plot(data[,mastertime],data[,Global_reactive_power], type = "l",
     xlab = "datetime", ylab = "Global_reactive_power")

## Writes out a PNG file of the graphics
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()
