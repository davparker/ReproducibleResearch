# NOAA Storm Data Analysis on Population, Property, and Crops
David Parker  
Friday, August 22, 2014  

##Synopsis  

Analyzing NOAA's Storm Data to correlate types of weather events that impact human populations. The analysis will summarize data for the time period 1950 to 2011. The results will indicate hazards to people, in terms of injuries and death, as well as economic harm in terms of property and crop damage.

###Loading and Processing the Raw Data

* Using [Storm Data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2) extracted from the U.S. National Oceanic and Atmospheric Administrations (NOAA) storm database.  

##Data Processing   
Download the compressed data into a Temp file then read it in compressed form.  

__Read small sample__ of the data for column names and early classification:  

```r
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", 
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

__Load entire dataset__:  

```r
library(Defaults)
# change default date format for data load
setDefaults('as.Date.character', format = '%m/%d/%Y')
# 37 cols,  build appropriate column classes 10 at a time
cclasses <- c("factor", "Date", rep("character", 2), "numeric", "character", "factor", "character", "numeric", "factor", 
              rep("character", 3), "numeric", "character", "numeric", "factor", "character", rep("numeric", 2),
              "factor", rep("numeric", 4), "character", "numeric", "character",  rep("character", 2),
              rep("character", 7))
cclasses              
```

```
##  [1] "factor"    "Date"      "character" "character" "numeric"  
##  [6] "character" "factor"    "character" "numeric"   "factor"   
## [11] "character" "character" "character" "numeric"   "character"
## [16] "numeric"   "factor"    "character" "numeric"   "numeric"  
## [21] "factor"    "numeric"   "numeric"   "numeric"   "numeric"  
## [26] "character" "numeric"   "character" "character" "character"
## [31] "character" "character" "character" "character" "character"
## [36] "character" "character"
```

```r
# load entire dataset
sdata <- read.table(bzfile(temp), comment.char = "#", header = TRUE, sep = ",", 
                    colClasses = cclasses, na.strings = "")
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
##     EVTYPE            BGN_RANGE       BGN_AZI        BGN_LOCATI       
##  Length:902297      Min.   :   0   N      : 86752   Length:902297     
##  Class :character   1st Qu.:   0   W      : 38446   Class :character  
##  Mode  :character   Median :   0   S      : 37558   Mode  :character  
##                     Mean   :   1   E      : 33178                     
##                     3rd Qu.:   1   NW     : 24041                     
##                     Max.   :3749   (Other):134990                     
##                                    NA's   :547332                     
##    END_DATE           END_TIME           COUNTY_END  COUNTYENDN       
##  Length:902297      Length:902297      Min.   :0    Length:902297     
##  Class :character   Class :character   1st Qu.:0    Class :character  
##  Mode  :character   Mode  :character   Median :0    Mode  :character  
##                                        Mean   :0                      
##                                        3rd Qu.:0                      
##                                        Max.   :0                      
##                                                                       
##    END_RANGE      END_AZI        END_LOCATI            LENGTH      
##  Min.   :  0   N      : 28082   Length:902297      Min.   :   0.0  
##  1st Qu.:  0   S      : 22510   Class :character   1st Qu.:   0.0  
##  Median :  0   W      : 20119   Mode  :character   Median :   0.0  
##  Mean   :  1   E      : 20047                      Mean   :   0.2  
##  3rd Qu.:  0   NE     : 14606                      3rd Qu.:   0.0  
##  Max.   :925   (Other): 72096                      Max.   :2315.0  
##                NA's   :724837                                      
##      WIDTH         F               MAG          FATALITIES 
##  Min.   :   0   0   : 24993   Min.   :    0   Min.   :  0  
##  1st Qu.:   0   1   : 19475   1st Qu.:    0   1st Qu.:  0  
##  Median :   0   2   :  9878   Median :   50   Median :  0  
##  Mean   :   8   3   :  3179   Mean   :   47   Mean   :  0  
##  3rd Qu.:   0   4   :  1072   3rd Qu.:   75   3rd Qu.:  0  
##  Max.   :4400   5   :   137   Max.   :22000   Max.   :583  
##                 NA's:843563                                
##     INJURIES         PROPDMG      PROPDMGEXP           CROPDMG     
##  Min.   :   0.0   Min.   :   0   Length:902297      Min.   :  0.0  
##  1st Qu.:   0.0   1st Qu.:   0   Class :character   1st Qu.:  0.0  
##  Median :   0.0   Median :   0   Mode  :character   Median :  0.0  
##  Mean   :   0.2   Mean   :  12                      Mean   :  1.5  
##  3rd Qu.:   0.0   3rd Qu.:   0                      3rd Qu.:  0.0  
##  Max.   :1700.0   Max.   :5000                      Max.   :990.0  
##                                                                    
##   CROPDMGEXP            WFO             STATEOFFIC       
##  Length:902297      Length:902297      Length:902297     
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##                                                          
##                                                          
##                                                          
##                                                          
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
# Data is loaded, drop the temp compressed file
unlink(temp)
```

__Make date field__:  

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
sdata$BEGIN_DATE <- 
  as.POSIXct(
    paste(sdata$BGN_DATE, sdata$BGN_TIME, sdata$TIME_ZONE) 
    , format=  "%Y-%m-%d %H%M")
head(sdata[, c(2:4, 38)])
```

```
##     BGN_DATE BGN_TIME TIME_ZONE          BEGIN_DATE
## 1 1950-04-18     0130       CST 1950-04-18 01:30:00
## 2 1950-04-18     0145       CST 1950-04-18 01:45:00
## 3 1951-02-20     1600       CST 1951-02-20 16:00:00
## 4 1951-06-08     0900       CST 1951-06-08 09:00:00
## 5 1951-11-15     1500       CST 1951-11-15 15:00:00
## 6 1951-11-15     2000       CST 1951-11-15 20:00:00
```

```r
# place BEGIN_DATE in appropiate position
sdata <- sdata[, c(1, 38, 2:37)]
dim(sdata)
```

```
## [1] 902297     38
```

```r
# save sdata during testing
# save(sdata, file = 'sdata.Rdata')
```

__Tidy the data__:  

```r
library(plyr)
etype <- sort(unique(sdata$EVTYPE))
etype 
```

