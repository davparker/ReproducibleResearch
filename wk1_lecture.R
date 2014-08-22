# Coursera Reproducible Research
# Week 1 Lecture Notes

# Structure of a Data Analysis
# Steps in Data Analysis
#  - part 1
# Define the question
# Define the ideal data set
# Determine what data you can access
# Obtain the data
# Clean the data
# Our cleaned data set
#  http://archive.ics.uci.edu/ml/datasets/Spambase
# SPAM - pre cleaned

library(kernlab)
dim(spam)
# [1] 4601   58
data(spam)
# str(spam[, 1:5])
# 'data.frame':  4601 obs. of  5 variables:
#   $ make   : num  0 0.21 0.06 0 0 0 0 0 0.15 0.06 ...
# $ address: num  0.64 0.28 0 0 0 0 0 0 0 0.12 ...
# $ all    : num  0.64 0.5 0.71 0 0 0 0 0 0.46 0.77 ...
# $ num3d  : num  0 0 0 0 0 0 0 0 0 0 ...
# $ our    : num  0.32 0.14 1.23 0.63 0.63 1.85 1.92 1.88 0.61 0.19 ...

# Steps in Data Analysis
#  - part 2
# Exploratory data analysis
# Statistical prediction/modeling
# Interpret results
# Challenge results
# Synthesize/write up results
# Create reproducible code

# Subsampling our data set
# We need to generate a test and training set (prediction)
# If it isn't installed, install the kernlab package
library(kernlab)
data(spam)

# Perform the subsampling
set.seed(3435)
trainIndicator = rbinom(4601, size = 1, prob = 0.5)  # 4601 rows,  coin flip to split db
table(trainIndicator)  # result of ccoin toss
# 0    1 
# 2314 2287

trainSpam <- spam[trainIndicator == 1, ]  # tails
testSpam  <- spam[trainIndicator == 1, ]  # heads

# Exploratory data analysis
# Look at summaries of the data
# Check for missing data
# Create exploratory plots
# Perform exploratory analyses (e.g. clustering)

# Names
names(trainSpam)
# [1] "make"              "address"           "all"               "num3d"             "our"              
# [6] "over"              "remove"            "internet"          "order"             "mail"             
# [11] "receive"           "will"              "people"            "report"            "addresses"        
# [16] "free"              "business"          "email"             "you"               "credit"           
# [21] "your"              "font"              "num000"            "money"             "hp"               
# [26] "hpl"               "george"            "num650"            "lab"               "labs"             
# [31] "telnet"            "num857"            "data"              "num415"            "num85"            
# [36] "technology"        "num1999"           "parts"             "pm"                "direct"           
# [41] "cs"                "meeting"           "original"          "project"           "re"               
# [46] "edu"               "table"             "conference"        "charSemicolon"     "charRoundbracket" 
# [51] "charSquarebracket" "charExclamation"   "charDollar"        "charHash"          "capitalAve"       
# [56] "capitalLong"       "capitalTotal"      "type"      


# Head
head(trainSpam)

