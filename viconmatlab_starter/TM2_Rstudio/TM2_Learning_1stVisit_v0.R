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
# Read CSV into R
datain <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_v0.csv", header=TRUE, sep=",")
datain <- na.omit(datain)
datain <- datain[datain$stepnumber>1,]

nstep <- datain$stepnumber/datain$maxstepnumber
datain$lognstep <-log(nstep)
datain$logstep <- log(datain$stepnumber) # natural log to linearize
logasym <- log(datain$slasym + 1)
effcond <- as.factor(datain$effortcondition)
datain$normaddedmass <- datain$addedmass/datain$mass

# STEPLENGTH ASYMMETRY
sla= lmer(slasym ~ as.factor(effortcondition) * logstep  + (1|subj),
          data = datain[datain$stepnumber<200,], REML = FALSE)
summary(sla)
confint(sla)
plot_model(sla,"pred")
diag_model(sla)
plot(sla)

ggplot(data=datain, aes(x=stepnumber, y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
ggplot(data=datain, aes(x=log(stepnumber), y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

# Use Linear model to select weights for each point
sla_lm= lm(slasym ~ as.factor(effortcondition) * logstep, data = datain[datain$stepnumber<200,])
summary(sla_lm)
plot(sla_lm)

wt <- 1/lm(abs(sla_lm$residuals) ~ sla_lm$fitted.values)$fitted.values^2

sla_wt = lmer(slasym ~ as.factor(effortcondition) * logstep  + (1|subj), 
          data = datain[datain$stepnumber<200,], 
          weights = wt,
          REML = FALSE)
summary(sla_wt)


# could add a random slope
sla_rs= lmer(slasym ~ as.factor(effortcondition) * logstep +  (1+ logstep | subj), data = datain[datain$stepnumber<200,], REML = FALSE)
summary(sla_rs)
plot(sla_rs)

# with continuous and normed added mass
sla_mass= lmer(slasym ~ normaddedmass * logstep  + (1|subj), data = datain[datain$stepnumber<200,], REML = FALSE)
summary(sla_mass)
ggplot(data=datain, aes(x=stepnumber, y=slasym, col=normaddedmass))+geom_point()+geom_smooth(method="lm")
ggplot(data=datain, aes(x=log(stepnumber), y=slasym, col=normaddedmass))+geom_point()+geom_smooth(method="lm")

sla_mass_lm= lm(slasym ~ normaddedmass * logstep, data = datain[datain$stepnumber<200,])
summary(sla_mass_lm)
plot(sla_mass_lm)

wt <- 1/lm(abs(sla_mass_lm$residuals) ~ sla_mass_lm$fitted.values)$fitted.values^2

sla_mass_wt = lmer(slasym ~ normaddedmass * logstep  + (1|subj), 
              data = datain[datain$stepnumber<200,], 
              weights = wt,
              REML = FALSE)
summary(sla_mass_wt)

tab_model(sla, sla_wt,sla_rs,sla_mass, sla_mass_wt, show.aic = TRUE)
anova(sla,sla_ll)

# TRY A GLM
# for a bounded distribution
# fischer z transformation
# gamma using asym + 1

# STEP TIME ASYMMETRY
sta= lmer(stasym ~ as.factor(effortcondition) * logstep + (1|subj), data = datain)
summary(sta)
confint(sta)
plot_model(sta,"pred")
diag_model(sta)

# tab_model(rxn_rwdtrial,rxn_rwdtrialprior,prt_rwdtrial,pkf_rwdtrial,drt_rwdtrial, t2t_rwdtrial,int_rwdtrial, mvtt_rwdtrial, show.aic = TRUE)
