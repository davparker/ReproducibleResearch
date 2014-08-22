---
title: "NOAA Storm Analysis on Population Health" 
author: "David Parker"
date: "Friday, August 22, 2014"
output: html_document
keep_md: true
---

#Synopsis  

Analyzing US Storm Data to demonstrate the human health in areas where damage occurred.

#Loading and Processing the Raw Data

Using [Storm Data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2) from the U.S. National Oceanic and Atmospheric Administration’s (NOAA) storm database, we analyze conditions that impact the health of human populations throughout the US.

###Data Processing  

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

##Read a bigger chunk of the data  

Some of the column classes are not interpreted correctly. Read in a larger chunk of data as character classes then reclassify the columns after examination.  


```r
sdata <- read.table(bzfile(temp), comment.char = "#", header = TRUE, sep = ",", nrows = 1000,
                    colClasses = "character", na.strings = "", )
names(sdata) <- cnames
# Examine header with new names
head(sdata[1:10], 3)
```

```
##   STATE1          BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1   1.00 4/18/1950 0:00:00     0130       CST  97.00     MOBILE    AL
## 2   1.00 4/18/1950 0:00:00     0145       CST   3.00    BALDWIN    AL
## 3   1.00 2/20/1951 0:00:00     1600       CST  57.00    FAYETTE    AL
##    EVTYPE BGN_RANGE BGN_AZI
## 1 TORNADO      0.00    <NA>
## 2 TORNADO      0.00    <NA>
## 3 TORNADO      0.00    <NA>
```

```r
head(sdata[11:20], 3)
```

```
##   BGN_LOCATI END_DATE END_TIME COUNTY_END COUNTYENDN END_RANGE END_AZI
## 1       <NA>     <NA>     <NA>       0.00       <NA>      0.00    <NA>
## 2       <NA>     <NA>     <NA>       0.00       <NA>      0.00    <NA>
## 3       <NA>     <NA>     <NA>       0.00       <NA>      0.00    <NA>
##   END_LOCATI LENGTH  WIDTH
## 1       <NA>  14.00 100.00
## 2       <NA>   2.00 150.00
## 3       <NA>   0.10 123.00
```

```r
head(sdata[21:30], 3)
```

```
##   F  MAG FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP  WFO
## 1 3 0.00       0.00    15.00   25.00          K    0.00       <NA> <NA>
## 2 2 0.00       0.00     0.00    2.50          K    0.00       <NA> <NA>
## 3 2 0.00       0.00     2.00   25.00          K    0.00       <NA> <NA>
##   STATEOFFIC
## 1       <NA>
## 2       <NA>
## 3       <NA>
```

```r
head(sdata[31:37], 3)
```

```
##   ZONENAMES LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1      <NA>  3040.00   8812.00    3051.00    8806.00    <NA>   1.00
## 2      <NA>  3042.00   8755.00       0.00       0.00    <NA>   2.00
## 3      <NA>  3340.00   8742.00       0.00       0.00    <NA>   3.00
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
                    colClasses = cclasses, na.strings = "", )
names(sdata) <- cnames
dim(sdata)
```

```
## [1] 902297     37
```

```r
summary(sdata)
```