# make address  all num3d  our over remove internet order mail receive will people report addresses
# 1  0.00    0.64 0.64     0 0.32 0.00   0.00        0  0.00 0.00    0.00 0.64   0.00      0         0
# 7  0.00    0.00 0.00     0 1.92 0.00   0.00        0  0.00 0.64    0.96 1.28   0.00      0         0
# 9  0.15    0.00 0.46     0 0.61 0.00   0.30        0  0.92 0.76    0.76 0.92   0.00      0         0
# 12 0.00    0.00 0.25     0 0.38 0.25   0.25        0  0.00 0.00    0.12 0.12   0.12      0         0
# 14 0.00    0.00 0.00     0 0.90 0.00   0.90        0  0.00 0.90    0.90 0.00   0.90      0         0
# 16 0.00    0.42 0.42     0 1.27 0.00   0.42        0  0.00 1.27    0.00 0.00   0.00      0         0
# free business email  you credit your font num000 money hp hpl george num650 lab labs telnet num857
# 1  0.32        0  1.29 1.93   0.00 0.96    0      0  0.00  0   0      0      0   0    0      0      0
# 7  0.96        0  0.32 3.85   0.00 0.64    0      0  0.00  0   0      0      0   0    0      0      0
# 9  0.00        0  0.15 1.23   3.53 2.00    0      0  0.15  0   0      0      0   0    0      0      0
# 12 0.00        0  0.00 1.16   0.00 0.77    0      0  0.00  0   0      0      0   0    0      0      0
# 14 0.00        0  0.00 2.72   0.00 0.90    0      0  0.00  0   0      0      0   0    0      0      0
# 16 1.27        0  0.00 1.70   0.42 1.27    0      0  0.42  0   0      0      0   0    0      0      0
# data num415 num85 technology num1999 parts pm direct cs meeting original project re edu table
# 1  0.00      0     0          0    0.00     0  0   0.00  0       0      0.0       0  0   0     0
# 7  0.00      0     0          0    0.00     0  0   0.00  0       0      0.0       0  0   0     0
# 9  0.15      0     0          0    0.00     0  0   0.00  0       0      0.3       0  0   0     0
# 12 0.00      0     0          0    0.00     0  0   0.00  0       0      0.0       0  0   0     0
# 14 0.00      0     0          0    0.00     0  0   0.00  0       0      0.0       0  0   0     0
# 16 0.00      0     0          0    1.27     0  0   0.42  0       0      0.0       0  0   0     0
# conference charSemicolon charRoundbracket charSquarebracket charExclamation charDollar charHash
# 1           0         0.000            0.000                 0           0.778      0.000    0.000
# 7           0         0.000            0.054                 0           0.164      0.054    0.000
# 9           0         0.000            0.271                 0           0.181      0.203    0.022
# 12          0         0.022            0.044                 0           0.663      0.000    0.000
# 14          0         0.000            0.000                 0           0.000      0.000    0.000
# 16          0         0.000            0.063                 0           0.572      0.063    0.000
# capitalAve capitalLong capitalTotal type
# 1       3.756          61          278 spam
# 7       1.671           4          112 spam
# 9       9.744         445         1257 spam
# 12      1.243          11          184 spam
# 14      2.083           7           25 spam
# 16      5.659          55          249 spam

# Summaries
summary(trainSpam$type)
# nonspam    spam 
# 1381     906 

# Plots
# avg number capital letters 
plot(trainSpam$capitalAve ~ trainSpam$type)
# difficult to look, data are highly skewed
# appears might by a correlation at first glance

# look at log transformation
# amplify the results | add 1 because some instances are 0
# ok to  add 1 for exploratory
plot(log10(trainSpam$capitalAve + 1) ~ trainSpam$type)
# results are obvious corelation
# spam messages have much higher correlation with capitals than nonspam

# Relationships between predictors
# pairwise relationship
plot(log10(trainSpam[, 1:4] + 1))
# (paris plot?)

# Clustering
# hierarchical clustering analysis HCA
hCluster <- hclust(dist(t(trainSpam[, 1:57])))
plot(hCluster)
# dendrogram
# capitalTotalseems to stand out

# New Clustering (minus capitalLong & capitalTotal)
hClusterUpdated <- hclust(dist(t(log10(trainSpam[, 1:55] +1))))
plot(hClusterUpdated)
# Cluster Dendogram
# capitalAve, you, your, will stand out

# Statistical prediction/modeling
# Should be informed by the results of your exploratory analysis
# Exact methods depend on the question of interest
# Transformations/processing should be accounted for when necessary
# Measures of uncertainty should be reported

# Logistic regression model ***
trainSpam$numType <- as.numeric(trainSpam$type) - 1
costFunction  <- function(x, y) sum(x != (y > 0.5))
cvError <- rep(NA, 55)
library(boot)
for(i in 1:55) {
  lmFormula <- reformulate(names(trainSpam)[i], response = "numType")
  glmFit <- glm(lmFormula, family = "binomial", data = trainSpam)
  cvError[i] <- cv.glm(trainSpam, glmFit, costFunction, 2)$delta[2]
}
# Which predictor has minimum cross-validated error?
# the variable that has minimum cross validated error rate
#  trying to find best predictor of spam for a single variable
names(trainSpam)[which.min(cvError)]
# There were 50 or more warnings (use warnings() to see the first 50)
# [1] "charDollar"    (number of $ in a message)
warnings()
# 1 thru 50: glm.fit: fitted probabilities numerically 0 or 1 occurred

# Get a measure of uncertainty
# Use the best model from the group
predictionModel <- glm(numType ~ charDollar, family = "binomial", data = trainSpam)
# Get predictions on the test set
predictionTest <- predict(predictionModel, testSpam)
predictedSpam <- rep("nonspam", dim(testSpam)[1])
# Classify as `spam' for those with prob > 0.5
predictedSpam[predictionModel$fitted > 0.5] <- "spam"




# Get a measure of uncertainty
# Classification table
table(predictedSpam, testSpam$type)
# 
# predictedSpam nonspam spam
# nonspam 1346 458
#    spam 61 449
# Error rate
(61+ 458)/(1346+ 458+ 61+ 449)
# [1] 0.2243

