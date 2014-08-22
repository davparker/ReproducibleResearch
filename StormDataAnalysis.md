---
title: "NOAA Storm Data Analysis on Population Health" 
author: "David Parker"
date: "Friday, August 22, 2014"
output: html_document
keep_md: true
---

#Synopsis  

Analyzing US Storm Data to demonstrate the human health in areas where damage occurred.

##Loading and Processing the Raw Data

Using [Storm Data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2) from the U.S. National Oceanic and Atmospheric Administration’s (NOAA) storm database, we analyze conditions that impact the health of human populations throughout the US.

##Data Processing  

###Downloading and reading a small sample of the data for column names and early classification.  

```r
# clear the environment
rm(list=ls())
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", 
              temp, method = "auto", mode = "wb")
sdata <- read.table(bzfile(temp), comment.char = "#", header = TRUE, sep = ",", nrows = 10, 
                    na.strings = "", )
dim(sdata)
```

```
## [1] 10 37
```

```r
cnames <- names(sdata)

cnames
```

```
##  [1] "STATE__"    "BGN_DATE"   "BGN_TIME"   "TIME_ZONE"  "COUNTY"    
##  [6] "COUNTYNAME" "STATE"      "EVTYPE"     "BGN_RANGE"  "BGN_AZI"   
## [11] "BGN_LOCATI" "END_DATE"   "END_TIME"   "COUNTY_END" "COUNTYENDN"
## [16] "END_RANGE"  "END_AZI"    "END_LOCATI" "LENGTH"     "WIDTH"     
## [21] "F"          "MAG"        "FATALITIES" "INJURIES"   "PROPDMG"   
## [26] "PROPDMGEXP" "CROPDMG"    "CROPDMGEXP" "WFO"        "STATEOFFIC"
## [31] "ZONENAMES"  "LATITUDE"   "LONGITUDE"  "LATITUDE_E" "LONGITUDE_"
## [36] "REMARKS"    "REFNUM"
```

```r
cnames <- sub("__", "1", cnames, fixed = TRUE)
cnames
```

```
##  [1] "STATE1"     "BGN_DATE"   "BGN_TIME"   "TIME_ZONE"  "COUNTY"    
##  [6] "COUNTYNAME" "STATE"      "EVTYPE"     "BGN_RANGE"  "BGN_AZI"   
## [11] "BGN_LOCATI" "END_DATE"   "END_TIME"   "COUNTY_END" "COUNTYENDN"
## [16] "END_RANGE"  "END_AZI"    "END_LOCATI" "LENGTH"     "WIDTH"     
## [21] "F"          "MAG"        "FATALITIES" "INJURIES"   "PROPDMG"   
## [26] "PROPDMGEXP" "CROPDMG"    "CROPDMGEXP" "WFO"        "STATEOFFIC"
## [31] "ZONENAMES"  "LATITUDE"   "LONGITUDE"  "LATITUDE_E" "LONGITUDE_"
## [36] "REMARKS"    "REFNUM"
```

```r
names(sdata) <- cnames
head(sdata[1:10], 3)
```

```
##   STATE1          BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1      1 4/18/1950 0:00:00      130       CST     97     MOBILE    AL
## 2      1 4/18/1950 0:00:00      145       CST      3    BALDWIN    AL
## 3      1 2/20/1951 0:00:00     1600       CST     57    FAYETTE    AL
##    EVTYPE BGN_RANGE BGN_AZI
## 1 TORNADO         0      NA
## 2 TORNADO         0      NA
## 3 TORNADO         0      NA
```

```r
head(sdata[11:20], 3)
```

```
##   BGN_LOCATI END_DATE END_TIME COUNTY_END COUNTYENDN END_RANGE END_AZI
## 1         NA       NA       NA          0         NA         0      NA
## 2         NA       NA       NA          0         NA         0      NA
## 3         NA       NA       NA          0         NA         0      NA
##   END_LOCATI LENGTH WIDTH
## 1         NA   14.0   100
## 2         NA    2.0   150
## 3         NA    0.1   123
```

```r
head(sdata[21:30], 3)
```

```
##   F MAG FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO
## 1 3   0          0       15    25.0          K       0         NA  NA
## 2 2   0          0        0     2.5          K       0         NA  NA
## 3 2   0          0        2    25.0          K       0         NA  NA
##   STATEOFFIC
## 1         NA
## 2         NA
## 3         NA
```

