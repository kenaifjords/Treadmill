# load libraries
library(lmerTest)
library(sjPlot)
library(glmmTMB)# work on VMR data based on tutorial from: https://m-clark.github.io/mixed-models-with-R/random_intercepts.html#example-student-gpa
library(car)
library(ggplot2)
library(lme4)
library(lmerTest)
#library(moderndive)
library(jtools)
library(sjPlot)
library(sjmisc)
library(car)
library(DHARMa)
library(tidyverse)
# Read CSV into R
datain <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_allblk.csv", header=TRUE, sep=",")
datain <- na.omit(datain)

nstep <- datain$stepnumber/datain$maxstepnumber
datain$lognstep <-log(nstep)
datain$logstep <- log(datain$stepnumber) # natural log to linearize
datain$sqrtstep <- sqrt(datain$stepnumber)
logasym <- log(datain$slasym + 1)
effcond <- as.factor(datain$effortcondition)
datain$normaddedmass <- datain$addedmass/datain$mass

datain_1Learn = datain[datain$exposure==1,]
datain_1Save = datain[datain$exposure==2,]
datain_2Learn = datain[datain$exposure==3,]
datain_2Save = datain[datain$exposure==4,]

data_baseline = datain[datain$block<4,]

blk_list<-[1 2 3 4 5 6 7]

## VARIABILITY
## in baseline
# calculate the variance for each block
subjlist <- unique(datain$subj)
slv = data.frame()
for (subji in  subjlist) {
  for (blki in c(1, 3)) {
    b1 <- data_baseline[data_baseline$block==blki,]
    b1 <- b1[b1$subj == subji,]
    sl <- c(b1$steplengthR, b1$steplengthL)
    slv0 <- var(sl)
    slvin <- c(subji,blki,slv0)
    slv <- rbind(slv,slvin)
  }
}
colnames(slv) <- c('subj','block','variance')    
# repeated measures ANOVA for slow baseline in block 1 and block 3
rmv <- 