```
##   [1] "   HIGH SURF ADVISORY"          " COASTAL FLOOD"                
##   [3] " FLASH FLOOD"                   " LIGHTNING"                    
##   [5] " TSTM WIND"                     " TSTM WIND (G45)"              
##   [7] " WATERSPOUT"                    " WIND"                         
##   [9] "?"                              "ABNORMAL WARMTH"               
##  [11] "ABNORMALLY DRY"                 "ABNORMALLY WET"                
##  [13] "ACCUMULATED SNOWFALL"           "AGRICULTURAL FREEZE"           
##  [15] "APACHE COUNTY"                  "ASTRONOMICAL HIGH TIDE"        
##  [17] "ASTRONOMICAL LOW TIDE"          "AVALANCE"                      
##  [19] "AVALANCHE"                      "BEACH EROSIN"                  
##  [21] "Beach Erosion"                  "BEACH EROSION"                 
##  [23] "BEACH EROSION/COASTAL FLOOD"    "BEACH FLOOD"                   
##  [25] "BELOW NORMAL PRECIPITATION"     "BITTER WIND CHILL"             
##  [27] "BITTER WIND CHILL TEMPERATURES" "Black Ice"                     
##  [29] "BLACK ICE"                      "BLIZZARD"                      
##  [31] "BLIZZARD AND EXTREME WIND CHIL" "BLIZZARD AND HEAVY SNOW"       
##  [33] "Blizzard Summary"               "BLIZZARD WEATHER"              
##  [35] "BLIZZARD/FREEZING RAIN"         "BLIZZARD/HEAVY SNOW"           
##  [37] "BLIZZARD/HIGH WIND"             "BLIZZARD/WINTER STORM"         
##  [39] "BLOW-OUT TIDE"                  "BLOW-OUT TIDES"                
##  [41] "BLOWING DUST"                   "blowing snow"                  
##  [43] "Blowing Snow"                   "BLOWING SNOW"                  
##  [45] "BLOWING SNOW- EXTREME WIND CHI" "BLOWING SNOW & EXTREME WIND CH"
##  [47] "BLOWING SNOW/EXTREME WIND CHIL" "BREAKUP FLOODING"              
##  [49] "BRUSH FIRE"                     "BRUSH FIRES"                   
##  [51] "COASTAL  FLOODING/EROSION"      "COASTAL EROSION"               
##  [53] "Coastal Flood"                  "COASTAL FLOOD"                 
##  [55] "coastal flooding"               "Coastal Flooding"              
##  [57] "COASTAL FLOODING"               "COASTAL FLOODING/EROSION"      
##  [59] "Coastal Storm"                  "COASTAL STORM"                 
##  [61] "COASTAL SURGE"                  "COASTAL/TIDAL FLOOD"           
##  [63] "COASTALFLOOD"                   "COASTALSTORM"                  
##  [65] "Cold"                           "COLD"                          
##  [67] "COLD AIR FUNNEL"                "COLD AIR FUNNELS"              
##  [69] "COLD AIR TORNADO"               "Cold and Frost"                
##  [71] "COLD AND FROST"                 "COLD AND SNOW"                 
##  [73] "COLD AND WET CONDITIONS"        "Cold Temperature"              
##  [75] "COLD TEMPERATURES"              "COLD WAVE"                     
##  [77] "COLD WEATHER"                   "COLD WIND CHILL TEMPERATURES"  
##  [79] "COLD/WIND CHILL"                "COLD/WINDS"                    
##  [81] "COOL AND WET"                   "COOL SPELL"                    
##  [83] "CSTL FLOODING/EROSION"          "DAM BREAK"                     
##  [85] "DAM FAILURE"                    "Damaging Freeze"               
##  [87] "DAMAGING FREEZE"                "DEEP HAIL"                     
##  [89] "DENSE FOG"                      "DENSE SMOKE"                   
##  [91] "DOWNBURST"                      "DOWNBURST WINDS"               
##  [93] "DRIEST MONTH"                   "Drifting Snow"                 
##  [95] "DROUGHT"                        "DROUGHT/EXCESSIVE HEAT"        
##  [97] "DROWNING"                       "DRY"                           
##  [99] "DRY CONDITIONS"                 "DRY HOT WEATHER"               
## [101] "DRY MICROBURST"                 "DRY MICROBURST 50"             
## [103] "DRY MICROBURST 53"              "DRY MICROBURST 58"             
## [105] "DRY MICROBURST 61"              "DRY MICROBURST 84"             
## [107] "DRY MICROBURST WINDS"           "DRY MIRCOBURST WINDS"          
## [109] "DRY PATTERN"                    "DRY SPELL"                     
## [111] "DRY WEATHER"                    "DRYNESS"                       
## [113] "DUST DEVEL"                     "Dust Devil"                    
## [115] "DUST DEVIL"                     "DUST DEVIL WATERSPOUT"         
## [117] "DUST STORM"                     "DUST STORM/HIGH WINDS"         
## [119] "DUSTSTORM"                      "EARLY FREEZE"                  
## [121] "Early Frost"                    "EARLY FROST"                   
## [123] "EARLY RAIN"                     "EARLY SNOW"                    
## [125] "Early snowfall"                 "EARLY SNOWFALL"                
## [127] "Erosion/Cstl Flood"             "EXCESSIVE"                     
## [129] "Excessive Cold"                 "EXCESSIVE HEAT"                
## [131] "EXCESSIVE HEAT/DROUGHT"         "EXCESSIVE PRECIPITATION"       
## [133] "EXCESSIVE RAIN"                 "EXCESSIVE RAINFALL"            
## [135] "EXCESSIVE SNOW"                 "EXCESSIVE WETNESS"             
## [137] "EXCESSIVELY DRY"                "Extended Cold"                 
## [139] "Extreme Cold"                   "EXTREME COLD"                  
## [141] "EXTREME COLD/WIND CHILL"        "EXTREME HEAT"                  
## [143] "EXTREME WIND CHILL"             "EXTREME WIND CHILL/BLOWING SNO"
## [145] "EXTREME WIND CHILLS"            "EXTREME WINDCHILL"             
## [147] "EXTREME WINDCHILL TEMPERATURES" "EXTREME/RECORD COLD"           
## [149] "EXTREMELY WET"                  "FALLING SNOW/ICE"              
## [151] "FIRST FROST"                    "FIRST SNOW"                    
## [153] "FLASH FLOOD"                    "FLASH FLOOD - HEAVY RAIN"      
## [155] "FLASH FLOOD FROM ICE JAMS"      "FLASH FLOOD LANDSLIDES"        
## [157] "FLASH FLOOD WINDS"              "FLASH FLOOD/"                  
## [159] "FLASH FLOOD/ FLOOD"             "FLASH FLOOD/ STREET"           
## [161] "FLASH FLOOD/FLOOD"              "FLASH FLOOD/HEAVY RAIN"        
## [163] "FLASH FLOOD/LANDSLIDE"          "FLASH FLOODING"                
## [165] "FLASH FLOODING/FLOOD"           "FLASH FLOODING/THUNDERSTORM WI"
## [167] "FLASH FLOODS"                   "FLASH FLOOODING"               
## [169] "Flood"                          "FLOOD"                         
## [171] "FLOOD & HEAVY RAIN"             "FLOOD FLASH"                   
## [173] "FLOOD FLOOD/FLASH"              "FLOOD WATCH/"                  
## [175] "FLOOD/FLASH"                    "Flood/Flash Flood"             
## [177] "FLOOD/FLASH FLOOD"              "FLOOD/FLASH FLOODING"          
## [179] "FLOOD/FLASH/FLOOD"              "FLOOD/FLASHFLOOD"              
## [181] "FLOOD/RAIN/WIND"                "FLOOD/RAIN/WINDS"              
## [183] "FLOOD/RIVER FLOOD"              "Flood/Strong Wind"             
## [185] "FLOODING"                       "FLOODING/HEAVY RAIN"           
## [187] "FLOODS"                         "FOG"                           
## [189] "FOG AND COLD TEMPERATURES"      "FOREST FIRES"                  
## [191] "Freeze"                         "FREEZE"                        
## [193] "Freezing drizzle"               "Freezing Drizzle"              
## [195] "FREEZING DRIZZLE"               "FREEZING DRIZZLE AND FREEZING" 
## [197] "Freezing Fog"                   "FREEZING FOG"                  
## [199] "Freezing rain"                  "Freezing Rain"                 
## [201] "FREEZING RAIN"                  "FREEZING RAIN AND SLEET"       
## [203] "FREEZING RAIN AND SNOW"         "FREEZING RAIN SLEET AND"       
## [205] "FREEZING RAIN SLEET AND LIGHT"  "FREEZING RAIN/SLEET"           
## [207] "FREEZING RAIN/SNOW"             "Freezing Spray"                
## [209] "Frost"                          "FROST"                         
## [211] "Frost/Freeze"                   "FROST/FREEZE"                  
## [213] "FROST\\FREEZE"                  "FUNNEL"                        
## [215] "Funnel Cloud"                   "FUNNEL CLOUD"                  
## [217] "FUNNEL CLOUD."                  "FUNNEL CLOUD/HAIL"             
## [219] "FUNNEL CLOUDS"                  "FUNNELS"                       
## [221] "Glaze"                          "GLAZE"                         
## [223] "GLAZE ICE"                      "GLAZE/ICE STORM"               
## [225] "gradient wind"                  "Gradient wind"                 
## [227] "GRADIENT WIND"                  "GRADIENT WINDS"                
## [229] "GRASS FIRES"                    "GROUND BLIZZARD"               
## [231] "GUSTNADO"                       "GUSTNADO AND"                  
## [233] "GUSTY LAKE WIND"                "GUSTY THUNDERSTORM WIND"       
## [235] "GUSTY THUNDERSTORM WINDS"       "Gusty Wind"                    
## [237] "GUSTY WIND"                     "GUSTY WIND/HAIL"               
## [239] "GUSTY WIND/HVY RAIN"            "Gusty wind/rain"               
## [241] "Gusty winds"                    "Gusty Winds"                   
## [243] "GUSTY WINDS"                    "HAIL"                          
## [245] "HAIL 0.75"                      "HAIL 0.88"                     
## [247] "HAIL 075"                       "HAIL 088"                      
## [249] "HAIL 1.00"                      "HAIL 1.75"                     
## [251] "HAIL 1.75)"                     "HAIL 100"                      
## [253] "HAIL 125"                       "HAIL 150"                      
## [255] "HAIL 175"                       "HAIL 200"                      
## [257] "HAIL 225"                       "HAIL 275"                      
## [259] "HAIL 450"                       "HAIL 75"                       
## [261] "HAIL 80"                        "HAIL 88"                       
## [263] "HAIL ALOFT"                     "HAIL DAMAGE"                   
## [265] "HAIL FLOODING"                  "HAIL STORM"                    
## [267] "Hail(0.75)"                     "HAIL/ICY ROADS"                
## [269] "HAIL/WIND"                      "HAIL/WINDS"                    
## [271] "HAILSTORM"                      "HAILSTORMS"                    
## [273] "HARD FREEZE"                    "HAZARDOUS SURF"                
## [275] "HEAT"                           "HEAT DROUGHT"                  
## [277] "Heat Wave"                      "HEAT WAVE"                     
## [279] "HEAT WAVE DROUGHT"              "HEAT WAVES"                    
## [281] "HEAT/DROUGHT"                   "Heatburst"                     
## [283] "HEAVY LAKE SNOW"                "HEAVY MIX"                     
## [285] "HEAVY PRECIPATATION"            "Heavy Precipitation"           
## [287] "HEAVY PRECIPITATION"            "Heavy rain"                    
## [289] "Heavy Rain"                     "HEAVY RAIN"                    
## [291] "HEAVY RAIN AND FLOOD"           "Heavy Rain and Wind"           
## [293] "HEAVY RAIN EFFECTS"             "HEAVY RAIN/FLOODING"           
## [295] "Heavy Rain/High Surf"           "HEAVY RAIN/LIGHTNING"          
## [297] "HEAVY RAIN/MUDSLIDES/FLOOD"     "HEAVY RAIN/SEVERE WEATHER"     
## [299] "HEAVY RAIN/SMALL STREAM URBAN"  "HEAVY RAIN/SNOW"               
## [301] "HEAVY RAIN/URBAN FLOOD"         "HEAVY RAIN/WIND"               
## [303] "HEAVY RAIN; URBAN FLOOD WINDS;" "HEAVY RAINFALL"                
## [305] "HEAVY RAINS"                    "HEAVY RAINS/FLOODING"          
## [307] "HEAVY SEAS"                     "HEAVY SHOWER"                  
## [309] "HEAVY SHOWERS"                  "HEAVY SNOW"                    
## [311] "HEAVY SNOW-SQUALLS"             "HEAVY SNOW   FREEZING RAIN"    
## [313] "HEAVY SNOW & ICE"               "HEAVY SNOW AND"                
## [315] "HEAVY SNOW AND HIGH WINDS"      "HEAVY SNOW AND ICE"            
## [317] "HEAVY SNOW AND ICE STORM"       "HEAVY SNOW AND STRONG WINDS"   
## [319] "HEAVY SNOW ANDBLOWING SNOW"     "Heavy snow shower"             
## [321] "HEAVY SNOW SQUALLS"             "HEAVY SNOW/BLIZZARD"           
## [323] "HEAVY SNOW/BLIZZARD/AVALANCHE"  "HEAVY SNOW/BLOWING SNOW"       
## [325] "HEAVY SNOW/FREEZING RAIN"       "HEAVY SNOW/HIGH"               
## [327] "HEAVY SNOW/HIGH WIND"           "HEAVY SNOW/HIGH WINDS"         
## [329] "HEAVY SNOW/HIGH WINDS & FLOOD"  "HEAVY SNOW/HIGH WINDS/FREEZING"
## [331] "HEAVY SNOW/ICE"                 "HEAVY SNOW/ICE STORM"          
## [333] "HEAVY SNOW/SLEET"               "HEAVY SNOW/SQUALLS"            
## [335] "HEAVY SNOW/WIND"                "HEAVY SNOW/WINTER STORM"       
## [337] "HEAVY SNOWPACK"                 "Heavy Surf"                    
## [339] "HEAVY SURF"                     "Heavy surf and wind"           
## [341] "HEAVY SURF COASTAL FLOODING"    "HEAVY SURF/HIGH SURF"          
## [343] "HEAVY SWELLS"                   "HEAVY WET SNOW"                
## [345] "HIGH"                           "HIGH  SWELLS"                  
## [347] "HIGH  WINDS"                    "HIGH SEAS"                     
## [349] "High Surf"                      "HIGH SURF"                     
## [351] "HIGH SURF ADVISORIES"           "HIGH SURF ADVISORY"            
## [353] "HIGH SWELLS"                    "HIGH TEMPERATURE RECORD"       
## [355] "HIGH TIDES"                     "HIGH WATER"                    
## [357] "HIGH WAVES"                     "High Wind"                     
## [359] "HIGH WIND"                      "HIGH WIND (G40)"               
## [361] "HIGH WIND 48"                   "HIGH WIND 63"                  
## [363] "HIGH WIND 70"                   "HIGH WIND AND HEAVY SNOW"      
## [365] "HIGH WIND AND HIGH TIDES"       "HIGH WIND AND SEAS"            
## [367] "HIGH WIND DAMAGE"               "HIGH WIND/ BLIZZARD"           
## [369] "HIGH WIND/BLIZZARD"             "HIGH WIND/BLIZZARD/FREEZING RA"
## [371] "HIGH WIND/HEAVY SNOW"           "HIGH WIND/LOW WIND CHILL"      
## [373] "HIGH WIND/SEAS"                 "HIGH WIND/WIND CHILL"          
## [375] "HIGH WIND/WIND CHILL/BLIZZARD"  "HIGH WINDS"                    
## [377] "HIGH WINDS 55"                  "HIGH WINDS 57"                 
## [379] "HIGH WINDS 58"                  "HIGH WINDS 63"                 
## [381] "HIGH WINDS 66"                  "HIGH WINDS 67"                 
## [383] "HIGH WINDS 73"                  "HIGH WINDS 76"                 
## [385] "HIGH WINDS 80"                  "HIGH WINDS 82"                 
## [387] "HIGH WINDS AND WIND CHILL"      "HIGH WINDS DUST STORM"         
## [389] "HIGH WINDS HEAVY RAINS"         "HIGH WINDS/"                   
## [391] "HIGH WINDS/COASTAL FLOOD"       "HIGH WINDS/COLD"               
## [393] "HIGH WINDS/FLOODING"            "HIGH WINDS/HEAVY RAIN"         
## [395] "HIGH WINDS/SNOW"                "HIGHWAY FLOODING"              
## [397] "Hot and Dry"                    "HOT PATTERN"                   
## [399] "HOT SPELL"                      "HOT WEATHER"                   
## [401] "HOT/DRY PATTERN"                "HURRICANE"                     
## [403] "HURRICANE-GENERATED SWELLS"     "Hurricane Edouard"             
## [405] "HURRICANE EMILY"                "HURRICANE ERIN"                
## [407] "HURRICANE FELIX"                "HURRICANE GORDON"              
## [409] "HURRICANE OPAL"                 "HURRICANE OPAL/HIGH WINDS"     
## [411] "HURRICANE/TYPHOON"              "HVY RAIN"                      
## [413] "HYPERTHERMIA/EXPOSURE"          "HYPOTHERMIA"                   
## [415] "Hypothermia/Exposure"           "HYPOTHERMIA/EXPOSURE"          
## [417] "ICE"                            "ICE AND SNOW"                  
## [419] "ICE FLOES"                      "Ice Fog"                       
## [421] "ICE JAM"                        "Ice jam flood (minor"          
## [423] "ICE JAM FLOODING"               "ICE ON ROAD"                   
## [425] "ICE PELLETS"                    "ICE ROADS"                     
## [427] "ICE STORM"                      "ICE STORM AND SNOW"            
## [429] "ICE STORM/FLASH FLOOD"          "Ice/Snow"                      
## [431] "ICE/SNOW"                       "ICE/STRONG WINDS"              
## [433] "Icestorm/Blizzard"              "Icy Roads"                     
## [435] "ICY ROADS"                      "LACK OF SNOW"                  
## [437] "LAKE-EFFECT SNOW"               "Lake Effect Snow"              
## [439] "LAKE EFFECT SNOW"               "LAKE FLOOD"                    
## [441] "LAKESHORE FLOOD"                "LANDSLIDE"                     
## [443] "LANDSLIDE/URBAN FLOOD"          "LANDSLIDES"                    
## [445] "Landslump"                      "LANDSLUMP"                     
## [447] "LANDSPOUT"                      "LARGE WALL CLOUD"              
## [449] "Late-season Snowfall"           "LATE FREEZE"                   
## [451] "LATE SEASON HAIL"               "LATE SEASON SNOW"              
## [453] "Late Season Snowfall"           "LATE SNOW"                     
## [455] "LIGHT FREEZING RAIN"            "Light snow"                    
## [457] "Light Snow"                     "LIGHT SNOW"                    
## [459] "LIGHT SNOW AND SLEET"           "Light Snow/Flurries"           
## [461] "LIGHT SNOW/FREEZING PRECIP"     "Light Snowfall"                
## [463] "LIGHTING"                       "LIGHTNING"                     
## [465] "LIGHTNING  WAUSEON"             "LIGHTNING AND HEAVY RAIN"      
## [467] "LIGHTNING AND THUNDERSTORM WIN" "LIGHTNING AND WINDS"           
## [469] "LIGHTNING DAMAGE"               "LIGHTNING FIRE"                
## [471] "LIGHTNING INJURY"               "LIGHTNING THUNDERSTORM WINDS"  
## [473] "LIGHTNING THUNDERSTORM WINDSS"  "LIGHTNING."                    
## [475] "LIGHTNING/HEAVY RAIN"           "LIGNTNING"                     
## [477] "LOCAL FLASH FLOOD"              "LOCAL FLOOD"                   
## [479] "LOCALLY HEAVY RAIN"             "LOW TEMPERATURE"               
## [481] "LOW TEMPERATURE RECORD"         "LOW WIND CHILL"                
## [483] "MAJOR FLOOD"                    "Marine Accident"               
## [485] "MARINE HAIL"                    "MARINE HIGH WIND"              
## [487] "MARINE MISHAP"                  "MARINE STRONG WIND"            
## [489] "MARINE THUNDERSTORM WIND"       "MARINE TSTM WIND"              
## [491] "Metro Storm, May 26"            "Microburst"                    
## [493] "MICROBURST"                     "MICROBURST WINDS"              
## [495] "Mild and Dry Pattern"           "MILD PATTERN"                  
## [497] "MILD/DRY PATTERN"               "MINOR FLOOD"                   
## [499] "Minor Flooding"                 "MINOR FLOODING"                
## [501] "MIXED PRECIP"                   "Mixed Precipitation"           
## [503] "MIXED PRECIPITATION"            "MODERATE SNOW"                 
## [505] "MODERATE SNOWFALL"              "MONTHLY PRECIPITATION"         
## [507] "Monthly Rainfall"               "MONTHLY RAINFALL"              
## [509] "Monthly Snowfall"               "MONTHLY SNOWFALL"              
## [511] "MONTHLY TEMPERATURE"            "Mountain Snows"                
## [513] "MUD SLIDE"                      "MUD SLIDES"                    
## [515] "MUD SLIDES URBAN FLOODING"      "MUD/ROCK SLIDE"                
## [517] "Mudslide"                       "MUDSLIDE"                      
## [519] "MUDSLIDE/LANDSLIDE"             "Mudslides"                     
## [521] "MUDSLIDES"                      "NEAR RECORD SNOW"              
## [523] "No Severe Weather"              "NON-SEVERE WIND DAMAGE"        
## [525] "NON-TSTM WIND"                  "NON SEVERE HAIL"               
## [527] "NON TSTM WIND"                  "NONE"                          
## [529] "NORMAL PRECIPITATION"           "NORTHERN LIGHTS"               
## [531] "Other"                          "OTHER"                         
## [533] "PATCHY DENSE FOG"               "PATCHY ICE"                    
## [535] "Prolong Cold"                   "PROLONG COLD"                  
## [537] "PROLONG COLD/SNOW"              "PROLONG WARMTH"                
## [539] "PROLONGED RAIN"                 "RAIN"                          
## [541] "RAIN (HEAVY)"                   "RAIN AND WIND"                 
## [543] "Rain Damage"                    "RAIN/SNOW"                     
## [545] "RAIN/WIND"                      "RAINSTORM"                     
## [547] "RAPIDLY RISING WATER"           "RECORD  COLD"                  
## [549] "Record Cold"                    "RECORD COLD"                   
## [551] "RECORD COLD AND HIGH WIND"      "RECORD COLD/FROST"             
## [553] "RECORD COOL"                    "Record dry month"              
## [555] "RECORD DRYNESS"                 "Record Heat"                   
## [557] "RECORD HEAT"                    "RECORD HEAT WAVE"              
## [559] "Record High"                    "RECORD HIGH"                   
## [561] "RECORD HIGH TEMPERATURE"        "RECORD HIGH TEMPERATURES"      
## [563] "RECORD LOW"                     "RECORD LOW RAINFALL"           
## [565] "Record May Snow"                "RECORD PRECIPITATION"          
## [567] "RECORD RAINFALL"                "RECORD SNOW"                   
## [569] "RECORD SNOW/COLD"               "RECORD SNOWFALL"               
## [571] "Record temperature"             "RECORD TEMPERATURE"            
## [573] "Record Temperatures"            "RECORD TEMPERATURES"           
## [575] "RECORD WARM"                    "RECORD WARM TEMPS."            
## [577] "Record Warmth"                  "RECORD WARMTH"                 
## [579] "Record Winter Snow"             "RECORD/EXCESSIVE HEAT"         
## [581] "RECORD/EXCESSIVE RAINFALL"      "RED FLAG CRITERIA"             
## [583] "RED FLAG FIRE WX"               "REMNANTS OF FLOYD"             
## [585] "RIP CURRENT"                    "RIP CURRENTS"                  
## [587] "RIP CURRENTS HEAVY SURF"        "RIP CURRENTS/HEAVY SURF"       
## [589] "RIVER AND STREAM FLOOD"         "RIVER FLOOD"                   
## [591] "River Flooding"                 "RIVER FLOODING"                
## [593] "ROCK SLIDE"                     "ROGUE WAVE"                    
## [595] "ROTATING WALL CLOUD"            "ROUGH SEAS"                    
## [597] "ROUGH SURF"                     "RURAL FLOOD"                   
## [599] "Saharan Dust"                   "SAHARAN DUST"                  
## [601] "Seasonal Snowfall"              "SEICHE"                        
## [603] "SEVERE COLD"                    "SEVERE THUNDERSTORM"           
## [605] "SEVERE THUNDERSTORM WINDS"      "SEVERE THUNDERSTORMS"          
## [607] "SEVERE TURBULENCE"              "SLEET"                         
## [609] "SLEET & FREEZING RAIN"          "SLEET STORM"                   
## [611] "SLEET/FREEZING RAIN"            "SLEET/ICE STORM"               
## [613] "SLEET/RAIN/SNOW"                "SLEET/SNOW"                    
## [615] "small hail"                     "Small Hail"                    
## [617] "SMALL HAIL"                     "SMALL STREAM"                  
## [619] "SMALL STREAM AND"               "SMALL STREAM AND URBAN FLOOD"  
## [621] "SMALL STREAM AND URBAN FLOODIN" "SMALL STREAM FLOOD"            
## [623] "SMALL STREAM FLOODING"          "SMALL STREAM URBAN FLOOD"      
## [625] "SMALL STREAM/URBAN FLOOD"       "Sml Stream Fld"                
## [627] "SMOKE"                          "Snow"                          
## [629] "SNOW"                           "SNOW- HIGH WIND- WIND CHILL"   
## [631] "Snow Accumulation"              "SNOW ACCUMULATION"             
## [633] "SNOW ADVISORY"                  "SNOW AND COLD"                 
## [635] "SNOW AND HEAVY SNOW"            "Snow and Ice"                  
## [637] "SNOW AND ICE"                   "SNOW AND ICE STORM"            
## [639] "Snow and sleet"                 "SNOW AND SLEET"                
## [641] "SNOW AND WIND"                  "SNOW DROUGHT"                  
## [643] "SNOW FREEZING RAIN"             "SNOW SHOWERS"                  
## [645] "SNOW SLEET"                     "SNOW SQUALL"                   
## [647] "Snow squalls"                   "Snow Squalls"                  
## [649] "SNOW SQUALLS"                   "SNOW/ BITTER COLD"             
## [651] "SNOW/ ICE"                      "SNOW/BLOWING SNOW"             
## [653] "SNOW/COLD"                      "SNOW/FREEZING RAIN"            
## [655] "SNOW/HEAVY SNOW"                "SNOW/HIGH WINDS"               
## [657] "SNOW/ICE"                       "SNOW/ICE STORM"                
## [659] "SNOW/RAIN"                      "SNOW/RAIN/SLEET"               
## [661] "SNOW/SLEET"                     "SNOW/SLEET/FREEZING RAIN"      
## [663] "SNOW/SLEET/RAIN"                "SNOW\\COLD"                    
## [665] "SNOWFALL RECORD"                "SNOWMELT FLOODING"             
## [667] "SNOWSTORM"                      "SOUTHEAST"                     
## [669] "STORM FORCE WINDS"              "STORM SURGE"                   
## [671] "STORM SURGE/TIDE"               "STREAM FLOODING"               
## [673] "STREET FLOOD"                   "STREET FLOODING"               
## [675] "Strong Wind"                    "STRONG WIND"                   
## [677] "STRONG WIND GUST"               "Strong winds"                  
## [679] "Strong Winds"                   "STRONG WINDS"                  
## [681] "Summary August 10"              "Summary August 11"             
## [683] "Summary August 17"              "Summary August 2-3"            
## [685] "Summary August 21"              "Summary August 28"             
## [687] "Summary August 4"               "Summary August 7"              
## [689] "Summary August 9"               "Summary Jan 17"                
## [691] "Summary July 23-24"             "Summary June 18-19"            
## [693] "Summary June 5-6"               "Summary June 6"                
## [695] "Summary of April 12"            "Summary of April 13"           
## [697] "Summary of April 21"            "Summary of April 27"           
## [699] "Summary of April 3rd"           "Summary of August 1"           
## [701] "Summary of July 11"             "Summary of July 2"             
## [703] "Summary of July 22"             "Summary of July 26"            
## [705] "Summary of July 29"             "Summary of July 3"             
## [707] "Summary of June 10"             "Summary of June 11"            
## [709] "Summary of June 12"             "Summary of June 13"            
## [711] "Summary of June 15"             "Summary of June 16"            
## [713] "Summary of June 18"             "Summary of June 23"            
## [715] "Summary of June 24"             "Summary of June 3"             
## [717] "Summary of June 30"             "Summary of June 4"             
## [719] "Summary of June 6"              "Summary of March 14"           
## [721] "Summary of March 23"            "Summary of March 24"           
## [723] "SUMMARY OF MARCH 24-25"         "SUMMARY OF MARCH 27"           
## [725] "SUMMARY OF MARCH 29"            "Summary of May 10"             
## [727] "Summary of May 13"              "Summary of May 14"             
## [729] "Summary of May 22"              "Summary of May 22 am"          
## [731] "Summary of May 22 pm"           "Summary of May 26 am"          
## [733] "Summary of May 26 pm"           "Summary of May 31 am"          
## [735] "Summary of May 31 pm"           "Summary of May 9-10"           
## [737] "Summary Sept. 25-26"            "Summary September 20"          
## [739] "Summary September 23"           "Summary September 3"           
## [741] "Summary September 4"            "Summary: Nov. 16"              
## [743] "Summary: Nov. 6-7"              "Summary: Oct. 20-21"           
## [745] "Summary: October 31"            "Summary: Sept. 18"             
## [747] "Temperature record"             "THUDERSTORM WINDS"             
## [749] "THUNDEERSTORM WINDS"            "THUNDERESTORM WINDS"           
## [751] "THUNDERSNOW"                    "Thundersnow shower"            
## [753] "THUNDERSTORM"                   "THUNDERSTORM  WINDS"           
## [755] "THUNDERSTORM DAMAGE"            "THUNDERSTORM DAMAGE TO"        
## [757] "THUNDERSTORM HAIL"              "THUNDERSTORM W INDS"           
## [759] "Thunderstorm Wind"              "THUNDERSTORM WIND"             
## [761] "THUNDERSTORM WIND (G40)"        "THUNDERSTORM WIND 50"          
## [763] "THUNDERSTORM WIND 52"           "THUNDERSTORM WIND 56"          
## [765] "THUNDERSTORM WIND 59"           "THUNDERSTORM WIND 59 MPH"      
## [767] "THUNDERSTORM WIND 59 MPH."      "THUNDERSTORM WIND 60 MPH"      
## [769] "THUNDERSTORM WIND 65 MPH"       "THUNDERSTORM WIND 65MPH"       
## [771] "THUNDERSTORM WIND 69"           "THUNDERSTORM WIND 98 MPH"      
## [773] "THUNDERSTORM WIND G50"          "THUNDERSTORM WIND G51"         
## [775] "THUNDERSTORM WIND G52"          "THUNDERSTORM WIND G55"         
## [777] "THUNDERSTORM WIND G60"          "THUNDERSTORM WIND G61"         
## [779] "THUNDERSTORM WIND TREES"        "THUNDERSTORM WIND."            
## [781] "THUNDERSTORM WIND/ TREE"        "THUNDERSTORM WIND/ TREES"      
## [783] "THUNDERSTORM WIND/AWNING"       "THUNDERSTORM WIND/HAIL"        
## [785] "THUNDERSTORM WIND/LIGHTNING"    "THUNDERSTORM WINDS"            
## [787] "THUNDERSTORM WINDS      LE CEN" "THUNDERSTORM WINDS 13"         
## [789] "THUNDERSTORM WINDS 2"           "THUNDERSTORM WINDS 50"         
## [791] "THUNDERSTORM WINDS 52"          "THUNDERSTORM WINDS 53"         
## [793] "THUNDERSTORM WINDS 60"          "THUNDERSTORM WINDS 61"         
## [795] "THUNDERSTORM WINDS 62"          "THUNDERSTORM WINDS 63 MPH"     
## [797] "THUNDERSTORM WINDS AND"         "THUNDERSTORM WINDS FUNNEL CLOU"
## [799] "THUNDERSTORM WINDS G"           "THUNDERSTORM WINDS G60"        
## [801] "THUNDERSTORM WINDS HAIL"        "THUNDERSTORM WINDS HEAVY RAIN" 
## [803] "THUNDERSTORM WINDS LIGHTNING"   "THUNDERSTORM WINDS SMALL STREA"
## [805] "THUNDERSTORM WINDS URBAN FLOOD" "THUNDERSTORM WINDS."           
## [807] "THUNDERSTORM WINDS/ FLOOD"      "THUNDERSTORM WINDS/ HAIL"      
## [809] "THUNDERSTORM WINDS/FLASH FLOOD" "THUNDERSTORM WINDS/FLOODING"   
## [811] "THUNDERSTORM WINDS/FUNNEL CLOU" "THUNDERSTORM WINDS/HAIL"       
## [813] "THUNDERSTORM WINDS/HEAVY RAIN"  "THUNDERSTORM WINDS53"          
## [815] "THUNDERSTORM WINDSHAIL"         "THUNDERSTORM WINDSS"           
## [817] "THUNDERSTORM WINS"              "THUNDERSTORMS"                 
## [819] "THUNDERSTORMS WIND"             "THUNDERSTORMS WINDS"           
## [821] "THUNDERSTORMW"                  "THUNDERSTORMW 50"              
## [823] "THUNDERSTORMW WINDS"            "THUNDERSTORMWINDS"             
## [825] "THUNDERSTROM WIND"              "THUNDERSTROM WINDS"            
## [827] "THUNDERTORM WINDS"              "THUNDERTSORM WIND"             
## [829] "THUNDESTORM WINDS"              "THUNERSTORM WINDS"             
## [831] "TIDAL FLOOD"                    "Tidal Flooding"                
## [833] "TIDAL FLOODING"                 "TORNADO"                       
## [835] "TORNADO DEBRIS"                 "TORNADO F0"                    
## [837] "TORNADO F1"                     "TORNADO F2"                    
## [839] "TORNADO F3"                     "TORNADO/WATERSPOUT"            
## [841] "TORNADOES"                      "TORNADOES, TSTM WIND, HAIL"    
## [843] "TORNADOS"                       "TORNDAO"                       
## [845] "TORRENTIAL RAIN"                "Torrential Rainfall"           
## [847] "TROPICAL DEPRESSION"            "TROPICAL STORM"                
## [849] "TROPICAL STORM ALBERTO"         "TROPICAL STORM DEAN"           
## [851] "TROPICAL STORM GORDON"          "TROPICAL STORM JERRY"          
## [853] "TSTM"                           "TSTM HEAVY RAIN"               
## [855] "Tstm Wind"                      "TSTM WIND"                     
## [857] "TSTM WIND  (G45)"               "TSTM WIND (41)"                
## [859] "TSTM WIND (G35)"                "TSTM WIND (G40)"               
## [861] "TSTM WIND (G45)"                "TSTM WIND 40"                  
## [863] "TSTM WIND 45"                   "TSTM WIND 50"                  
## [865] "TSTM WIND 51"                   "TSTM WIND 52"                  
## [867] "TSTM WIND 55"                   "TSTM WIND 65)"                 
## [869] "TSTM WIND AND LIGHTNING"        "TSTM WIND DAMAGE"              
## [871] "TSTM WIND G45"                  "TSTM WIND G58"                 
## [873] "TSTM WIND/HAIL"                 "TSTM WINDS"                    
## [875] "TSTM WND"                       "TSTMW"                         
## [877] "TSUNAMI"                        "TUNDERSTORM WIND"              
## [879] "TYPHOON"                        "Unseasonable Cold"             
## [881] "UNSEASONABLY COLD"              "UNSEASONABLY COOL"             
## [883] "UNSEASONABLY COOL & WET"        "UNSEASONABLY DRY"              
## [885] "UNSEASONABLY HOT"               "UNSEASONABLY WARM"             
## [887] "UNSEASONABLY WARM & WET"        "UNSEASONABLY WARM AND DRY"     
## [889] "UNSEASONABLY WARM YEAR"         "UNSEASONABLY WARM/WET"         
## [891] "UNSEASONABLY WET"               "UNSEASONAL LOW TEMP"           
## [893] "UNSEASONAL RAIN"                "UNUSUAL WARMTH"                
## [895] "UNUSUAL/RECORD WARMTH"          "UNUSUALLY COLD"                
## [897] "UNUSUALLY LATE SNOW"            "UNUSUALLY WARM"                
## [899] "URBAN AND SMALL"                "URBAN AND SMALL STREAM"        
## [901] "URBAN AND SMALL STREAM FLOOD"   "URBAN AND SMALL STREAM FLOODIN"
## [903] "Urban flood"                    "Urban Flood"                   
## [905] "URBAN FLOOD"                    "URBAN FLOOD LANDSLIDE"         
## [907] "Urban Flooding"                 "URBAN FLOODING"                
## [909] "URBAN FLOODS"                   "URBAN SMALL"                   
## [911] "URBAN SMALL STREAM FLOOD"       "URBAN/SMALL"                   
## [913] "URBAN/SMALL FLOODING"           "URBAN/SMALL STREAM"            
## [915] "URBAN/SMALL STREAM  FLOOD"      "URBAN/SMALL STREAM FLOOD"      
## [917] "URBAN/SMALL STREAM FLOODING"    "URBAN/SMALL STRM FLDG"         
## [919] "URBAN/SML STREAM FLD"           "URBAN/SML STREAM FLDG"         
## [921] "URBAN/STREET FLOODING"          "VERY DRY"                      
## [923] "VERY WARM"                      "VOG"                           
## [925] "Volcanic Ash"                   "VOLCANIC ASH"                  
## [927] "Volcanic Ash Plume"             "VOLCANIC ASHFALL"              
## [929] "VOLCANIC ERUPTION"              "WAKE LOW WIND"                 
## [931] "WALL CLOUD"                     "WALL CLOUD/FUNNEL CLOUD"       
## [933] "WARM DRY CONDITIONS"            "WARM WEATHER"                  
## [935] "WATER SPOUT"                    "WATERSPOUT"                    
## [937] "WATERSPOUT-"                    "WATERSPOUT-TORNADO"            
## [939] "WATERSPOUT FUNNEL CLOUD"        "WATERSPOUT TORNADO"            
## [941] "WATERSPOUT/"                    "WATERSPOUT/ TORNADO"           
## [943] "WATERSPOUT/TORNADO"             "WATERSPOUTS"                   
## [945] "WAYTERSPOUT"                    "wet micoburst"                 
## [947] "WET MICROBURST"                 "Wet Month"                     
## [949] "WET SNOW"                       "WET WEATHER"                   
## [951] "Wet Year"                       "Whirlwind"                     
## [953] "WHIRLWIND"                      "WILD FIRES"                    
## [955] "WILD/FOREST FIRE"               "WILD/FOREST FIRES"             
## [957] "WILDFIRE"                       "WILDFIRES"                     
## [959] "Wind"                           "WIND"                          
## [961] "WIND ADVISORY"                  "WIND AND WAVE"                 
## [963] "WIND CHILL"                     "WIND CHILL/HIGH WIND"          
## [965] "Wind Damage"                    "WIND DAMAGE"                   
## [967] "WIND GUSTS"                     "WIND STORM"                    
## [969] "WIND/HAIL"                      "WINDS"                         
## [971] "WINTER MIX"                     "WINTER STORM"                  
## [973] "WINTER STORM HIGH WINDS"        "WINTER STORM/HIGH WIND"        
## [975] "WINTER STORM/HIGH WINDS"        "WINTER STORMS"                 
## [977] "Winter Weather"                 "WINTER WEATHER"                
## [979] "WINTER WEATHER MIX"             "WINTER WEATHER/MIX"            
## [981] "WINTERY MIX"                    "Wintry mix"                    
## [983] "Wintry Mix"                     "WINTRY MIX"                    
## [985] "WND"
```