```r
head(sdata[31:37], 3)
```

```
##   ZONENAMES LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1        NA     3040      8812       3051       8806      NA      1
## 2        NA     3042      8755          0          0      NA      2
## 3        NA     3340      8742          0          0      NA      3
```

```r
str(sdata)
```

```
## 'data.frame':	10 obs. of  37 variables:
##  $ STATE1    : num  1 1 1 1 1 1 1 1 1 1
##  $ BGN_DATE  : Factor w/ 7 levels "1/22/1952 0:00:00",..: 6 6 5 7 2 2 3 1 4 4
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000
##  $ TIME_ZONE : Factor w/ 1 level "CST": 1 1 1 1 1 1 1 1 1 1
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57
##  $ COUNTYNAME: Factor w/ 9 levels "BALDWIN","BLOUNT",..: 7 1 4 6 3 5 2 8 9 4
##  $ STATE     : Factor w/ 1 level "AL": 1 1 1 1 1 1 1 1 1 1
##  $ EVTYPE    : Factor w/ 1 level "TORNADO": 1 1 1 1 1 1 1 1 1 1
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0
##  $ BGN_AZI   : logi  NA NA NA NA NA NA ...
##  $ BGN_LOCATI: logi  NA NA NA NA NA NA ...
##  $ END_DATE  : logi  NA NA NA NA NA NA ...
##  $ END_TIME  : logi  NA NA NA NA NA NA ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0
##  $ END_AZI   : logi  NA NA NA NA NA NA ...
##  $ END_LOCATI: logi  NA NA NA NA NA NA ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100
##  $ F         : int  3 2 2 2 2 2 2 1 3 3
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25
##  $ PROPDMGEXP: Factor w/ 1 level "K": 1 1 1 1 1 1 1 1 1 1
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0
##  $ CROPDMGEXP: logi  NA NA NA NA NA NA ...
##  $ WFO       : logi  NA NA NA NA NA NA ...
##  $ STATEOFFIC: logi  NA NA NA NA NA NA ...
##  $ ZONENAMES : logi  NA NA NA NA NA NA ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : logi  NA NA NA NA NA NA ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10
```

__Read a bigger chunk of the data__  :
Some of the column classes are not interpreted correctly. Read in a larger chunk of data as character classes then reclassify the columns after examination.  

```r
sdata <- read.table(bzfile(temp), comment.char = "#", header = TRUE, sep = ",", nrows = 1000,
                    colClasses = "character", na.strings = "", )
```

```
## Warning: cannot open bzip2-ed file
## 'C:\Users\David\AppData\Local\Temp\Rtmpau1TtL\file21d47d44193', probable
## reason 'No such file or directory'
```

```
## Error: cannot open the connection
```

```r
names(sdata) <- cnames
# Examine header with new names
head(sdata[1:10], 3)
```

```
##   STATE1          BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1      1 4/18/1950 0:00:00      130       CST     97     MOBILE    AL
## 2      1 4/18/1950 0:00:00      145       CST      3    BALDWIN    AL
## 3      1 2/20/1951 0:00:00     1600       CST     57    FAYETTE    AL
##    EVTYPE BGN_RANGE BGN_AZI
## 1 TORNADO         0      NA
## 2 TORNADO         0      NA
## 3 TORNADO         0      NA
```

```r
head(sdata[11:20], 3)
```

```
##   BGN_LOCATI END_DATE END_TIME COUNTY_END COUNTYENDN END_RANGE END_AZI
## 1         NA       NA       NA          0         NA         0      NA
## 2         NA       NA       NA          0         NA         0      NA
## 3         NA       NA       NA          0         NA         0      NA
##   END_LOCATI LENGTH WIDTH
## 1         NA   14.0   100
## 2         NA    2.0   150
## 3         NA    0.1   123
```

```r
head(sdata[21:30], 3)
```

```
##   F MAG FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO
## 1 3   0          0       15    25.0          K       0         NA  NA
## 2 2   0          0        0     2.5          K       0         NA  NA
## 3 2   0          0        2    25.0          K       0         NA  NA
##   STATEOFFIC
## 1         NA
## 2         NA
## 3         NA
```

```r
head(sdata[31:37], 3)
```

```
##   ZONENAMES LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1        NA     3040      8812       3051       8806      NA      1
## 2        NA     3042      8755          0          0      NA      2
## 3        NA     3340      8742          0          0      NA      3
```

