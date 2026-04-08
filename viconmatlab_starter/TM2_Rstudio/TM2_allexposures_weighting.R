# TM2_LMIXED
rm(list = ls())
#### Libraries ####
library(lme4)
library(ggplot2)
library(nlme)
library(MASS)
library(nls2)
library(nlstools)
library(car)
library(lattice)
library(boot)
library(plyr)
library(grid)
library(gridExtra)
library(latticeExtra)
library(Hmisc)
library(fda)
library(MASS)
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

### LOAD DATA ###
datain <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_v4.csv", header=TRUE, sep=",")
datain <- na.omit(datain)
datain <- datain[datain$stepnumber>1,]

nstep <- datain$stepnumber/datain$maxstepnumber
datain$lognstep <-log(nstep)
datain$logstep <- log(datain$stepnumber) # natural log to linearize
datain$logasym <- log(datain$slasym + 1)
effcond <- as.factor(datain$effortcondition)
datain$normaddedmass <- datain$addedmass/datain$mass
datain$effortcondition[datain$effortcondition == 3]=0

datain_1Learn = datain[datain$exposure==1,]
datain_1Save = datain[datain$exposure==2,]
datain_2Learn = datain[datain$exposure==3,]
datain_2Save = datain[datain$exposure==4,]

# STEPLENGTH ASYMMETRY

# inital learning with effort condition
sla= lmer(slasym ~ as.factor(effortcondition) * logstep  + (1|subj),
          data = datain_1Learn, REML = FALSE)
summary(sla)
confint(sla)
plot_model(sla,"diag")
diag_model(sla)
plot(sla)

ggplot(data=datain_1Learn, aes(x=stepnumber, y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
ggplot(data=datain_1Learn, aes(x=log(stepnumber), y=(slasym), col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

# Use Linear model to select weights for each point
sla_lm= lm(slasym ~ as.factor(effortcondition) * logstep, data = datain_1Learn)

wt <- 1/lm(abs(sla_lm$residuals) ~ sla_lm$fitted.values)$fitted.values^2

sla_wt = lmer(slasym ~ as.factor(effortcondition) * logstep  + (1|subj), 
              data = datain_1Learn, 
              weights = wt,
              REML = FALSE)
summary(sla_wt)
confint(sla_wt)
plot_model(sla_wt,"diag")

# inital learning with added weight
sla_mass = lmer(slasym ~ normaddedmass * logstep  + (1|subj),
          data = datain_1Learn, REML = FALSE)
summary(sla_mass)
confint(sla_mass)

ggplot(data=datain_1Learn, aes(x=stepnumber, y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
ggplot(data=datain_1Learn, aes(x=log(stepnumber), y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

# Use Linear model to select weights for each point
sla_lm= lm(slasym ~ normaddedmass * logstep, data = datain_1Learn)

wt <- 1/lm(abs(sla_lm$residuals) ~ sla_lm$fitted.values)$fitted.values^2

sla_mass_wt = lmer(slasym ~ normaddedmass * logstep  + (1|subj), 
              data = datain_1Learn, 
              weights = wt,
              REML = FALSE)
summary(sla_mass_wt)
confint(sla_mass_wt)

# ALL EXPOSURES use all data, all exposures #####################################
# using effort condition
sla_all = lmer(slasym ~ as.factor(effortcondition) * logstep + exposure * exposeinday  + (1|subj),
          data = datain, REML = FALSE)
summary(sla_all)
confint(sla_all)
plot_model(sla_all,"diag")
diag_model(sla_all)
plot(sla_all)

ggplot(data=datain, aes(x=stepnumber, y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
ggplot(data=datain, aes(x=log(stepnumber), y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

# Use Linear model to select weights for each point
sla_lm= lm(slasym ~ as.factor(effortcondition) * logstep + exposure * exposeinday, data = datain)

wt <- 1/lm(abs(sla_lm$residuals) ~ sla_lm$fitted.values)$fitted.values^2

sla_all_wt = lmer(slasym ~ as.factor(effortcondition) * logstep + exposure * exposeinday  + (1|subj),
                   data = datain, 
                   weights = wt,
                   REML = FALSE)
summary(sla_all_wt)
confint(sla_all_wt)
plot_model(sla_all_wt,"diag")

tab_model(sla_all,sla_all_wt, show.aic = TRUE)

# using added mass
sla_mass_all = lmer(slasym ~ normaddedmass * logstep + exposure * exposeinday  + (1|subj),
               data = datain, REML = FALSE)
summary(sla_mass_all)
confint(sla_mass_all)
plot_model(sla_mass_all,"pred")
diag_model(sla_mass_all)
plot(sla_mass_all)

ggplot(data=datain, aes(x=stepnumber, y=slasym, col=normaddedmass))+geom_point()+geom_smooth(method="lm")
ggplot(data=datain, aes(x=log(stepnumber), y=slasym, col=normaddedmass))+geom_point()+geom_smooth(method="lm")

# Use Linear model to select weights for each point
sla_mass_lm= lm(slasym ~ normaddedmass * logstep + exposure * exposeinday, data = datain)

wt <- 1/lm(abs(sla_lm$residuals) ~ sla_lm$fitted.values)$fitted.values^2

sla_allmass_wt = lmer(slasym ~ normaddedmass * logstep + exposure * exposeinday  + (1|subj),
                  data = datain, 
                  weights = wt,
                  REML = FALSE)
summary(sla_allmass_wt)
confint(sla_allmass_wt)
plot_model(sla_allmass_wt,"diag")

tab_model(sla_mass_all,sla_allmass_wt, show.aic = TRUE)
