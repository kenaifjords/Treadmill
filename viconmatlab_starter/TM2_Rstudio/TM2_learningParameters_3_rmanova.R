# load libraries
library(lmerTest)
library(sjPlot)
library(glmmTMB)# work on VMR data based on tutorial from: https://m-clark.github.io/mixed-models-with-R/random_intercepts.html#example-student-gpa
library(car)
library(ggplot2)
library(jtools)
library(sjmisc)
library(car)
library(DHARMa)
library(tidyverse)
library(detectseparation)
library(hglm)
library(ggpubr)
library(rstatix)
library(dplyr)
library(tidyr)

# Read CSV into R
dataparam <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rmat_param_new2.csv", header=TRUE, sep=",")
# most of paper was with _new2, but updated exp fits using fmincon for new3
#dataparam <- na.omit(dataparam)
dataparam$effortcondition[dataparam$effortcondition == 3] <- 0
dataparam$effortcondition <- as.factor(dataparam$effortcondition)
dataparam$block <- as.factor(dataparam$block)
dataparam$exposure <- as.factor(dataparam$exposure)

## repeated measures anova for step length in  the phases of the learning block
phase_anov <-list()
phase_lm <- list()
for (ib in 4:6) {
  # between subjects for groups, within subjects for phases
  data_rm00 = dataparam[dataparam$block == ib & dataparam$visit == 1,]
  data_rm0 <- select(data_rm00,subj, effortcondition,sla_initial, sla_early,sla_late,sla_plateau)
  data_rm0 <- na.omit(data_rm0)
  data_rm <- tidyr::gather(data_rm0,key = "phase", value = "asym", sla_initial, sla_early, sla_late, sla_plateau)
  
  # data_rm0 <- select(data_rm00,subj, effortcondition,sta_initial, sta_early,sta_late,sta_plateau)
  # data_rm <- tidyr::gather(data_rm0,key = "phase", value = "asym", sta_initial, sta_early, sta_late, sta_plateau)
  # 
  # data_rm0 <- select(data_rm00,subj, effortcondition,swa_initial, swa_early,swa_late,swa_plateau)
  # data_rm <- tidyr::gather(data_rm0,key = "phase", value = "asym", swa_initial, swa_early, swa_late, swa_plateau)
  
  
  data_rm %>% convert_as_factor(subj, phase,effortcondition)
  data_rm$effortcondition <- as.factor(data_rm$effortcondition)

  data_rm %>%
    group_by(phase, effortcondition) %>%
    get_summary_stats(asym, type = "mean_sd")

  # bxp <- ggboxplot(
  #   data_rm, x = "phase", y = "asym",
  #   color = "effortcondition", palette = "jco"
  # )
  # bxp

  # ANOVA
  res.aov <- anova_test(
    data = data_rm, dv = asym, wid = subj,
    between = effortcondition, within = phase
  )
  print(paste("block", ib))
  print(get_anova_table(res.aov))
  phase_anov[[ib]] <-res.aov
  
}

## Phase, effort condition, savings

dls = dataparam[(dataparam$block == 4 | dataparam$block == 6) & dataparam$visit == 1,]
dls <- select(dls,subj, block, effortcondition,sla_initial, sla_early,sla_late,sla_plateau)
dls <- tidyr::gather(dls,key = "phase", value = "asym", sla_initial, sla_early, sla_late, sla_plateau)
dls$effortcondition <- as.factor(dls$effortcondition)
  
  # ANOVA
res.aov <- anova_test(
  data = dls,
  dv = asym,
  wid = subj,
  between = effortcondition,
  within = c(phase, block)
)
print(get_anova_table(res.aov))

# stride to plateau in learning
s2saov <- anova_test(dataparam[dataparam$visit == 1 & dataparam$block == 4,],
                     dv = stride2plat, wid = subj,
                     between = c(effortcondition))
get_anova_table(s2saov)