```r
# 37 cols,  build appropriate column classes 10 at a time
cclasses <- c("factor", "Date", rep("character", 2), "numeric", "character", rep("factor", 2), "numeric", "factor", 
              rep("character", 3), "numeric", "character", "numeric", "factor", "character", rep("numeric", 2),
              "factor", rep("numeric", 4), "character", "numeric", "factor",  rep("character", 2),
              rep("character", 7))
cclasses              
```

```
##  [1] "factor"    "Date"      "character" "character" "numeric"  
##  [6] "character" "factor"    "factor"    "numeric"   "factor"   
## [11] "character" "character" "character" "numeric"   "character"
## [16] "numeric"   "factor"    "character" "numeric"   "numeric"  
## [21] "factor"    "numeric"   "numeric"   "numeric"   "numeric"  
## [26] "character" "numeric"   "factor"    "character" "character"
## [31] "character" "character" "character" "character" "character"
## [36] "character" "character"
```

__Read entire dataset__

```r
library(Defaults)
# change default date format for data load
setDefaults('as.Date.character', format = '%m/%d/%Y')
sdata <- read.table(bzfile(temp), comment.char = "#", header = TRUE, sep = ",",
                    colClasses = cclasses, na.strings = "")
```

```
## Warning: cannot open bzip2-ed file
## 'C:\Users\David\AppData\Local\Temp\Rtmpau1TtL\file21d47d44193', probable
## reason 'No such file or directory'
```

```
## Error: cannot open the connection
```

```r
names(sdata) <- cnames
dim(sdata)
```

```
## [1] 10 37
```

```r
summary(sdata)
```

```
## Warning: closing unused connection 5
## (C:\Users\David\AppData\Local\Temp\Rtmpau1TtL\file21d47d44193)
```

```
##      STATE1                BGN_DATE    BGN_TIME    TIME_ZONE
##  Min.   :1   1/22/1952 0:00:00 :1   Min.   : 100   CST:10   
##  1st Qu.:1   11/15/1951 0:00:00:2   1st Qu.: 334            
##  Median :1   11/16/1951 0:00:00:1   Median :1200            
##  Mean   :1   2/13/1952 0:00:00 :2   Mean   :1128            
##  3rd Qu.:1   2/20/1951 0:00:00 :1   3rd Qu.:1900            
##  Max.   :1   4/18/1950 0:00:00 :2   Max.   :2000            
##              6/8/1951 0:00:00  :1                           
##      COUNTY           COUNTYNAME STATE       EVTYPE     BGN_RANGE
##  Min.   :  3.0   FAYETTE   :2    AL:10   TORNADO:10   Min.   :0  
##  1st Qu.: 46.5   BALDWIN   :1                         1st Qu.:0  
##  Median : 67.0   BLOUNT    :1                         Median :0  
##  Mean   : 68.0   CULLMAN   :1                         Mean   :0  
##  3rd Qu.: 95.0   LAUDERDALE:1                         3rd Qu.:0  
##  Max.   :125.0   MADISON   :1                         Max.   :0  
##                  (Other)   :3                                    
##  BGN_AZI        BGN_LOCATI     END_DATE       END_TIME         COUNTY_END
##  Mode:logical   Mode:logical   Mode:logical   Mode:logical   Min.   :0   
##  NA's:10        NA's:10        NA's:10        NA's:10        1st Qu.:0   
##                                                              Median :0   
##                                                              Mean   :0   
##                                                              3rd Qu.:0   
##                                                              Max.   :0   
##                                                                          
##  COUNTYENDN       END_RANGE END_AZI        END_LOCATI         LENGTH      
##  Mode:logical   Min.   :0   Mode:logical   Mode:logical   Min.   : 0.000  
##  NA's:10        1st Qu.:0   NA's:10        NA's:10        1st Qu.: 0.025  
##                 Median :0                                 Median : 1.500  
##                 Mean   :0                                 Mean   : 2.470  
##                 3rd Qu.:0                                 3rd Qu.: 2.225  
##                 Max.   :0                                 Max.   :14.000  
##                                                                           
##      WIDTH           F             MAG      FATALITIES     INJURIES    
##  Min.   : 33   Min.   :1.00   Min.   :0   Min.   :0.0   Min.   : 0.00  
##  1st Qu.:100   1st Qu.:2.00   1st Qu.:0   1st Qu.:0.0   1st Qu.: 0.25  
##  Median :100   Median :2.00   Median :0   Median :0.0   Median : 2.00  
##  Mean   :107   Mean   :2.20   Mean   :0   Mean   :0.1   Mean   : 4.20  
##  3rd Qu.:143   3rd Qu.:2.75   3rd Qu.:0   3rd Qu.:0.0   3rd Qu.: 5.00  
##  Max.   :177   Max.   :3.00   Max.   :0   Max.   :1.0   Max.   :15.00  
##                                                                        
##     PROPDMG     PROPDMGEXP    CROPDMG  CROPDMGEXP       WFO         
##  Min.   : 2.5   K:10       Min.   :0   Mode:logical   Mode:logical  
##  1st Qu.: 2.5              1st Qu.:0   NA's:10        NA's:10       
##  Median : 2.5              Median :0                                
##  Mean   :11.5              Mean   :0                                
##  3rd Qu.:25.0              3rd Qu.:0                                
##  Max.   :25.0              Max.   :0                                
##                                                                     
##  STATEOFFIC     ZONENAMES         LATITUDE      LONGITUDE   
##  Mode:logical   Mode:logical   Min.   :3040   Min.   :8558  
##  NA's:10        NA's:10        1st Qu.:3275   1st Qu.:8634  
##                                Median :3338   Median :8739  
##                                Mean   :3307   Mean   :8699  
##                                3rd Qu.:3410   3rd Qu.:8746  
##                                Max.   :3458   Max.   :8812  
##                                                             
##    LATITUDE_E     LONGITUDE_   REMARKS            REFNUM     
##  Min.   :   0   Min.   :   0   Mode:logical   Min.   : 1.00  
##  1st Qu.:   0   1st Qu.:   0   NA's:10        1st Qu.: 3.25  
##  Median :   0   Median :   0                  Median : 5.50  
##  Mean   : 972   Mean   :2628                  Mean   : 5.50  
##  3rd Qu.:2288   3rd Qu.:6553                  3rd Qu.: 7.75  
##  Max.   :3337   Max.   :8806                  Max.   :10.00  
## 
```

