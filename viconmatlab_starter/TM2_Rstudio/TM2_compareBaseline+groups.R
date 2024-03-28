# load libraries
library(lmerTest)
library(sjPlot)
library(glmmTMB)# work on VMR data based on tutorial from: https://m-clark.github.io/mixed-models-with-R/random_intercepts.html#example-student-gpa
library(car)
library(ggplot2)
library(ggridges)
library(lme4)
library(lmerTest)
#library(moderndive)
library(jtools)
library(sjPlot)
library(sjmisc)
library(car)
library(DHARMa)
library(tidyverse)
library(dplyr)
# Read CSV into R
datain <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_v2.csv", header=TRUE, sep=",")
datain <- na.omit(datain)


# datain <- datain[datain$stepnumber>1,]
# datain <- datain[datain$stepnumber<200,]

nstep <- datain$stepnumber/datain$maxstepnumber
datain$lognstep <-log(nstep)
datain$logstep <- log(datain$stepnumber) # natural log to linearize
datain$sqrtstep <- sqrt(datain$stepnumber)
logasym <- log(datain$slasym + 1)
effcond <- as.factor(datain$effortcondition)
datain$normaddedmass <- datain$addedmass/datain$mass
datain$normleglength <- datain$leglength/datain$height

datain_1Learn = datain[datain$exposure==1,]
datain_1Save = datain[datain$exposure==2,]
datain_2Learn = datain[datain$exposure==3,]
datain_2Save = datain[datain$exposure==4,]

subjparam <- datain %>% group_by(subj) %>% filter(row_number()==1)

# compare groups in effort and treadmill walking
# compare leg length
ggplot(data=subjparam, aes(x = normleglength, y = as.factor(effortcondition), fill = as.factor(effortcondition))) + ggridges::geom_density_ridges()
LLanova <- aov(normleglength~as.factor(effortcondition), data = subjparam, )
summary(LLanova)
# compare height
ggplot(data=datain_1Learn, aes(x = height, y = as.factor(effortcondition), fill = as.factor(effortcondition))) + ggridges::geom_density_ridges()
Hanova <- aov(height~as.factor(effortcondition), data = subjparam, )
summary(Hanova)
# compare body weight
ggplot(data=datain_1Learn, aes(x = mass, y = as.factor(effortcondition), fill = as.factor(effortcondition))) + ggridges::geom_density_ridges()
BWanova <- aov(mass~as.factor(effortcondition), data = subjparam, )
summary(BWanova)