```r
# clean up EVTYPE field
sdata$EVTYPE <- toupper(sdata$EVTYPE)
sdata$EVTYPE <- sub("^\\s+", "", sdata$EVTYPE)
sdata$EVTYPE <- gsub('/', ' ', sdata$EVTYPE)

# first examine health data
# summarize by EVTYPE, examine initial values > 0
health <- ddply(sdata, .(EVTYPE), summarize, SFATAL=sum(FATALITIES), SINJURY=sum(INJURIES))

health <- health[health$SFATAL > 0| health$SINJURY > 0, ]
health[order(-health$SINJURY, -health$SFATAL), ]
```

```
##                             EVTYPE SFATAL SINJURY
## 739                        TORNADO   5633   91346
## 760                      TSTM WIND    504    6957
## 146                          FLOOD    470    6789
## 108                 EXCESSIVE HEAT   1903    6525
## 406                      LIGHTNING    816    5230
## 233                           HEAT    937    2100
## 376                      ICE STORM     89    1975
## 130                    FLASH FLOOD    978    1777
## 669              THUNDERSTORM WIND    133    1488
## 202                           HAIL     15    1361
## 866                   WINTER STORM    206    1321
## 360              HURRICANE TYPHOON     64    1275
## 308                      HIGH WIND    248    1137
## 263                     HEAVY SNOW    127    1021
## 853                       WILDFIRE     75     911
## 695             THUNDERSTORM WINDS     64     908
## 20                        BLIZZARD    101     805
## 161                            FOG     62     734
## 851               WILD FOREST FIRE     12     545
## 97                      DUST STORM     22     440
## 870                 WINTER WEATHER     33     398
## 235                      HEAT WAVE    172     379
## 70                       DENSE FOG     18     342
## 753                 TROPICAL STORM     58     340
## 325                     HIGH WINDS     35     302
## 513                   RIP CURRENTS    204     297
## 588                    STRONG WIND    103     280
## 243                     HEAVY RAIN     98     251
## 512                    RIP CURRENT    368     232
## 117                   EXTREME COLD    162     231
## 185                          GLAZE      7     216
## 11                       AVALANCHE    224     170
## 300                      HIGH SURF    104     156
## 119                   EXTREME HEAT     96     155
## 850                     WILD FIRES      3     150
## 871             WINTER WEATHER MIX     28     140
## 365                            ICE      6     137
## 781                        TSUNAMI     33     129
## 777                 TSTM WIND HAIL      5      95
## 855                           WIND     23      86
## 818           URBAN SML STREAM FLD     28      79
## 873                     WINTRY MIX      1      77
## 387                      LANDSLIDE     38      52
## 490                    RECORD HEAT      2      50
## 293           HEAVY SURF HIGH SURF     42      48
## 49                            COLD     38      48
## 351                      HURRICANE     61      46
## 756          TROPICAL STORM GORDON      8      43
## 840             WATERSPOUT TORNADO      3      43
## 95                      DUST DEVIL      2      43
## 290                     HEAVY SURF      8      40
## 583                    STORM SURGE     13      38
## 566                SNOW HIGH WINDS      0      36
## 575                    SNOW SQUALL      2      35
## 381                      ICY ROADS      5      31
## 549                           SNOW      5      31
## 834                     WATERSPOUT      3      29
## 82                  DRY MICROBURST      3      28
## 727                  THUNDERSTORMW      0      27
## 431       MARINE THUNDERSTORM WIND     10      26
## 441                   MIXED PRECIP      2      26
## 118        EXTREME COLD WIND CHILL    125      24
## 19                       BLACK ICE      1      24
## 168                  FREEZING RAIN      7      23
## 430             MARINE STRONG WIND     14      22
## 590                   STRONG WINDS      8      21
## 112             EXCESSIVE RAINFALL      2      21
## 316             HIGH WIND AND SEAS      3      20
## 790              UNSEASONABLY WARM     11      17
## 869                  WINTER STORMS     10      17
## 743                     TORNADO F2      0      16
## 149              FLOOD FLASH FLOOD     17      15
## 236              HEAT WAVE DROUGHT      4      15
## 165               FREEZING DRIZZLE      2      15
## 868        WINTER STORM HIGH WINDS      1      15
## 187                GLAZE ICE STORM      0      15
## 32                    BLOWING SNOW      2      14
## 60                 COLD WIND CHILL     95      12
## 663                   THUNDERSTORM      1      12
## 201                    GUSTY WINDS      4      11
## 282                 HEAVY SNOW ICE      0      10
## 539                     SMALL HAIL      0      10
## 664            THUNDERSTORM  WINDS      0      10
## 141                 FLASH FLOODING     19       8
## 432               MARINE TSTM WIND      9       8
## 299                      HIGH SEAS      5       8
## 459         NON-SEVERE WIND DAMAGE      0       7
## 344                HIGH WINDS SNOW      3       6
## 124              EXTREME WINDCHILL     17       5
## 584               STORM SURGE TIDE     11       5
## 521                     ROUGH SEAS      8       5
## 429                  MARINE MISHAP      7       5
## 43        COASTAL FLOODING EROSION      0       5
## 783                        TYPHOON      0       5
## 76                         DROUGHT      0       4
## 258                    HEAVY RAINS      0       4
## 339                HIGH WINDS COLD      0       4
## 466                          OTHER      0       4
## 722            THUNDERSTORM WINDSS      0       4
## 751            TORRENTIAL RAINFALL      0       4
## 176                          FROST      1       3
## 180                   FUNNEL CLOUD      0       3
## 765                TSTM WIND (G45)      0       3
## 158                       FLOODING      6       2
## 454                       MUDSLIDE      4       2
## 477                      RAIN SNOW      4       2
## 41                   COASTAL FLOOD      3       2
## 44                   COASTAL STORM      3       2
## 516                    RIVER FLOOD      2       2
## 400                     LIGHT SNOW      1       2
## 426                MARINE ACCIDENT      1       2
## 37                      BRUSH FIRE      0       2
## 113                 EXCESSIVE SNOW      0       2
## 284              HEAVY SNOW SHOWER      0       2
## 352     HURRICANE-GENERATED SWELLS      0       2
## 353              HURRICANE EDOUARD      0       2
## 378          ICE STORM FLASH FLOOD      0       2
## 519                     ROGUE WAVE      0       2
## 744                     TORNADO F3      0       2
## 832                   WARM WEATHER      0       2
## 355                 HURRICANE ERIN      6       1
## 522                     ROUGH SURF      4       1
## 557                   SNOW AND ICE      4       1
## 517                 RIVER FLOODING      2       1
## 127               FALLING SNOW ICE      1       1
## 162      FOG AND COLD TEMPERATURES      1       1
## 197                     GUSTY WIND      1       1
## 358                 HURRICANE OPAL      1       1
## 389                     LANDSLIDES      1       1
## 428               MARINE HIGH WIND      1       1
## 661                    THUNDERSNOW      1       1
## 864                          WINDS      1       1
## 89            DRY MIRCOBURST WINDS      0       1
## 232                 HAZARDOUS SURF      0       1
## 274  HEAVY SNOW BLIZZARD AVALANCHE      0       1
## 296                           HIGH      0       1
## 311                   HIGH WIND 48      0       1
## 320           HIGH WIND HEAVY SNOW      0       1
## 354                HURRICANE EMILY      0       1
## 374                      ICE ROADS      0       1
## 409 LIGHTNING AND THUNDERSTORM WIN      0       1
## 414               LIGHTNING INJURY      0       1
## 462                  NON TSTM WIND      0       1
## 699          THUNDERSTORM WINDS 13      0       1
## 714        THUNDERSTORM WINDS HAIL      0       1
## 726            THUNDERSTORMS WINDS      0       1
## 738                 TIDAL FLOODING      0       1
## 764                TSTM WIND (G40)      0       1
## 792      UNSEASONABLY WARM AND DRY     29       0
## 747     TORNADOES, TSTM WIND, HAIL     25       0
## 488          RECORD EXCESSIVE HEAT     17       0
## 54                   COLD AND SNOW     14       0
## 135              FLASH FLOOD FLOOD     14       0
## 364           HYPOTHERMIA EXPOSURE      7       0
## 422                LOW TEMPERATURE      7       0
## 59                    COLD WEATHER      5       0
## 142           FLASH FLOODING FLOOD      5       0
## 237                     HEAT WAVES      5       0
## 514        RIP CURRENTS HEAVY SURF      5       0
## 322                 HIGH WIND SEAS      4       0
## 42                COASTAL FLOODING      3       0
## 58                       COLD WAVE      3       0
## 260                     HEAVY SEAS      3       0
## 291            HEAVY SURF AND WIND      3       0
## 306                     HIGH WATER      3       0
## 56                COLD TEMPERATURE      2       0
## 77          DROUGHT EXCESSIVE HEAT      2       0
## 144                   FLASH FLOODS      2       0
## 268      HEAVY SNOW AND HIGH WINDS      2       0
## 359      HURRICANE OPAL HIGH WINDS      2       0
## 532                          SLEET      2       0
## 785              UNSEASONABLY COLD      2       0
## 10                        AVALANCE      1       0
## 48                    COASTALSTORM      1       0
## 62                      COLD WINDS      1       0
## 78                        DROWNING      1       0
## 116                  EXTENDED COLD      1       0
## 147             FLOOD & HEAVY RAIN      1       0
## 155              FLOOD RIVER FLOOD      1       0
## 164                         FREEZE      1       0
## 174             FREEZING RAIN SNOW      1       0
## 175                 FREEZING SPRAY      1       0
## 303                    HIGH SWELLS      1       0
## 307                     HIGH WAVES      1       0
## 356                HURRICANE FELIX      1       0
## 362          HYPERTHERMIA EXPOSURE      1       0
## 363                    HYPOTHERMIA      1       0
## 372                    ICE ON ROAD      1       0
## 417                     LIGHTNING.      1       0
## 440                 MINOR FLOODING      1       0
## 456                      MUDSLIDES      1       0
## 478                      RAIN WIND      1       0
## 480           RAPIDLY RISING WATER      1       0
## 482                    RECORD COLD      1       0
## 551              SNOW  BITTER COLD      1       0
## 576                   SNOW SQUALLS      1       0
## 672        THUNDERSTORM WIND (G40)      1       0
## 687          THUNDERSTORM WIND G52      1       0
## 733              THUNDERTORM WINDS      1       0
## 763                TSTM WIND (G35)      1       0
## 806 URBAN AND SMALL STREAM FLOODIN      1       0
## 849                      WHIRLWIND      1       0
## 863                     WIND STORM      1       0
```