```
##      STATE1          BGN_DATE            BGN_TIME        
##  48.00  : 83728   Min.   :1950-01-03   Length:902297     
##  20.00  : 53441   1st Qu.:1995-04-20   Class :character  
##  40.00  : 46802   Median :2002-03-18   Mode  :character  
##  29.00  : 35648   Mean   :1998-12-27                     
##  19.00  : 31069   3rd Qu.:2007-07-28                     
##  31.00  : 30271   Max.   :2011-11-30                     
##  (Other):621338                                          
##   TIME_ZONE             COUNTY     COUNTYNAME            STATE       
##  Length:902297      Min.   :  0   Length:902297      TX     : 83728  
##  Class :character   1st Qu.: 31   Class :character   KS     : 53440  
##  Mode  :character   Median : 75   Mode  :character   OK     : 46802  
##                     Mean   :101                      MO     : 35648  
##                     3rd Qu.:131                      IA     : 31069  
##                     Max.   :873                      NE     : 30271  
##                                                      (Other):621339  
##                EVTYPE         BGN_RANGE       BGN_AZI      
##  HAIL             :288661   Min.   :   0   N      : 86752  
##  TSTM WIND        :219940   1st Qu.:   0   W      : 38446  
##  THUNDERSTORM WIND: 82563   Median :   0   S      : 37558  
##  TORNADO          : 60652   Mean   :   1   E      : 33178  
##  FLASH FLOOD      : 54277   3rd Qu.:   1   NW     : 24041  
##  FLOOD            : 25326   Max.   :3749   (Other):134990  
##  (Other)          :170878                  NA's   :547332  
##   BGN_LOCATI          END_DATE           END_TIME           COUNTY_END
##  Length:902297      Length:902297      Length:902297      Min.   :0   
##  Class :character   Class :character   Class :character   1st Qu.:0   
##  Mode  :character   Mode  :character   Mode  :character   Median :0   
##                                                           Mean   :0   
##                                                           3rd Qu.:0   
##                                                           Max.   :0   
##                                                                       
##   COUNTYENDN          END_RANGE      END_AZI        END_LOCATI       
##  Length:902297      Min.   :  0   N      : 28082   Length:902297     
##  Class :character   1st Qu.:  0   S      : 22510   Class :character  
##  Mode  :character   Median :  0   W      : 20119   Mode  :character  
##                     Mean   :  1   E      : 20047                     
##                     3rd Qu.:  0   NE     : 14606                     
##                     Max.   :925   (Other): 72096                     
##                                   NA's   :724837                     
##      LENGTH           WIDTH         F               MAG       
##  Min.   :   0.0   Min.   :   0   0   : 24993   Min.   :    0  
##  1st Qu.:   0.0   1st Qu.:   0   1   : 19475   1st Qu.:    0  
##  Median :   0.0   Median :   0   2   :  9878   Median :   50  
##  Mean   :   0.2   Mean   :   8   3   :  3179   Mean   :   47  
##  3rd Qu.:   0.0   3rd Qu.:   0   4   :  1072   3rd Qu.:   75  
##  Max.   :2315.0   Max.   :4400   5   :   137   Max.   :22000  
##                                  NA's:843563                  
##    FATALITIES     INJURIES         PROPDMG      PROPDMGEXP       
##  Min.   :  0   Min.   :   0.0   Min.   :   0   Length:902297     
##  1st Qu.:  0   1st Qu.:   0.0   1st Qu.:   0   Class :character  
##  Median :  0   Median :   0.0   Median :   0   Mode  :character  
##  Mean   :  0   Mean   :   0.2   Mean   :  12                     
##  3rd Qu.:  0   3rd Qu.:   0.0   3rd Qu.:   0                     
##  Max.   :583   Max.   :1700.0   Max.   :5000                     
##                                                                  
##     CROPDMG        CROPDMGEXP         WFO             STATEOFFIC       
##  Min.   :  0.0   K      :281832   Length:902297      Length:902297     
##  1st Qu.:  0.0   M      :  1994   Class :character   Class :character  
##  Median :  0.0   k      :    21   Mode  :character   Mode  :character  
##  Mean   :  1.5   0      :    19                                        
##  3rd Qu.:  0.0   B      :     9                                        
##  Max.   :990.0   (Other):     9                                        
##                  NA's   :618413                                        
##   ZONENAMES           LATITUDE          LONGITUDE        
##  Length:902297      Length:902297      Length:902297     
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##                                                          
##                                                          
##                                                          
##                                                          
##   LATITUDE_E         LONGITUDE_          REMARKS         
##  Length:902297      Length:902297      Length:902297     
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##                                                          
##                                                          
##                                                          
##                                                          
##     REFNUM         
##  Length:902297     
##  Class :character  
##  Mode  :character  
##                    
##                    
##                    
## 
```

```r
str(sdata)
```

```
## 'data.frame':	902297 obs. of  37 variables:
##  $ STATE1    : Factor w/ 70 levels "1.00","10.00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : Date, format: "1950-04-18" "1950-04-18" ...
##  $ BGN_TIME  : chr  "0130" "0145" "1600" "0900" ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : Factor w/ 34 levels "  N"," NW","E",..: NA NA NA NA NA NA NA NA NA NA ...
##  $ BGN_LOCATI: chr  NA NA NA NA ...
##  $ END_DATE  : chr  NA NA NA NA ...
##  $ END_TIME  : chr  NA NA NA NA ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: chr  NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : Factor w/ 23 levels "E","ENE","ESE",..: NA NA NA NA NA NA NA NA NA NA ...
##  $ END_LOCATI: chr  NA NA NA NA ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : Factor w/ 6 levels "0","1","2","3",..: 4 3 3 3 3 3 3 2 4 4 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: chr  "K" "K" "K" "K" ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: Factor w/ 8 levels "?","0","2","B",..: NA NA NA NA NA NA NA NA NA NA ...
##  $ WFO       : chr  NA NA NA NA ...
##  $ STATEOFFIC: chr  NA NA NA NA ...
##  $ ZONENAMES : chr  NA NA NA NA ...
##  $ LATITUDE  : chr  "3040.00" "3042.00" "3340.00" "3458.00" ...
##  $ LONGITUDE : chr  "8812.00" "8755.00" "8742.00" "8626.00" ...
##  $ LATITUDE_E: chr  "3051.00" "0.00" "0.00" "0.00" ...
##  $ LONGITUDE_: chr  "8806.00" "0.00" "0.00" "0.00" ...
##  $ REMARKS   : chr  NA NA NA NA ...
##  $ REFNUM    : chr  "1.00" "2.00" "3.00" "4.00" ...
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
##     BGN_DATE BGN_TIME TIME_ZONE
## 1 1950-04-18     0130       CST
## 2 1950-04-18     0145       CST
## 3 1951-02-20     1600       CST
## 4 1951-06-08     0900       CST
## 5 1951-11-15     1500       CST
## 6 1951-11-15     2000       CST
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
##  [1] "1950-04-17 18:00:00 CST" "1950-04-17 18:00:00 CST"
##  [3] "1951-02-19 18:00:00 CST" "1951-06-07 19:00:00 CDT"
##  [5] "1951-11-14 18:00:00 CST" "1951-11-14 18:00:00 CST"
##  [7] "1951-11-15 18:00:00 CST" "1952-01-21 18:00:00 CST"
##  [9] "1952-02-12 18:00:00 CST" "1952-02-12 18:00:00 CST"
```

