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
data$DateTime <- strptime(paste(data$Date, data$Time, sep = " "), 
                          format = "%e/%m/%Y %H:%M:%S")

# subset for Feb 1-2, 2007
cat("Subsetting data for February 1 & 2, 2007...\n")
data <- data[data$DateTime >= as.POSIXlt('2007-02-01 00:00:00') 
             & data$DateTime < as.POSIXlt('2007-02-03 00:00:00'), ]

# set the png graphics device
cat("Plotting histogram to png graphics device...\n")
png(filename = "plot2.png", height = 480, width = 480, units = "px")

# Create the chart
plot(data$DateTime, data$Global_active_power, type = "l", xlab = "", 
     ylab = "Global Active Power (kilowatts)")

# Close graphics device
cat("Saving chart...\n")
dev.off()

cat("Activity complete!\n")