# compare params between learning and relearning
varnames <- c("ss_remember","ss_learnrate","ss_initial", "exp_coef","exp_learnrate","exp_const","sla_initial","sla_early", "sla_late","sla_plateau","stride2plat")
save_ttest <- matrix(list(), nrow = length(varnames), ncol = 3)
rownames(save_ttest) <- varnames
colnames(save_ttest) <- c("control","high","low")
save_rmanova <- list()
save_lm <- list()
for (ip in 1:3) { #seq_along(varnames)) {
  # compare between learning and savings ttest for each group
  for (igrp in 0:2) {
    datatt <- dataparam[dataparam$effortcondition == igrp & dataparam$visit == 1 &
                          (dataparam$block == 4 | dataparam$block == 6),]
    #formula <- as.formula(paste(varnames[ip], "~ block"))
    if (igrp == 0) {igrp = 3}
      # save_ttest[[ip,igrp]] <- t.test(formula, data = datatt, paired = TRUE)
      temp <-datatt[,c("subj","block",varnames[ip])]
      wide <- pivot_wider(temp,names_from = block, values_from = all_of(varnames[ip]))
      bnames <- setdiff(names(wide),"subj")
      save_ttest[[ip,igrp]] <- t.test(wide[[bnames[1]]], wide[[bnames[2]]], paired = TRUE)
      print(paste(varnames[ip], "for effort condition (v1)", igrp, "ttest learn v relearn" ))
      print(save_ttest[[ip,igrp]])
  }
}

for (ip in 1:3) { #seq_along(varnames)) {
  # RM-ANOVA (between groups, within subj)
  dataov = dataparam[dataparam$visit == 1 & (dataparam$block == 4 | dataparam$bloc == 6),]
  paramvar <- paste0(varnames[ip])
  daov <- dplyr::select(dataov, subj, effortcondition,block,all_of(paramvar))
  save_aov <- anova_test(
    data = daov, dv = all_of(paramvar), wid = subj,
    between = c(effortcondition),within = block)
  save_rmanova[[ip]] <- save_aov
  # 
  print(paste(varnames[ip],"rm-anova for learning and relearning"))
  print(get_anova_table(save_aov))
  
  # across both visits
  # RM-ANOVA (between groups, within subj)
  d2v = dataparam[dataparam$twovisit == 1 & (dataparam$block == 4 | dataparam$block == 6),]
  paramvar <- paste0(varnames[ip])
  dav <- dplyr::select(d2v, subj, exposure, visit, twovisit_group, effortcondition, block, all_of(paramvar))
  d2vaov <- anova_test(
    data = dav, dv = all_of(paramvar), wid = subj,
    between = c(twovisit_group),
    within = c(exposure))
  
  # print(paste(varnames[ip],"rm-anova BOTH VISITS"))
  # print(get_anova_table(d2vaov))
}






## compare steplength in second visit
#data_v200 = dataparam[dataparam$visit == 2 & (dataparam$block == 4 | dataparam$block == 6),]
data_v200 = dataparam[dataparam$visit == 2,]
data_v20 <- dplyr::select(data_v200,subj, effortcondition,block,sla_initial, sla_early,sla_late,sla_plateau)
data_v2 <- tidyr::gather(data_v20,key = "phase", value = "asym", sla_initial, sla_early, sla_late, sla_plateau)
data_v2 %>% convert_as_factor(subj, phase,effortcondition,block)
data_v2$block <-as.factor(data_v2$block)
  
# 3 way ANOVA for visit 2
v2.aov <- anova_test(
    data = data_v2, dv = asym, wid = subj,
    between = effortcondition, within = c(phase,block))
get_anova_table(v2.aov)


# 3 way ANOVA for both
d2v <- dataparam[dataparam$twovisit == 1 & (dataparam$block == 4 | dataparam$block == 6),]
d2vsla <- dplyr::select(d2v,subj,exposure,visit, twovisit_group, effortcondition,block,sla_initial, sla_early,sla_late,sla_plateau)
d2vlong <- tidyr::gather(d2vsla,key = "phase", value = "asym", sla_initial, sla_early, sla_late, sla_plateau)
v2.aov <- anova_test(
  data = d2vlong, dv = asym, wid = subj,
  between = twovisit_group, within = c(phase,exposure))
get_anova_table(v2.aov)
pdl1 <- ggplot(data=d2vlong, 
               aes(x = phase, y = (asym), 
                   color = as.factor(visit))) +
  geom_point()
print(pdl1)



# compare learning parameters in the second visit
v2save_ttest <- matrix(list(), nrow = length(varnames), ncol = 2)
rownames(v2_ttest) <- varnames
v2_ttest <- matrix(list(),nrow = length(varnames), ncol = 6)
rownames(v2_ttest) <- varnames
for (ip in seq_along(varnames)) { #seq_along(varnames)
  # ttest (between groups)
  for (ib in 4) {
    dataov = dataparam[dataparam$visit == 2 & dataparam$block == ib,]
    formula <- as.formula(paste(varnames[ip], "~ effortcondition"))
    v2_ttest[[ip,ib]] <- t.test(formula, data = dataov)
    
    means <- dataov %>%
      group_by(effortcondition) %>%
      summarise(mean_var = mean(.data[[varnames[ip]]], na.rm = TRUE))
    
    print("")
    print(paste(varnames[ip], "block", ib, "for effort condition test between groups" ))
    print(paste("low-high", means[1],"high-low",means[2]))
    print(v2_ttest[[ip,ib]])
  }
}



