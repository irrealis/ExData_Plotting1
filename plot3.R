## Plot 3 for week-1 project, Coursera Course "Exploratory Data Analysis", "Data Science" track, Johns Hopkins University.
## See https://github.com/irrealis/ds04-wk1-exploratory-data-analysis


library(dplyr)
library(lubridate)

# Create data dir and download/extract raw data if missing.
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

# Convert Date/Time columns to datetime column, and extract date for 2007-02-01 and 2007-02-02.
df <- df %>%
  # Add datetime column based on Date/Time columns.
  mutate(datetime = dmy_hms(paste(Date, Time))) %>%
  # Remove Date and Time columns.
  select(-Date, -Time) %>%
  # Extract data for 2007-02-01 and 2007-02-02.
  filter(datetime >= ymd("2007-02-01") & datetime < ymd("2007-02-03"))

# Plot of weekday versus sub metering.
png("plot3.png", height = 480, width = 480)
with(df, {
  plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black")
  lines(datetime, Sub_metering_2, col = "red")
  lines(datetime, Sub_metering_3, col = "blue")
  legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()
