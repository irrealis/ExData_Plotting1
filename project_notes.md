# Project notes

Notebook for week-1 project, Coursera Course "Exploratory Data Analysis", "Data Science" track, Johns Hopkins University.

See [README.md](./README.md) for more details.


## R version and platform used

```r
print(version)
```
- Output:
  ```
  _                           
  platform       x86_64-apple-darwin15.6.0   
  arch           x86_64                      
  os             darwin15.6.0                
  system         x86_64, darwin15.6.0        
  status                                     
  major          3                           
  minor          4.2                         
  year           2017                        
  month          09                          
  day            28                          
  svn rev        73368                       
  language       R                           
  version.string R version 3.4.2 (2017-09-28)
  nickname       Short Summer
  ```

## Libraries used:

```r
library(dplyr)
library(lubridate)
```


## Get data.

Create data dir if missing.
```r
if(!file.exists("raw_data")){
  dir.create("raw_data")
}
```

Get raw data if missing.
```r
raw_zip_path <- file.path("raw_data", "household_power_consumption.zip")
if(!file.exists(raw_zip_path)){
  download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
    destfile = raw_zip_path,
    method = "curl"
  )
}
```

Unzip raw data if missing.
```r
raw_file_path <- "household_power_consumption.txt" 
if(!file.exists(raw_file_path)){  
  unzip(raw_file_path)
}
```


## Load data.

Looks like this file uses "`;`" as separator and "`.`" as decimal point:
```python
!head "household_power_consumption.txt"
```
- Output:
  ```
  Date;Time;Global_active_power;Global_reactive_power;Voltage;Global_intensity;Sub_metering_1;Sub_metering_2;Sub_metering_3
  16/12/2006;17:24:00;4.216;0.418;234.840;18.400;0.000;1.000;17.000
  16/12/2006;17:25:00;5.360;0.436;233.630;23.000;0.000;1.000;16.000
  16/12/2006;17:26:00;5.374;0.498;233.290;23.000;0.000;2.000;17.000
  16/12/2006;17:27:00;5.388;0.502;233.740;23.000;0.000;1.000;17.000
  16/12/2006;17:28:00;3.666;0.528;235.680;15.800;0.000;1.000;17.000
  16/12/2006;17:29:00;3.520;0.522;235.020;15.000;0.000;2.000;17.000
  16/12/2006;17:30:00;3.702;0.520;235.090;15.800;0.000;1.000;17.000
  16/12/2006;17:31:00;3.700;0.520;235.220;15.800;0.000;1.000;17.000
  16/12/2006;17:32:00;3.668;0.510;233.990;15.800;0.000;1.000;17.000
  ```

Number of lines:
```python
!wc "household_power_consumption.txt"
```
- Output:
  ```
  2075260 2075260 132960755 household_power_consumption.txt
  ```

Estimate of memory required:
```r
2075260*9*8*2
```
- Output:
  ```
  298837440
  ```
So roughly 300MB. No problem, 16GB physical RAM, about 10GB available.

Command to load:
```r
df <- read.table(
  "household_power_consumption.txt",
  sep = ";",
  dec = ".",
  header = T,
  na.strings = c("?"),
  colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
)
```

Load looks good:
```r
head(df)
tail(df)
```
- Output:
  ```
  Date	Time	Global_active_power	Global_reactive_power	Voltage	Global_intensity	Sub_metering_1	Sub_metering_2	Sub_metering_3
  16/12/2006	17:24:00	4.216	0.418	234.84	18.4	0	1	17
  16/12/2006	17:25:00	5.360	0.436	233.63	23.0	0	1	16
  16/12/2006	17:26:00	5.374	0.498	233.29	23.0	0	2	17
  16/12/2006	17:27:00	5.388	0.502	233.74	23.0	0	1	17
  16/12/2006	17:28:00	3.666	0.528	235.68	15.8	0	1	17
  16/12/2006	17:29:00	3.520	0.522	235.02	15.0	0	2	17
  
  Date	Time	Global_active_power	Global_reactive_power	Voltage	Global_intensity	Sub_metering_1	Sub_metering_2	Sub_metering_3
  2075254	26/11/2010	20:57:00	0.946	0	240.33	4.0	0	0	0
  2075255	26/11/2010	20:58:00	0.946	0	240.43	4.0	0	0	0
  2075256	26/11/2010	20:59:00	0.944	0	240.00	4.0	0	0	0
  2075257	26/11/2010	21:00:00	0.938	0	239.82	3.8	0	0	0
  2075258	26/11/2010	21:01:00	0.934	0	239.70	3.8	0	0	0
  2075259	26/11/2010	21:02:00	0.932	0	239.55	3.8	0	0	0
  ```