```r
# Create a new Event Type field to better summarize 
# add an entry for every significant type, init w/'OTHER'
sdata$TYPE <- "OTHER"
# load primary TYPES
sdata[grepl('TORNADO', sdata$EVTYPE),  ]$TYPE <- "TORNADO"
sdata[grepl('WIND', sdata$EVTYPE),  ]$TYPE <- "WIND"
sdata[grepl('HEAT', sdata$EVTYPE),  ]$TYPE <- "HEAT"
sdata[grepl('WARM', sdata$EVTYPE),  ]$TYPE <- "HEAT"
sdata[grepl('FLOOD', sdata$EVTYPE),  ]$TYPE <- "FLOOD"
sdata[grepl('FLD', sdata$EVTYPE),  ]$TYPE <- "FLOOD"
sdata[grepl('LIGHTN', sdata$EVTYPE),  ]$TYPE <- "LIGHTNING"
sdata[grepl('ICE', sdata$EVTYPE),  ]$TYPE <- "ICE"
sdata[grepl('WINTER', sdata$EVTYPE),  ]$TYPE <- "WINTER WEATHER"
sdata[grepl('WINTRY', sdata$EVTYPE),  ]$TYPE <- "WINTER WEATHER"
sdata[grepl('FIRE', sdata$EVTYPE),  ]$TYPE <- "FIRE"
sdata[grepl('HAIL', sdata$EVTYPE),  ]$TYPE <- "HAIL"
# hurricane & typhoon is a form of tropical cyclone
sdata[grepl('HURRICANE', sdata$EVTYPE),  ]$TYPE <- "CYCLONE"
sdata[grepl('TYPHOON', sdata$EVTYPE),  ]$TYPE <- "CYCLONE"
sdata[grepl('SNOW', sdata$EVTYPE),  ]$TYPE <- "SNOW"
sdata[grepl('FOG', sdata$EVTYPE),  ]$TYPE <- "FOG"
sdata[grepl('ICY', sdata$EVTYPE),  ]$TYPE <- "FOG"
sdata[grepl('FOG', sdata$EVTYPE),  ]$TYPE <- "FOG"
sdata[grepl('BLIZZ', sdata$EVTYPE),  ]$TYPE <- "BLIZZARD"
sdata[grepl('RIP', sdata$EVTYPE),  ]$TYPE <- "RIP CURRENTS"
sdata[grepl('DUST', sdata$EVTYPE),  ]$TYPE <- "DUST STORM"
sdata[grepl('TROPIC', sdata$EVTYPE),  ]$TYPE <- "TROPICAL STORM"
sdata[grepl('RAIN', sdata$EVTYPE),  ]$TYPE <- "RAIN"
sdata[grepl('COLD', sdata$EVTYPE),  ]$TYPE <- "COLD"
sdata[grepl('HYPOTH', sdata$EVTYPE),  ]$TYPE <- "COLD"
sdata[grepl('FREEZ', sdata$EVTYPE),  ]$TYPE <- "COLD"
sdata[grepl('FROST', sdata$EVTYPE),  ]$TYPE <- "COLD"
sdata[grepl('AVALAN', sdata$EVTYPE),  ]$TYPE <- "AVALANCHE"
sdata[grepl('SEAS', sdata$EVTYPE),  ]$TYPE <- "HIGH SEAS"
sdata[grepl('SURF', sdata$EVTYPE),  ]$TYPE <- "HIGH SEAS"
# sdata[grepl('TSUN', sdata$EVTYPE),  ]$TYPE <- "TSUNAMI"
# sdata[grepl('LANDS', sdata$EVTYPE),  ]$TYPE <- "LANDSLIDE"
sdata[grepl('SURGE', sdata$EVTYPE),  ]$TYPE <- "STORM SURGE"
sdata[grepl('TSTM', sdata$EVTYPE),  ]$TYPE <- "THUNDERSTORM"
sdata[grepl('THUNDER', sdata$EVTYPE),  ]$TYPE <- "THUNDERSTORM"
sdata[grepl('WATERSP', sdata$EVTYPE),  ]$TYPE <- "WATERSPOUT"
# many DROUGHT combos, override above others in one DROUGHT category
sdata[grepl('DROUGHT', sdata$EVTYPE),  ]$TYPE <- "DROUGHT"
# See major TYPES
type <- sort(unique(sdata$TYPE))
type 
```

