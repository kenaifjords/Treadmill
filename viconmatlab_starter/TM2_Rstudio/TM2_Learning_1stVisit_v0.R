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
# Read CSV into R
datain <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_v0.csv", header=TRUE, sep=",")


nstep <- datain$stepnumber/datain$maxstepnumber
logstep <- log(datain$stepnumber) # natural log to linearize
effcond <- as.factor(datain$effortcondition)


# STEPLENGTH ASYMMETRY
sla= lmer(slasym ~ as.factor(effortcondition) * logstep  + (1|subj), data = datain)
summary(sla)
confint(sla)
plot_model(sla,"pred")
diag_model(sla)

# STEP TIME ASYMMETRY
sta= lmer(stasym ~ as.factor(effortcondition) + logstep + (1|subj), data = datain)
summary(sta)
confint(sta)
plot_model(sta,"pred")
diag_model(sta)

# tab_model(rxn_rwdtrial,rxn_rwdtrialprior,prt_rwdtrial,pkf_rwdtrial,drt_rwdtrial, t2t_rwdtrial,int_rwdtrial, mvtt_rwdtrial, show.aic = TRUE)
