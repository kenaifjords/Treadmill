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
library(detectseparation)
library(hglm)

# Read CSV into R
dataparam <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_param.csv", header=TRUE, sep=",")
dataparam <- na.omit(dataparam)
dataparam$effortcondition[dataparam$effortcondition == 3] <- 0
dataparam$numberofvisits = dataparam$twovisit + 1
dataparam$norm_added_mass <- dataparam$added_mass/dataparam$mass
dataparam$zplat <- 1/2 * log((1 + dataparam$sla_plateau) / (1 - dataparam$sla_plateau))#(dataparam$sla_plateau + 1)/2
dataparam$logsslearnrate <- log(dataparam$ss_learnrate)
data_rot <- dataparam[dataparam$exposure>0,]# removes the washout blocks
data_twovisit <- dataparam[dataparam$twovisit==1,] # selects participants that completed 2 visits
data_tworot <- data_twovisit[data_twovisit$exposure>0,] # removes washout for participants that completed 2 visits
data_visit2only <- dataparam[dataparam$exposure>2,] # keeps only data from the second visit
data_expose2 <- dataparam[dataparam$exposure>1,]
data_expose2to3 <-data_expose2[data_expose2$exposure<4,]






# learning rates (at different exposures)
sLR = lmer(sla_plateau ~ as.factor(effortcondition) + exposure  + 
           (0 + exposure|numberofvisits) + (1|as.factor(numberofvisits):subj),
          data = data_rot, REML = FALSE)

################################################################################

# log link for constrained learning rate
sLR1 = hglm2(ss_learnrate ~ as.factor(effortcondition) + 
            as.factor(numberofvisits)  * exposure +
            (1 + exposure | subj), family = binomial(link = "logit"),
            data = data_rot)
summary(sLR1)

sLR3 = hglm2(ss_learnrate ~ norm_added_mass + 
               as.factor(numberofvisits)  * exposure +
               (1 + exposure | subj), family = binomial(link = "logit"),
             data = data_rot)
summary(sLR3)
plot(sLR3)

# log link for constrained remembering
sRF1 = hglm2(ss_remember ~ as.factor(effortcondition) + 
               as.factor(numberofvisits)  * exposure +
               (1 + exposure | subj), family = binomial(link = "logit"),
             data = data_rot)
summary(sRF1)

# log transformed learning rate
sLR2 = lmer(logsslearnrate ~ as.factor(effortcondition) + 
              as.factor(numberofvisits) * exposure + 
              (1 + exposure | subj),
            data = data_rot)
summary(sLR2)

sLR4 = lmer(logsslearnrate ~ norm_added_mass + 
              as.factor(numberofvisits) * exposure + 
              (1 + exposure | subj),
            data = data_rot)
summary(sLR4)

# z transformed plateau values (to map to a normal distribution)
splat1 = lmer(zplat ~ as.factor(effortcondition) + 
              as.factor(numberofvisits)  * exposure +
              (1 + exposure | subj),
            data = data_rot)
summary(splat1)

# exponential learning rate
eLR1 = hglm2(exp_learnrate ~ as.factor(effortcondition) +
              as.factor(numberofvisits) * exposure + 
              (1 + exposure | subj), family = binomial(link = "logit"),
            data = data_rot)
summary(eLR1)
plot_model(eLR1,"diag")
plot(eLR1)


###############################################################################
# USING TWO VISIT DATA ONLY 

tvSLR = hglm2(ss_learnrate ~ as.factor(effortcondition) + exposure +
                as.factor(twovisit_group) + (1|subj),
              family = binomial(link = "logit"),
              data = data_tworot)
summary(tvSLR)
plot(tvSLR)


tvSplat = lmer(zplat ~ as.factor(effortcondition) + exposure +
                as.factor(twovisit_group) + (1|subj),
              data = data_tworot)
summary(tvSplat)
plot_model(tvSplat,"diag")
confint(tvSplat)

# exponential learning rate
tveLR1 = hglm2(exp_learnrate ~ as.factor(effortcondition) + exposure + 
               as.factor(twovisit_group) + (1 | subj),
             family = binomial(link = "logit"),
             data = data_tworot)
summary(tveLR1)
plot_model(tveLR1,"diag")
plot(tveLR1)







summary(sLR)
 # confint(sLR)
plot_model(sLR,"diag")
plot(sLR)

