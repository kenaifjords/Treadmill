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
datain <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_v3.csv", header=TRUE, sep=",")
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

datain_1Learn = datain[datain$exposure==1,]
datain_1Save = datain[datain$exposure==2,]
datain_2Learn = datain[datain$exposure==3,]
datain_2Save = datain[datain$exposure==4,]

# STEPLENGTH ASYMMETRY - ALL DATA
sla_allexposure = lmer(slasym ~ as.factor(effortcondition) * logstep + as.factor(exposure) + (1|subj),
          data = datain[datain$stepnumber<200,], REML = FALSE)
summary(sla_allexposure) #confint(sla) #plot_model(sla,"pred") #diag_model(sla)
plot(sla_allexposure)

# 1 Learn
# if we want factors to reference the control group
datain_1Learn$effortcondition[datain_1Learn$effortcondition == 3] = 0

sla_1learn = lmer(slasym ~ as.factor(effortcondition) * logstep + (1|subj),
                       data = datain_1Learn[datain_1Learn$stepnumber<200,], REML = FALSE)
summary(sla_1learn) #confint(sla) #plot_model(sla,"pred") #diag_model(sla)
plot(sla_1learn)
confint(sla_1learn)
ggplot(data=datain_1Learn, aes(x=log(stepnumber), y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
#ggplot(data=datain_1Learn, aes(x=stepnumber, y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

# learn 1 with normalized added weight
sla_1learn_weight = lmer(slasym ~ normaddedmass * logstep + (1|subj),
                  data = datain_1Learn[datain_1Learn$stepnumber<200,], REML = FALSE)
summary(sla_1learn_weight)
confint(sla_1learn_weight)



sla_1learn_sqr= lmer(slasym ~ as.factor(effortcondition) * sqrtstep + (1|subj),
                  data = datain_1Learn[datain_1Learn$stepnumber<200,], REML = FALSE)
summary(sla_1learn_sqr) #confint(sla) #plot_model(sla,"pred") #diag_model(sla)
plot(sla_1learn_sqr)
ggplot(data=datain_1Learn, aes(x=sqrtstep, y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
#ggplot(data=datain_1Learn, aes(x=stepnumber, y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")


# 2 RELearn
sla_1save = lmer(slasym ~ as.factor(effortcondition) * logstep + (1|subj),
                  data = datain_1Save[datain_1Save$stepnumber<200,], REML = FALSE)
summary(sla_1save) #confint(sla) #plot_model(sla,"pred") #diag_model(sla)
plot(sla_1save)
confint(sla_1save)
ggplot(data=datain_1Save, aes(x=log(stepnumber), y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")


# 3 Learn2
sla_2learn = lmer(slasym ~ as.factor(effortcondition) * logstep + (1|subj),
                  data = datain_2Learn[datain_2Learn$stepnumber<200,], REML = FALSE)
summary(sla_2learn) #confint(sla) #plot_model(sla,"pred") #diag_model(sla)
plot(sla_2learn)
confint(sla_2learn)
ggplot(data=datain_2Learn, aes(x=log(stepnumber), y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

# 2 RELearn
sla_2save = lmer(slasym ~ as.factor(effortcondition) * logstep + (1|subj),
                 data = datain_2Save[datain_2Save$stepnumber<200,], REML = FALSE)
summary(sla_2save) #confint(sla) #plot_model(sla,"pred") #diag_model(sla)
plot(sla_2save)
confint(sla_2save)

ggplot(data=datain_2Save, aes(x=log(stepnumber), y=slasym, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

tab_model(sla_1learn, sla_1learn_weight) #,sla_2learn,sla_2save)