```r
str(sdata)
```

```
## 'data.frame':	10 obs. of  37 variables:
##  $ STATE1    : num  1 1 1 1 1 1 1 1 1 1
##  $ BGN_DATE  : Factor w/ 7 levels "1/22/1952 0:00:00",..: 6 6 5 7 2 2 3 1 4 4
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000
##  $ TIME_ZONE : Factor w/ 1 level "CST": 1 1 1 1 1 1 1 1 1 1
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57
##  $ COUNTYNAME: Factor w/ 9 levels "BALDWIN","BLOUNT",..: 7 1 4 6 3 5 2 8 9 4
##  $ STATE     : Factor w/ 1 level "AL": 1 1 1 1 1 1 1 1 1 1
##  $ EVTYPE    : Factor w/ 1 level "TORNADO": 1 1 1 1 1 1 1 1 1 1
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0
##  $ BGN_AZI   : logi  NA NA NA NA NA NA ...
##  $ BGN_LOCATI: logi  NA NA NA NA NA NA ...
##  $ END_DATE  : logi  NA NA NA NA NA NA ...
##  $ END_TIME  : logi  NA NA NA NA NA NA ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0
##  $ END_AZI   : logi  NA NA NA NA NA NA ...
##  $ END_LOCATI: logi  NA NA NA NA NA NA ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100
##  $ F         : int  3 2 2 2 2 2 2 1 3 3
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25
##  $ PROPDMGEXP: Factor w/ 1 level "K": 1 1 1 1 1 1 1 1 1 1
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0
##  $ CROPDMGEXP: logi  NA NA NA NA NA NA ...
##  $ WFO       : logi  NA NA NA NA NA NA ...
##  $ STATEOFFIC: logi  NA NA NA NA NA NA ...
##  $ ZONENAMES : logi  NA NA NA NA NA NA ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : logi  NA NA NA NA NA NA ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10
```

```r
# Data is loaded, drop the temp compressed file
unlink(temp)
```

__Make date fields__

```r
# compare dates for initial date concatenation
head(sdata[, c(2:4)])
```

