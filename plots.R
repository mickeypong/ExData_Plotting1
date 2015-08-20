power <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)
names(power)
# get subset of 2007-02-01 and 2007-02-02
power <- mutate(power, newDate = dmy(Date))
power <- subset(power, power$newDate == dmy("01/02/2007") | power$newDate == dmy("02/02/2007"))
power <- select(power, -newDate)

# add a DateTime column and remove Date and Time column
power <- mutate(power, DateTime = dmy_hms(paste(Date, Time)))
power <- select(power, -(Date: Time))

# change other columns to numerical   
power <- mutate_each(power, funs(as.character), Global_active_power : Sub_metering_3)
power <- mutate_each(power, funs(as.numeric), Global_active_power : Sub_metering_3)
lapply(power, class)

png(filename = "plot1.png")
hist(power$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
dev.off()

png(filename = "plot2.png")
with(power, plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Actiave Power (kilowatts)"))
dev.off()

png(filename = "plot3.png")
with(power, plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy submetering"))
with(power, points(DateTime, Sub_metering_1, col = "black", type = "l"))
with(power, points(DateTime, Sub_metering_2, col = "red", type = "l"))
with(power, points(DateTime, Sub_metering_3, col = "blue", type = "l"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lwd = 1)
dev.off()


png(filename = "plot4.png")
par(mfcol = c(2, 2))
# 1st plot
with(power, {
    plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Actiave Power (kilowatts)")
# 2nd plot
    plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy submetering")
    points(DateTime, Sub_metering_1, col = "black", type = "l")
    points(DateTime, Sub_metering_2, col = "red", type = "l")
    points(DateTime, Sub_metering_3, col = "blue", type = "l")
    legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lwd = 1, bty = "n")
#3rd plot
    plot(DateTime, Voltage, type = "l")
# 4th plot
    plot(DateTime, Global_reactive_power, type = "l")
})
dev.off()
