# load libraries
library(sjPlot)
library(ggplot2)
library(ggpubr)

# Read CSV into R
dataparam <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_param.csv", header=TRUE, sep=",")
dataparam <- na.omit(dataparam)

colslabin <- c("sla_initial","sla_early","sla_late","sla_plateau",
               "sta_initial","sta_early","sta_late","sta_plateau",
               "swa_initial","swa_early","sla_late","swa_plateau")

anova_bin <- list()

for (col in colslabin) {
  formula <- as.formula(paste( col, "~ effortcondition"))
  anova_bin[[col]] <- aov(formula, data = dataparam[dataparam$visit == 1 & dataparam$block == 4,])
  #summary(anova_bin[[col]])
  boxplot(formula, data = dataparam[dataparam$visit == 1 & dataparam$block == 4,],
            frame = FALSE,
            xlab = "effort condition", ylab = col,
          main=sprintf(p = %1.3,anova_bin[[col]])
}

###################################################################################################################################
dataparam$effortcondition[dataparam$effortcondition == 3] <- 0
dataparam$numberofvisits = dataparam$twovisit + 1
dataparam$norm_added_mass <- dataparam$added_mass/dataparam$mass
dataparam$zplat <- 1/2 * log((1 + dataparam$sla_plateau) / (1 - dataparam$sla_plateau))#(dataparam$sla_plateau + 1)/2
dataparam$logsslearnrate <- log(dataparam$ss_learnrate)
dataparam$normsla <- (dataparam$sla_plateau + 1) / 2
data_rot <- dataparam[dataparam$exposure>0,]# removes the washout blocks
data_twovisit <- dataparam[dataparam$twovisit==1,] # selects participants that completed 2 visits
data_tworot <- data_twovisit[data_twovisit$exposure>0,] # removes washout for participants that completed 2 visits
data_visit2only <- dataparam[dataparam$exposure>2,] # keeps only data from the second visit
data_expose2 <- dataparam[dataparam$exposure>1,]
data_expose2to3 <-data_expose2[data_expose2$exposure<4,]

# plots for learning rate ######################################################
# all participants, all exposures, sorted by effort condition, this mixes up subjects between the visits
ggplot(data=data_rot,
       aes(x=exposure, y = ss_learnrate,col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
# all participants, all exposures, sorted by first effort condition
ggplot(data=data_rot,
       aes(x=exposure, y = ss_learnrate,col=as.factor(firsteff)))+geom_point()+geom_smooth(method="lm")
# this includes only the second visit learning and relearning, sorted by effort condition, mixing between subjects
ggplot(data = data_visit2only,
       aes(x = exposure, y = ss_learnrate,col = as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
# this includes only relearning in visit 1 and learning in visit 2, sorted by first effort condition
ggplot(data = data_expose2to3,
       aes(x = exposure, y = ss_learnrate,col = as.factor(firsteff)))+geom_point()+geom_smooth(method="lm")
      # are these slopes different

# models ss_learning rate ######################################################
# metrics for ss parameters are constrained to [0 1] and [-1 1]
ss_rate1 = hglm2(ss_learnrate ~ as.factor(firsteff) + exposure + (1| subj),
                 family = binomial(link = "logit"), data = data_twovisit, REML = FALSE)
summary(ss_rate1)
plot(ss_rate1)

ss_rate2 = hglm2(ss_learnrate ~ as.factor(effortcondition) + exposure * as.factor(numberofvisits) + (1 + numberofvisits | subj),
                               family = binomial(link = "logit"), data = data_rot, REML = FALSE)
summary(ss_rate2)

ss_rate3 = hglm2(ss_learnrate ~ norm_added_mass + as.factor(firsteff) + exposure * as.factor(numberofvisits) + (1 + numberofvisits | subj),
                 family = binomial(link = "logit"), data = data_rot, REML = FALSE)
summary(ss_rate3)

ss_rate4 = hglm2(ss_learnrate ~ as.factor(effortcondition) + exposure * as.factor(numberofvisits) + (1 + numberofvisits | subj),
                 family = binomial(link = "logit"), data = data_rot, REML = FALSE)
summary(ss_rate4)

# metrics for ss parameters for only exposures 2 and 3
ss_rate_2to3 = hglm2(ss_learnrate ~ as.factor(firsteff) + exposure + (1|subj),
                     family = binomial(link = "logit"), data = data_expose2to3, REML = FALSE)
summary(ss_rate_2to3)
plot(ss_rate_2to3)

# plots for steady state asymmetry #############################################
# all participants, all exposures, sorted by effort condition, this mixes up subjects between the visits
ggplot(data=data_rot,
       aes(x=exposure, y = sla_plateau,col=as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
# all participants, all exposures, sorted by first effort condition
ggplot(data=data_rot,
       aes(x=exposure, y = sla_plateau,col=as.factor(firsteff)))+geom_point()+geom_smooth(method="lm")
# this includes only the second visit learning and relearning, sorted by effort condition, mixing between subjects
ggplot(data = data_visit2only,
       aes(x = exposure, y = sla_plateau,col = as.factor(effortcondition)))+geom_point()+geom_smooth(method="lm")
# this includes only relearning in visit 1 and learning in visit 2, sorted by first effort condition
ggplot(data = data_expose2to3,
       aes(x = exposure, y = sla_plateau,col = as.factor(firsteff)))+geom_point()+geom_smooth(method="lm")

# models sla plateau ###########################################################
# metrics for sla parameters are constrained to [-1 1], zplat shifts that to [0 1]
sla_plat1 = hglm2(zplat ~ as.factor(firsteff) + exposure + (1| subj),
                 data = data_twovisit, REML = FALSE)
summary(sla_plat1)
plot(sla_plat1)

sla_plat3 = hglm2(zplat ~ norm_added_mass + as.factor(firsteff) + exposure * as.factor(numberofvisits) + (1 + numberofvisits | subj),
                 data = data_rot, REML = FALSE)
summary(sla_plat3)

sla_plat4 = hglm2(zplat ~ as.factor(effortcondition) + exposure * as.factor(numberofvisits) + (1 + numberofvisits | subj),
                  data = data_rot, REML = FALSE)
summary(sla_plat4)

# metrics for sla for only exposures 2 and 3
sla_plat_2to3 = hglm2(zplat ~ as.factor(firsteff) + exposure + (1|subj),
                     data = data_expose2to3, REML = FALSE)
summary(sla_plat_2to3)
plot(sla_plat_2to3)

# plots for exp learning rate ##################################################
# all participants, all exposures, sorted by first effort condition
ggplot(data=data_rot,
       aes(x=exposure, y = exp_learnrate,col=as.factor(firsteff)))+geom_point()+geom_smooth(method="lm")
# this includes only relearning in visit 1 and learning in visit 2, sorted by first effort condition
ggplot(data = data_expose2to3,
       aes(x = exposure, y = exp_learnrate,col = as.factor(firsteff)))+geom_point()+geom_smooth(method="lm")

# models exp_learning rate #####################################################
exp_rate1 = hglm2(exp_learnrate ~ as.factor(firsteff) + exposure + (1| subj),
                  data = data_twovisit, REML = FALSE)
summary(exp_rate1)
plot(exp_rate1)

exp_rate3 = hglm2(exp_learnrate ~ norm_added_mass + as.factor(firsteff) + exposure * as.factor(numberofvisits) + (1 + numberofvisits | subj),
                  family = binomial(link = "logit"), data = data_rot, REML = FALSE)
summary(exp_rate3)

exp_rate4 = hglm2(exp_learnrate ~ as.factor(effortcondition) + exposure * as.factor(numberofvisits) + (1 + numberofvisits | subj),
                  family = binomial(link = "logit"), data = data_rot, REML = FALSE)
summary(exp_rate4)

# metrics for ss parameters for only exposures 2 and 3
exp_rate_2to3 = hglm2(exp_learnrate ~ as.factor(firsteff) + exposure + (1|subj),
                     data = data_expose2to3, REML = FALSE)
summary(exp_rate_2to3)
plot(exp_rate_2to3)

######################################################################

# IMPORTANCE OF CONDITION DURING INITIAL EXPOSURE
tab_model(ss_rate1, exp_rate1, sla_plat1)

# NESTED WITH EFFORT CONDITION - IN PAPER
tab_model(ss_rate4, exp_rate4, sla_plat4)

# NESTED WITH ADDED MASS, FIRST EFFORT CONDITION
tab_model(ss_rate3, exp_rate3, sla_plat3)













################################################################################
# respectively so we use log link with hglm2
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