```r
# compare dates for time correction
head(sdata[, c(2:4, 38)])
```

```
##     BGN_DATE BGN_TIME TIME_ZONE                  BD
## 1 1950-04-18     0130       CST 1950-04-17 18:00:00
## 2 1950-04-18     0145       CST 1950-04-17 18:00:00
## 3 1951-02-20     1600       CST 1951-02-19 18:00:00
## 4 1951-06-08     0900       CST 1951-06-07 19:00:00
## 5 1951-11-15     1500       CST 1951-11-14 18:00:00
## 6 1951-11-15     2000       CST 1951-11-14 18:00:00
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
##  [1] "1950-04-17 18:00:00 CST" "1950-04-17 18:00:00 CST"
##  [3] "1951-02-19 18:00:00 CST" "1951-06-07 19:00:00 CDT"
##  [5] "1951-11-14 18:00:00 CST" "1951-11-14 18:00:00 CST"
##  [7] "1951-11-15 18:00:00 CST" "1952-01-21 18:00:00 CST"
##  [9] "1952-02-12 18:00:00 CST" "1952-02-12 18:00:00 CST"
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
##     BGN_DATE BGN_TIME TIME_ZONE          BEGIN_DATE
## 1 1950-04-18     0130       CST 1950-04-17 18:00:00
## 2 1950-04-18     0145       CST 1950-04-17 18:00:00
## 3 1951-02-20     1600       CST 1951-02-19 18:00:00
## 4 1951-06-08     0900       CST 1951-06-07 19:00:00
## 5 1951-11-15     1500       CST 1951-11-14 18:00:00
## 6 1951-11-15     2000       CST 1951-11-14 18:00:00
```

```r
# place BEGIN_DATE in appropiate position
sdata <- sdata[, c(1, 39, 2:37)]
str(sdata)
```

```
## 'data.frame':	902297 obs. of  38 variables:
##  $ STATE1    : Factor w/ 70 levels "1.00","10.00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BEGIN_DATE: POSIXct, format: "1950-04-17 18:00:00" "1950-04-17 18:00:00" ...
##  $ BGN_DATE  : Date, format: "1950-04-18" "1950-04-18" ...
##  $ BGN_TIME  : chr  "0130" "0145" "1600" "0900" ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : Factor w/ 34 levels "  N"," NW","E",..: NA NA NA NA NA NA NA NA NA NA ...
##  $ BGN_LOCATI: chr  NA NA NA NA ...
##  $ END_DATE  : chr  NA NA NA NA ...
##  $ END_TIME  : chr  NA NA NA NA ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: chr  NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : Factor w/ 23 levels "E","ENE","ESE",..: NA NA NA NA NA NA NA NA NA NA ...
##  $ END_LOCATI: chr  NA NA NA NA ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : Factor w/ 6 levels "0","1","2","3",..: 4 3 3 3 3 3 3 2 4 4 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: chr  "K" "K" "K" "K" ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: Factor w/ 8 levels "?","0","2","B",..: NA NA NA NA NA NA NA NA NA NA ...
##  $ WFO       : chr  NA NA NA NA ...
##  $ STATEOFFIC: chr  NA NA NA NA ...
##  $ ZONENAMES : chr  NA NA NA NA ...
##  $ LATITUDE  : chr  "3040.00" "3042.00" "3340.00" "3458.00" ...
##  $ LONGITUDE : chr  "8812.00" "8755.00" "8742.00" "8626.00" ...
##  $ LATITUDE_E: chr  "3051.00" "0.00" "0.00" "0.00" ...
##  $ LONGITUDE_: chr  "8806.00" "0.00" "0.00" "0.00" ...
##  $ REMARKS   : chr  NA NA NA NA ...
##  $ REFNUM    : chr  "1.00" "2.00" "3.00" "4.00" ...
```

```r
dim(sdata)
```

```
## [1] 902297     38
```