```
##  [1] "AVALANCHE"      "BLIZZARD"       "COLD"           "CYCLONE"       
##  [5] "DROUGHT"        "DUST STORM"     "FIRE"           "FLOOD"         
##  [9] "FOG"            "HAIL"           "HEAT"           "HIGH SEAS"     
## [13] "ICE"            "LIGHTNING"      "OTHER"          "RAIN"          
## [17] "RIP CURRENTS"   "SNOW"           "STORM SURGE"    "THUNDERSTORM"  
## [21] "TORNADO"        "TROPICAL STORM" "WATERSPOUT"     "WIND"          
## [25] "WINTER WEATHER"
```

```r
sdata <- transform(sdata, TYPE = factor(TYPE))
```

__Analyze the Tidy data__

```r
# summary(sdata$BEGIN_DATE)
summary(sdata$BGN_DATE)
```

```
##         Min.      1st Qu.       Median         Mean      3rd Qu. 
## "1950-01-03" "1995-04-20" "2002-03-18" "1998-12-27" "2007-07-28" 
##         Max. 
## "2011-11-30"
```

```r
# summarize damage estimates for health 
health <- ddply(sdata, .(TYPE), summarize, 
                FATALITY=sum(FATALITIES, na.rm = TRUE), INJURY=sum(INJURIES, na.rm = TRUE))
health
```