ggplot(data=data_rot, aes(x=exposure, y=sla_plateau, col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")

ggplot(data=data_rot, aes(x=exposure, y=sla_plateau, col=as.factor(twovisit_group)))+geom_point()+geom_smooth(method="lm")

ggplot(data=data_rot, aes(x=exposure, y=ss_learnrate, col=as.factor(twovisit_group)))+geom_point()+geom_smooth(method="lm")


###### learning rates (at different exposures) ################################

# based on exposure - for people who completed 4 exposures
ggplot(data=data_rot,
       aes(x=exposure, y = ss_learnrate,col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
ggplot(data=data_rot,
       aes(x=exposure, y = sla_plateau,col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
ggplot(data = data_visit2only,
       aes(x = exposure, y = ss_learnrate,col = as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
ggplot(data = data_expose2to3,
       aes(x = exposure, y = ss_learnrate,col = as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
# added mass
sLM = lmer(ss_learnrate ~ 1 + (1|subj:visit) + (1|visit),
           data = data_rot, REML = FALSE)
update(SLM,method="detect_separation")
summary(sLM)
  # confint(sLR)
plot_model(sLM,"diag")
plot(sLM)
# effort condidtion
sLec = lmer(ss_learnrate ~ as.factor(twovisit_group) * exposure + (1|subj),
            data = data_rot, REML = FALSE)
summary(sLec)
plot_model(sLec,"diag")
plot(sLec)

# based on exposure - including all subjects
ggplot(data=data_rot,
       aes(x=exposure, y=ss_learnrate,col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
# added mass
sLM = lmer(ss_learnrate ~ norm_added_mass + exposure  + (1|subj),
           data = data_rot, REML = FALSE)
summary(sLM)
# confint(sLR)
plot_model(sLM,"diag")
plot(sLM)
# effort condidtion
sLec = lmer(ss_learnrate ~ as.factor(effortcondition) + exposure + (1|subj),
            data = data_rot, REML = FALSE)
summary(sLec)
plot_model(sLec,"diag")
plot(sLec)

sLM1 = lmer(ss_learnrate ~ norm_added_mass + exposure + as.factor(twovisit_group) + (1|subj),
           data = data_tworot, REML = FALSE)
sLec1 = lmer(ss_learnrate ~ as.factor(effortcondition) + exposure + as.factor(twovisit_group) + (1|subj),
            data = data_tworot, REML = FALSE)
sLM2 = lmer(exp_learnrate ~ norm_added_mass + exposure  + as.factor(twovisit_group) + (1|subj),
            data = data_tworot, REML = FALSE)
sLec2 = lmer(exp_learnrate ~ as.factor(effortcondition) + exposure + as.factor(twovisit_group) + (1|subj),
             data = data_tworot, REML = FALSE)
sLM3 = lmer(sla_plateau ~ norm_added_mass + exposure + as.factor(twovisit_group) + (1|subj),
            data = data_tworot, REML = FALSE)
sLec3 = lmer(sla_plateau ~  as.factor(effortcondition) + exposure + as.factor(twovisit_group) + (1|subj),
             data = data_tworot, REML = FALSE)


tab_model(sLec1, sLM1, sLec2, sLM2,sLec3, sLM3)

sLM4 = lmer(ss_remember ~ norm_added_mass + exposure  + (1|subj),
            data = data_rot, REML = FALSE)
sLec4 = lmer(ss_remember ~ as.factor(effortcondition) + exposure + (1|subj),
             data = data_rot, REML = FALSE)
sLM5 = lmer(exp_coef ~ norm_added_mass + exposure  + (1|subj),
            data = data_rot, REML = FALSE)
sLec5 = lmer(exp_coef ~ as.factor(effortcondition) + exposure + (1|subj),
             data = data_rot, REML = FALSE)
sLM6 = lmer(exp_const ~ norm_added_mass + exposure  + (1|subj),
            data = data_rot, REML = FALSE)
sLec6 = lmer(exp_const ~  as.factor(effortcondition) + exposure + (1|subj),
             data = data_rot, REML = FALSE)

tab_model(sLec4, sLM4, sLec5, sLM5,sLec6, sLM6)


# binned
sLM_a = lmer(sla_initial ~ norm_added_mass + exposure  + (1|subj),
            data = data_rot, REML = FALSE)
sLec_a = lmer(sla_initial ~  as.factor(effortcondition) + exposure + (1|subj),
             data = data_rot, REML = FALSE)
sLM_b = lmer(sla_early ~ norm_added_mass + exposure  + (1|subj),
            data = data_rot, REML = FALSE)
sLec_b = lmer(sla_early ~  as.factor(effortcondition) + exposure + (1|subj),
             data = data_rot, REML = FALSE)
sLM_c = lmer(sla_late ~ norm_added_mass + exposure  + (1|subj),
            data = data_rot, REML = FALSE)
sLec_c = lmer(sla_late ~  as.factor(effortcondition) + exposure + (1|subj),
             data = data_rot, REML = FALSE)
sLM_d = lmer(sla_plateau ~ norm_added_mass + exposure  + (1|subj),
            data = data_rot, REML = FALSE)
sLec_d = lmer(sla_plateau ~  as.factor(effortcondition) + exposure + (1|subj),
             data = data_rot, REML = FALSE)

tab_model(sLec_a, sLM_a, sLec_b, sLM_b, sLec_c, sLM_c, sLec_d, sLM_d)