Hmm, I hadn't noticed that before. "`Tail`" is inserting row numbers.

Verify column classes:
```r
str(df)
```
- Output:
  ```
  'data.frame':	2075259 obs. of  9 variables:
   $ Date                 : chr  "16/12/2006" "16/12/2006" "16/12/2006" "16/12/2006" ...
   $ Time                 : chr  "17:24:00" "17:25:00" "17:26:00" "17:27:00" ...
   $ Global_active_power  : num  4.22 5.36 5.37 5.39 3.67 ...
   $ Global_reactive_power: num  0.418 0.436 0.498 0.502 0.528 0.522 0.52 0.52 0.51 0.51 ...
   $ Voltage              : num  235 234 233 234 236 ...
   $ Global_intensity     : num  18.4 23 23 23 15.8 15 15.8 15.8 15.8 15.8 ...
   $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
   $ Sub_metering_2       : num  1 1 2 1 1 2 1 1 1 2 ...
   $ Sub_metering_3       : num  17 16 17 17 17 17 17 17 17 16 ...
   ```


## Convert `character` `Date`/`Time` columns to `POSIXct` `datetime` column.

Test of conversion of date and time columns from character to POSIXct:
```r
t <- head(df)
with(t, dmy_hms(paste(Date, Time)))
t %>% mutate(datetime = dmy_hms(paste(Date, Time))) %>% select(-Date, -Time)
```
- Output:
  ```
  [1] "2006-12-16 17:24:00 UTC" "2006-12-16 17:25:00 UTC"
  [3] "2006-12-16 17:26:00 UTC" "2006-12-16 17:27:00 UTC"
  [5] "2006-12-16 17:28:00 UTC" "2006-12-16 17:29:00 UTC"

  Global_active_power	Global_reactive_power	Voltage	Global_intensity	Sub_metering_1	Sub_metering_2	Sub_metering_3	datetime
  4.216	0.418	234.84	18.4	0	1	17	2006-12-16 17:24:00
  5.360	0.436	233.63	23.0	0	1	16	2006-12-16 17:25:00
  5.374	0.498	233.29	23.0	0	2	17	2006-12-16 17:26:00
  5.388	0.502	233.74	23.0	0	1	17	2006-12-16 17:27:00
  3.666	0.528	235.68	15.8	0	1	17	2006-12-16 17:28:00
  3.520	0.522	235.02	15.0	0	2	17	2006-12-16 17:29:00
  ```

**Ignoring potential issue wrt timezones. Assuming UTC.**

Conversion of date and time columns from character to POSIXct:
```r
df <- df %>% mutate(datetime = dmy_hms(paste(Date, Time))) %>% select(-Date, -Time)
```


## Filter data from the dates 2007-02-01 and 2007-02-02.

```r
df <- filter(df, datetime >= ymd("2007-02-01") & datetime < ymd("2007-02-03"))
```