```
##              TYPE FATALITY INJURY
## 1       AVALANCHE      225    171
## 2        BLIZZARD      101    805
## 3            COLD      470    361
## 4         CYCLONE      135   1333
## 5         DROUGHT        6     19
## 6      DUST STORM       24    483
## 7            FIRE       90   1608
## 8           FLOOD     1552   8681
## 9             FOG       85   1107
## 10           HAIL       15   1371
## 11           HEAT     3132   9211
## 12      HIGH SEAS      231    296
## 13            ICE       97   2154
## 14      LIGHTNING      817   5231
## 15          OTHER      118    473
## 16           RAIN      106    282
## 17   RIP CURRENTS      572    529
## 18           SNOW      148   1162
## 19    STORM SURGE       24     43
## 20   THUNDERSTORM      756   9545
## 21        TORNADO     5633  91364
## 22 TROPICAL STORM       66    383
## 23     WATERSPOUT        6     72
## 24           WIND      457   1876
## 25 WINTER WEATHER      279   1968
```

```r
healthy <- ddply(sdata, .((format(sdata$BGN_DATE, '%Y')), TYPE), summarize, 
                FATALITY=sum(FATALITIES, na.rm = TRUE), INJURY=sum(INJURIES, na.rm = TRUE))
colnames(healthy)[1] <- c("YEAR")
tail(healthy)
```

