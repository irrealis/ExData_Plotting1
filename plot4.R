## Plot 4 for week-1 project, Coursera Course "Exploratory Data Analysis", "Data Science" track, Johns Hopkins University.
## See https://github.com/irrealis/ds04-wk1-exploratory-data-analysis


library(dplyr)
library(lubridate)

# Create data dir and extract raw data if missing.
zip_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datadir <- "raw_data"
zipfile <- file.path(datadir, "household_power_consumption.zip")
datafile <- "household_power_consumption.txt" 
if(!file.exists(datadir)){ dir.create(datadir) }
if(!file.exists(zipfile)){ download.file(zip_url, zipfile, "curl") }
if(!file.exists(datafile)){ unzip(zipfile) }

# Load data.
col_cls = c(rep("character", 2), rep("numeric", 7))
df <- read.table(datafile, sep = ";", header = T, na.strings = "?", colClasses = col_cls)

# Create data dir and download/extract raw data if missing.
df <- df %>% mutate(datetime = dmy_hms(paste(Date, Time))) %>%
  select(-Date, -Time) %>%
  # Filter data from the dates 2007-02-01 and 2007-02-02.
  filter(datetime >= ymd("2007-02-01") & datetime < ymd("2007-02-03"))

# Panel of plots of weekday versus:
# - Global active power.
# - Sub metering.
# - Voltage.
# - Global reactive power.
png("plot4.png", height = 480, width = 480)
par(mfcol = c(2,2))
# Global active power
with(df, plot(datetime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
# Sub metering.
with(df, {
  plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black")
  lines(datetime, Sub_metering_2, col = "red")
  lines(datetime, Sub_metering_3, col = "blue")
  legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
# Voltage.
with(df, plot(datetime, Voltage, type = "l"))
# Global reactive power.
with(df, plot(datetime, Global_reactive_power, type = "l"))
dev.off()
