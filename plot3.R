## Plot 3 for week-1 project, Coursera Course "Exploratory Data Analysis", "Data Science" track, Johns Hopkins University.
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
df <- read.table(
  datafile,
  sep = ";",
  dec = ".",
  header = T,
  na.strings = c("?"),
  colClasses = c(rep("character", 2), rep("numeric", 7))
)

# Convert Date/Time columns to datetime column, 
df <- df %>% mutate(datetime = dmy_hms(paste(Date, Time))) %>%
  select(-Date, -Time) %>%
  # Filter data from the dates 2007-02-01 and 2007-02-02.
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