```
##     YEAR           TYPE FATALITY INJURY
## 586 2011   THUNDERSTORM       57    387
## 587 2011        TORNADO      587   6163
## 588 2011 TROPICAL STORM        4      1
## 589 2011     WATERSPOUT        0      0
## 590 2011           WIND       16     49
## 591 2011 WINTER WEATHER        3      0
```

```r
# ready for health analysis results

# now examine property & crop economic damage
# limit the data frame to only needed columns for economic data
ldata <- sdata[, c(3, 26, 27, 28, 29, 39)]
summary(ldata)
```

```
##     BGN_DATE             PROPDMG      PROPDMGEXP           CROPDMG     
##  Min.   :1950-01-03   Min.   :   0   Length:902297      Min.   :  0.0  
##  1st Qu.:1995-04-20   1st Qu.:   0   Class :character   1st Qu.:  0.0  
##  Median :2002-03-18   Median :   0   Mode  :character   Median :  0.0  
##  Mean   :1998-12-27   Mean   :  12                      Mean   :  1.5  
##  3rd Qu.:2007-07-28   3rd Qu.:   0                      3rd Qu.:  0.0  
##  Max.   :2011-11-30   Max.   :5000                      Max.   :990.0  
##                                                                        
##   CROPDMGEXP                    TYPE       
##  Length:902297      THUNDERSTORM  :336818  
##  Class :character   HAIL          :289281  
##  Mode  :character   FLOOD         : 86073  
##                     TORNADO       : 60684  
##                     WIND          : 26553  
##                     WINTER WEATHER: 19693  
##                     (Other)       : 83195
```

```r
names(ldata)
```

```
## [1] "BGN_DATE"   "PROPDMG"    "PROPDMGEXP" "CROPDMG"    "CROPDMGEXP"
## [6] "TYPE"
```