Make sure that worked:
```r
head(df)
tail(df)
```
- Output:
  ```
  Global_active_power	Global_reactive_power	Voltage	Global_intensity	Sub_metering_1	Sub_metering_2	Sub_metering_3	datetime
  0.326	0.128	243.15	1.4	0	0	0	2007-02-01 00:00:00
  0.326	0.130	243.32	1.4	0	0	0	2007-02-01 00:01:00
  0.324	0.132	243.51	1.4	0	0	0	2007-02-01 00:02:00
  0.324	0.134	243.90	1.4	0	0	0	2007-02-01 00:03:00
  0.322	0.130	243.16	1.4	0	0	0	2007-02-01 00:04:00
  0.320	0.126	242.29	1.4	0	0	0	2007-02-01 00:05:00
  
  Global_active_power	Global_reactive_power	Voltage	Global_intensity	Sub_metering_1	Sub_metering_2	Sub_metering_3	datetime
  2875	3.696	0.226	240.71	15.2	0	1	17	2007-02-02 23:54:00
  2876	3.696	0.226	240.90	15.2	0	1	18	2007-02-02 23:55:00
  2877	3.698	0.226	241.02	15.2	0	2	18	2007-02-02 23:56:00
  2878	3.684	0.224	240.48	15.2	0	1	18	2007-02-02 23:57:00
  2879	3.658	0.220	239.61	15.2	0	1	17	2007-02-02 23:58:00
  2880	3.680	0.224	240.37	15.2	0	2	18	2007-02-02 23:59:00
  ```
  
  
## Plot.

### Histogram of global active power.

```r
hist(df$Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red")
```
- **Note: initially the resulting histogram doesn't match that of Peng.**
  - Since the frequencies are about halved, I'm probably missing a day of data.
  - I notice that my final entry has timestamp "2007-02-02 00:00:00", meaning I have only one day of data.
  - My original datetime filter looked like this:
    ```r
    df <- filter(df, datetime >= ymd("2007-02-01") & datetime <= ymd("2007-02-02"))
    ```
  - The revised filter looks like so:
    ```r
    df <- filter(df, datetime >= ymd("2007-02-01") & datetime < ymd("2007-02-03"))
    ```
  - Now the resulting histogram is a good match with Peng's.


### Plot of weekday versus global active power.

```r
weekday_vs_global_active_power <- function(df){
  with(df, plot(datetime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
}
weekday_vs_global_active_power(df)
```
- The result is a good match with Peng's plot.


### Plot of weekday versus sub metering.

```r
weekday_vs_sub_metering <- function(df){  
  with(df, {
    plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black")
    lines(datetime, Sub_metering_2, col = "red")
    lines(datetime, Sub_metering_3, col = "blue")
    legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  })
}
weekday_vs_sub_metering(df)
```
- Result is good match with Peng's.


### Plot of weekday versus voltage.

```r
weekday_vs_voltage <- function(df){  
  with(df, plot(datetime, Voltage, type = "l"))
}
weekday_vs_voltage(df)
```
- Good match with Peng's.


### Plot of weekday versus global reactive power.

```r
weekday_vs_global_reactive_power <- function(df){  
  with(df, plot(datetime, Global_reactive_power, type = "l"))
}
weekday_vs_global_reactive_power(df)
```
- Good match with Peng's.


### Panel of last four plots.


```r
par(mfcol = c(2,2))
with(df, {
  weekday_vs_global_active_power(df)
  weekday_vs_sub_metering(df)
  weekday_vs_voltage(df)
  weekday_vs_global_reactive_power(df)
})
```
- Good match with Peng's.


## Moved code to required R files... Verify each separately.

```python
! rm -fr raw_data household_power_consumption.txt *.png
```
```r
rm(list = ls())
source("plot1.R")
```

```python
! rm -fr raw_data household_power_consumption.txt *.png
```
```r
rm(list = ls())
source("plot2.R")
```

```python
! rm -fr raw_data household_power_consumption.txt *.png
```
```r
rm(list = ls())
source("plot3.R")
```

```python
! rm -fr raw_data household_power_consumption.txt *.png
```
```r
rm(list = ls())
source("plot4.R")
```


## All code verified manually. Generate all plots files.

```r
rm(list = ls())
source("plot1.R")
rm(list = ls())
source("plot2.R")
rm(list = ls())
source("plot3.R")
rm(list = ls())
source("plot4.R")
```
