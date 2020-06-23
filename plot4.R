# Create some variables here to simplify changes later if needed

# URL to download the source data
src_data_url <- 
  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Name of the downloaded zip file
zip_file <- "exdata_data_household_power_consumption.zip"

# Name of the extracted data file
data_file <- "household_power_consumption.txt"

# Check if source data is available or not
# if it does not exist download and unzip the file
cat("Downloading source data from", src_data_url, "to", zip_file, "...\n")
if (!file.exists(zip_file)) {
  download.file(src_data_url, destfile = zip_file)
}

# Unzip the file
cat("Extracting", zip_file, "to", data_file, "...\n")
if (!file.exists(data_file)) {
  unzip(zip_file)
}

# Read in the data 
cat("Reading all data...\n")
data <- read.table(data_file, sep = ";", header = TRUE, na.strings = c("?"))

# Create new date time column using the date and time value
data$DateTime <- as.POSIXct(paste(data$Date, data$Time), 
                            format = "%e/%m/%Y %H:%M:%S")

# subset for Feb 1-2, 2007
cat("Subsetting data for February 1 & 2, 2007...\n")
data <- data[data$DateTime >= as.POSIXlt('2007-02-01 00:00:00') 
             & data$DateTime < as.POSIXlt('2007-02-03 00:00:00'), ]

# set the png graphics device
cat("Plotting histogram to png graphics device...\n")
png(filename = "plot4.png", height = 480, width = 480, units = "px")

# set the par rows
par(mfrow = c(2,2))
with(data, plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))

with(data, plot(DateTime, Voltage, type = "l", ylab = "Voltage", xlab = "datetime"))

with(data, plot(Sub_metering_1 ~ DateTime, data = data, type = "l", ylab = "Energy sub metering", xlab = ""))
with(data, lines(Sub_metering_2 ~ DateTime, data = data, type = "l", col = "red"))
with(data, lines(Sub_metering_3 ~ DateTime, data = data, type = "l", col = "blue"))

legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lwd = 1, bty = "n")

with(data, plot(Global_reactive_power ~ DateTime, data = data, type = "l", xlab = "datetime"))

# Close graphics device
cat("Saving plot...\n")
dev.off()

cat("Activity complete!\n")