```r
edata <- ddply(ldata, .(TYPE, PROPDMGEXP, CROPDMGEXP), summarize, 
              PROPDMG = sum(PROPDMG, na.rm=T), CROPDMG = sum(CROPDMG,na.rm=T))
head(edata,3)
```

```
##        TYPE PROPDMGEXP CROPDMGEXP PROPDMG CROPDMG
## 1 AVALANCHE          K          K   285.8       0
## 2 AVALANCHE          K       <NA>  1336.0       0
## 3 AVALANCHE          M          K     2.1       0
```

```r
# examine yearly breakdown
edatay <- ddply(ldata, .(TYPE, (format(BGN_DATE, '%Y')), PROPDMGEXP, CROPDMGEXP), summarize, 
              PROPDMG = sum(PROPDMG, na.rm=T), CROPDMG = sum(CROPDMG,na.rm=T))
colnames(edatay)[2] <- c("YEAR")
tail(edatay)
```

```
##                TYPE YEAR PROPDMGEXP CROPDMGEXP  PROPDMG CROPDMG
## 2144 WINTER WEATHER 2009          M          K    16.00       0
## 2145 WINTER WEATHER 2010          K          K 12053.30       0
## 2146 WINTER WEATHER 2010          K          M     0.00      15
## 2147 WINTER WEATHER 2010          M          K    52.60       0
## 2148 WINTER WEATHER 2011          K          K 13302.00      70
## 2149 WINTER WEATHER 2011          M          K     6.75       0
```

```r
# Focus on areas where damages are in Billions of dollars
bdamage <- edata[edata$PROPDMGEXP %in% ('B')|edata$CROPDMGEXP %in% ('B'), ]
# calaculate damages for crops, property and total in billions
damage <- ddply(bdamage, .(TYPE), summarize, PROPERTY = round(sum(PROPDMG)),
               CROPS = round(sum(CROPDMG)),
               DAMAGES = (round(sum(PROPDMG)) + round(sum(CROPDMG))))
# Damages in Billions
damage
```

```
##              TYPE PROPERTY CROPS DAMAGES
## 1            COLD        0     0       0
## 2         CYCLONE       74  1546    1620
## 3         DROUGHT        0     2       2
## 4            FIRE        3     6       9
## 5           FLOOD      128    38     166
## 6            HAIL        2     0       2
## 7            HEAT        0     0       0
## 8             ICE      500     5     505
## 9            RAIN        2     0       2
## 10    STORM SURGE       47     0      47
## 11   THUNDERSTORM        3     2       5
## 12        TORNADO        5     0       5
## 13 TROPICAL STORM        5     0       5
## 14           WIND        1     0       1
## 15 WINTER WEATHER        5     0       5
```

```r
# Focus on areas by Year where damages are in Billions of dollars
bdamagey <- edatay[edatay$PROPDMGEXP %in% ('B')|edatay$CROPDMGEXP %in% ('B'), ]
# calaculate damages for crops, property and total in billions
damagey <- ddply(bdamagey, .(YEAR, TYPE), summarize, PROPERTY = round(sum(PROPDMG)),
               CROPS = round(sum(CROPDMG)),
               DAMAGES = (round(sum(PROPDMG)) + round(sum(CROPDMG))))
# Damages in Billions
damagey
```

```
##    YEAR           TYPE PROPERTY CROPS DAMAGES
## 1  1993          FLOOD        5     5      10
## 2  1993   THUNDERSTORM        2     2       4
## 3  1993 WINTER WEATHER        5     0       5
## 4  1994            ICE      500     5     505
## 5  1995           COLD        0     0       0
## 6  1995        CYCLONE        3    15      18
## 7  1995        DROUGHT        0     0       0
## 8  1995           HEAT        0     0       0
## 9  1995           RAIN        2     0       2
## 10 1995   THUNDERSTORM        1     0       1
## 11 1997          FLOOD        3     0       3
## 12 1998        CYCLONE        2   301     303
## 13 1999        CYCLONE        3   500     503
## 14 2000           FIRE        2     0       2
## 15 2001 TROPICAL STORM        5     0       5
## 16 2003           FIRE        1     6       7
## 17 2003          FLOOD        1     0       1
## 18 2004        CYCLONE       17   428     445
## 19 2004           WIND        1     0       1
## 20 2005        CYCLONE       49   302     351
## 21 2005    STORM SURGE       43     0      43
## 22 2006        DROUGHT        0     1       1
## 23 2006          FLOOD      115    32     147
## 24 2008        CYCLONE        1     0       1
## 25 2008    STORM SURGE        4     0       4
## 26 2010          FLOOD        2     1       3
## 27 2010           HAIL        2     0       2
## 28 2011        DROUGHT        0     0       0
## 29 2011          FLOOD        3     0       3
## 30 2011        TORNADO        5     0       5
```

```r
# ready for results
```


##Results  


```r
library(ggplot2)
# plot summary health effects 
health2 <- health[health$FATALITY > 0 & health$INJURY > 0, ]
health2$TYPE <- factor(health$TYPE, levels=health[order(health$FATALITY), "TYPE"])

h <- ggplot(health2, aes(y = INJURY,  x = TYPE, fill = FATALITY)) + coord_flip()
h <- h + geom_bar(stat = 'identity', binwidth = 2) 
h <- h + scale_fill_gradient(low="green",high="darkgreen")
h <- h + labs(title = 'Fatalies & Injuries due to Weather Events (1950 - 2011)')
h <- h + xlab('Weather Event Type (Sort on Fatality)')
h <- h + ylab('Injury Tallies (Fatalities in Red)')
h <- h + geom_text(size=3,  angle = 15, color='red', hjust=-0.5, vjust=0, aes(label=FATALITY)) 
print(h)
```

![plot of chunk results_health](./StormDataAnalysis_files/figure-html/results_health.png) 

Tornadoes are far and away the most significant threat in terms of injury and loss of life.  


```r
# plot summary property & crop damages
damage <- damage[order(-damage$DAMAGES), ]
# plot DAMAGES >= 1 billion 
damage2 <- damage[damage$DAMAGES >= 1, ]
damage2$TYPE <- factor(damage2$TYPE, levels=damage2[order(damage2$PROPERTY), "TYPE"])

e <- ggplot(damage2, aes(y = DAMAGES,  x = TYPE,  fill = PROPERTY)) + coord_flip()
e <- e + geom_bar(stat = 'identity', binwidth = 1) 
e <- e + scale_fill_gradient(low="green",high="darkgreen")
e <- e + ggtitle(expression(atop('Property & Crop Economic Losses due to Weather Events ', 
                                 atop(italic('Years 1993 to 2011 (Property in Red Numbers)'), ""))))
e <- e + xlab('Weather Event Type (Sort on Property)')
e <- e + ylab('Total Economic to Property & Crops Damage in Billions')
e <- e + geom_text(size=3,  angle = 15, color='red', hjust=-0.5, vjust=0, aes(label=PROPERTY)) 
print(e)
```

![plot of chunk results_damage](./StormDataAnalysis_files/figure-html/results_damage.png) 

Cyclones (Hurricanes and Tropical Cyclones) generate the most total losses for property and crops combined, but most of this damage is to crops. The types are sorted in terms of damage to property indicating that ice and flooding are a greater threat to property followed by cyclones.


```r
# plot summary property & crop damages
damagey <- damagey[order(damagey$YEAR, -damagey$DAMAGES), ]
# plot DAMAGES >= 1 billion 
damagey2 <- damagey[damagey$DAMAGES >= 1, ]
damagey2
```

```
##    YEAR           TYPE PROPERTY CROPS DAMAGES
## 1  1993          FLOOD        5     5      10
## 3  1993 WINTER WEATHER        5     0       5
## 2  1993   THUNDERSTORM        2     2       4
## 4  1994            ICE      500     5     505
## 6  1995        CYCLONE        3    15      18
## 9  1995           RAIN        2     0       2
## 10 1995   THUNDERSTORM        1     0       1
## 11 1997          FLOOD        3     0       3
## 12 1998        CYCLONE        2   301     303
## 13 1999        CYCLONE        3   500     503
## 14 2000           FIRE        2     0       2
## 15 2001 TROPICAL STORM        5     0       5
## 16 2003           FIRE        1     6       7
## 17 2003          FLOOD        1     0       1
## 18 2004        CYCLONE       17   428     445
## 19 2004           WIND        1     0       1
## 20 2005        CYCLONE       49   302     351
## 21 2005    STORM SURGE       43     0      43
## 23 2006          FLOOD      115    32     147
## 22 2006        DROUGHT        0     1       1
## 25 2008    STORM SURGE        4     0       4
## 24 2008        CYCLONE        1     0       1
## 26 2010          FLOOD        2     1       3
## 27 2010           HAIL        2     0       2
## 30 2011        TORNADO        5     0       5
## 29 2011          FLOOD        3     0       3
```

```r
e <- ggplot(damagey2, aes(y = DAMAGES,  x = YEAR,  fill = TYPE)) 
e <- e + geom_bar(stat = 'identity', binwidth = 1) 
e <- e + ggtitle(expression(atop('Property & Crop Economic Losses due to Weather Events', 
                                 atop(italic('In Billions of Dollars (Years 1993 to 2011)'), ""))))
e <- e + xlab('Year (Damage in Billions)') + theme(axis.text.x = element_text(angle = 45, hjust = 1))
e <- e + ylab('Total Economic Damage')
print(e)
```

![plot of chunk results_damage_year](./StormDataAnalysis_files/figure-html/results_damage_year.png) 
  
Major weather events have Significant impact in damages to crops and property.  