## check statespace learning rates in blk 4 visit 2
datass <- dataparam[dataparam$visit == 2 & dataparam$block == 4,]
datass %>%
  group_by(effortcondition,block) %>%
  summarize(mean_sslr = mean(ss_learnrate, na.rm = TRUE),
            sd_sslr = sd(ss_learnrate, na.rm = TRUE) / sqrt(n()),
            mean_explr = mean(exp_learnrate, na.rm = TRUE),
            sd_explr = sd(exp_learnrate,na.rm = TRUE)/sqrt(n()))

## compare step time in different phases of learning, wahshou, retention
phase_stime_anov <- list()
for (ib in 4:6) {
  # between subjects for groups, within subjects for phases
  data_rm00 = dataparam[dataparam$block == ib & dataparam$visit == 1,]
  data_rm0 <- select(data_rm00,subj, effortcondition,sta_initial, sta_early,sta_late,sta_plateau)
  data_rm <- tidyr::gather(data_rm0,key = "phase", value = "asym", sta_initial, sta_early, sta_late, sta_plateau)
  data_rm %>% convert_as_factor(subj, phase,effortcondition)
  data_rm$effortcondition <- as.factor(data_rm$effortcondition)
  
  # ANOVA
  res.aov <- anova_test(
    data = data_rm, dv = asym, wid = subj,
    between = effortcondition, within = phase
  )
  print(paste("block", ib))
  print(get_anova_table(res.aov))
  phase_stime_anov[[ib]] <-res.aov
  
  pdl1 <- ggplot(data=data_rm, 
                 aes(x = phase, y = (asym), 
                     color = as.factor(effortcondition))) +
    geom_point()
  print(pdl1)
  
}

## compare step width in different phases of learning, wahshou, retention
phase_swidth_anov <- list()
for (ib in 4:6) {
  # between subjects for groups, within subjects for phases
  data_rm00 = dataparam[dataparam$block == ib & dataparam$visit == 1,]
  data_rm0 <- select(data_rm00,subj, effortcondition,swa_initial, swa_early,swa_late,swa_plateau)
  data_rm <- tidyr::gather(data_rm0,key = "phase", value = "asym", swa_initial, swa_early, swa_late, swa_plateau)
  data_rm %>% convert_as_factor(subj, phase,effortcondition)
  data_rm$effortcondition <- as.factor(data_rm$effortcondition)
  
  # ANOVA
  res.aov <- anova_test(
    data = data_rm, dv = asym, wid = subj,
    between = effortcondition, within = phase
  )
  get_anova_table(res.aov)
  phase_swidth_anov[[ib]] <-res.aov
  
  print(paste("block", ib))
  print(get_anova_table(res.aov))
  phase_stime_anov[[ib]] <-res.aov
  
  
  pdl1 <- ggplot(data=data_rm, 
                 aes(x = phase, y = (asym), 
                     color = as.factor(effortcondition))) +
    geom_point()
  print(pdl1)
}

















## DATA FOR EACH STEP ###
data <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\step_mat.csv", header=TRUE, sep=",")
bparam <- data[data$block == 2 | data$block == 3,]

bparam$sl <-rowMeans(subset(bparam, select = c(steplength_fast, steplength_slow)),na.rm = TRUE)
bsl0 <- select(bparam,subj,effortcondition,block,sl)

bsl <- data.frame(subj = factor, effortcondition = factor,sl2 = numeric, sl3 = numeric)
for (i in 1:max(bsl0$subj)) {
  bsl$subj[[i]] = i
  bsl$effortcondition[[i]] = mean(bsl0$effortcondition[bsl0$subj == i,])
  bsl$sl2[[i]] = mean(bsl0$sl[bsl0$block == 2])
  bsl$sl3[[i]] = mean(bsl0$sl[bsl0$block == 3])
}
  
bsl <- na.omit(bsl)

bsl <- tidyr::gather(data_rm0,key = "phase", value = "asym", sla_initial, sla_early, sla_late, sla_plateau)

bl.aov <- anova_test(
  data = bsl, dv = sl, wid = subj,
  between = effortcondition, within = block
)
get_anova_table(bl.aov)






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

