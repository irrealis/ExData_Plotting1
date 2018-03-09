# Project notes

Notebook for week-1 project, Coursera Course "Exploratory Data Analysis", "Data Science" track, Johns Hopkins University.

See [README.md](./README.md) for more details.

## R version and platform used

```r
print(version)
```
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

## Getting the data

Create data dir if missing.
```r
if(!file.exists("raw_data")){
  dir.create("raw_data")
}
```

Get raw data if missing.
```r
raw_file_path <- file.path("raw_data", "household_power_consumption.zip")
if(!file.exists(raw_file_path)){
  download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
    destfile = raw_file_path,
    method = "curl"
  )
}
```