```
##             BGN_DATE BGN_TIME TIME_ZONE
## 1  4/18/1950 0:00:00      130       CST
## 2  4/18/1950 0:00:00      145       CST
## 3  2/20/1951 0:00:00     1600       CST
## 4   6/8/1951 0:00:00      900       CST
## 5 11/15/1951 0:00:00     1500       CST
## 6 11/15/1951 0:00:00     2000       CST
```

```r
sdata$BD <- 
  as.POSIXct(
    paste(
      as.POSIXct(sdata$BGN_DATE, format="%Y/%m/%d")
      , sdata$BGN_TIME)
    ,format=  "%Y-%m-%d %H:%M:%S")

sdata$BD[1:10]
```

```
##  [1] NA NA NA NA NA NA NA NA NA NA
```

```r
# compare dates for time correction
head(sdata[, c(2:4, 38)])
```

```
##             BGN_DATE BGN_TIME TIME_ZONE   BD
## 1  4/18/1950 0:00:00      130       CST <NA>
## 2  4/18/1950 0:00:00      145       CST <NA>
## 3  2/20/1951 0:00:00     1600       CST <NA>
## 4   6/8/1951 0:00:00      900       CST <NA>
## 5 11/15/1951 0:00:00     1500       CST <NA>
## 6 11/15/1951 0:00:00     2000       CST <NA>
```

```r
# add timezone field and create clean BEGIN_DATE
sdata$BEGIN_DATE <- 
  as.POSIXct( paste(sdata$BD, sdata$TIME_ZONE) 
              , format=  "%Y-%m-%d %H:%M:%S")
# verify new date column
sdata$BEGIN_DATE[1:10]
```

```
##  [1] NA NA NA NA NA NA NA NA NA NA
```

```r
class(sdata$BEGIN_DATE)
```

```
## [1] "POSIXct" "POSIXt"
```

```r
head(sdata[, c(2:4, 39)])
```

```
##             BGN_DATE BGN_TIME TIME_ZONE BEGIN_DATE
## 1  4/18/1950 0:00:00      130       CST       <NA>
## 2  4/18/1950 0:00:00      145       CST       <NA>
## 3  2/20/1951 0:00:00     1600       CST       <NA>
## 4   6/8/1951 0:00:00      900       CST       <NA>
## 5 11/15/1951 0:00:00     1500       CST       <NA>
## 6 11/15/1951 0:00:00     2000       CST       <NA>
```

```r
# place BEGIN_DATE in appropiate position
sdata <- sdata[, c(1, 39, 2:37)]
str(sdata)
```

```
## 'data.frame':	10 obs. of  38 variables:
##  $ STATE1    : num  1 1 1 1 1 1 1 1 1 1
##  $ BEGIN_DATE: POSIXct, format: NA NA ...
##  $ BGN_DATE  : Factor w/ 7 levels "1/22/1952 0:00:00",..: 6 6 5 7 2 2 3 1 4 4
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000
##  $ TIME_ZONE : Factor w/ 1 level "CST": 1 1 1 1 1 1 1 1 1 1
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57
##  $ COUNTYNAME: Factor w/ 9 levels "BALDWIN","BLOUNT",..: 7 1 4 6 3 5 2 8 9 4
##  $ STATE     : Factor w/ 1 level "AL": 1 1 1 1 1 1 1 1 1 1
##  $ EVTYPE    : Factor w/ 1 level "TORNADO": 1 1 1 1 1 1 1 1 1 1
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0
##  $ BGN_AZI   : logi  NA NA NA NA NA NA ...
##  $ BGN_LOCATI: logi  NA NA NA NA NA NA ...
##  $ END_DATE  : logi  NA NA NA NA NA NA ...
##  $ END_TIME  : logi  NA NA NA NA NA NA ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0
##  $ END_AZI   : logi  NA NA NA NA NA NA ...
##  $ END_LOCATI: logi  NA NA NA NA NA NA ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100
##  $ F         : int  3 2 2 2 2 2 2 1 3 3
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25
##  $ PROPDMGEXP: Factor w/ 1 level "K": 1 1 1 1 1 1 1 1 1 1
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0
##  $ CROPDMGEXP: logi  NA NA NA NA NA NA ...
##  $ WFO       : logi  NA NA NA NA NA NA ...
##  $ STATEOFFIC: logi  NA NA NA NA NA NA ...
##  $ ZONENAMES : logi  NA NA NA NA NA NA ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : logi  NA NA NA NA NA NA ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10
```

```r
dim(sdata)
```

```
## [1] 10 38
```


##Results  

These are the results.
