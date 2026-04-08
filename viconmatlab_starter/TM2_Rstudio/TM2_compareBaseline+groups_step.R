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
datain <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\step_mat.csv", header=TRUE, sep=",")
# Rmat_v3.csv"
datain <- na.omit(datain)
datain$effortcondition
datain$effortcondition[datain$effortcondition == 3] <- 0

varnames <- c("steplength", "steptime", "stepwidth")
base_lmer <- list()
base_aov <-list()
for (step in varnames) {
  ## baseline comparison (fast and slow leg; fast and slow baseline; effortcondition)
  dataL0 = datain[datain$block == 2 | datain$bloc == 3,]
  step_var <- paste0(step, c("_fast", "_slow"))
  dataL <- select(dataL0, subj, effortcondition, block,
                  all_of(step_var))
  dataL <- gather(dataL, key = "leg", value = "var",
                  paste( step, "_fast",sep = ""), paste(step,"_slow",sep = ""))

  #formula <- as.formula(paste(var, "~ as.factor(effortcondition) + as.factor(block) + as.factor(leg) + (1|subj)"))
  base.sl_lmer <- lmer(var~ as.factor(effortcondition) + as.factor(block) + 
                         as.factor(leg) + (1|subj),data = dataL)
  #summary(base.sl_lmer)
  base_lmer[[step]] <- base.sl_lmer
  
  ## using ANOVA

  avg_sl <- dataL0 %>% 
    group_by(subj,block,effortcondition) %>%
    summarize(across(all_of(step_var),mean,na.rm = TRUE)
      #slf = mean(paste(step_var[[1]]),na.rm = TRUE),
      #sls = mean(all_of(paste( step, "_slow",sep="")), na.rm = TRUE)
    )
  # no difference between legs in baseline
  avg_sl$avgs <- rowMeans(subset(avg_sl,select = c(all_of(step_var))),na.rm = TRUE)
  # avg_sl <- gather(avg_sl0,key = "leg",value = "var" ,all_of(step_var))
  avg_sl <- avg_sl %>% ungroup()
  avg_sl$subj <- as.factor(avg_sl$subj)
  avg_sl$block <- as.factor(avg_sl$block)
  avg_sl$effortcondition <- as.factor(avg_sl$effortcondition)
  base.sl_aov <- anova_test(
    data = avg_sl, dv = avgs, wid = subj,
    between = c(effortcondition),within = block)
  base_aov[[step]] <- base.sl_aov
  #get_anova_table(base.sl_aov)
}


## in learning
for (step in varnames) {
  dataL0 = datain[datain$block == 4,]
  step_var <- paste0(step, c("_fast", "_slow"))
  dataL <- select(dataL0, subj, effortcondition, block,
                  all_of(step_var))
  dataL <- gather(dataL, key = "leg", value = "var",
                  paste( step, "_fast",sep = ""), paste(step,"_slow",sep = ""))
  ## using ANOVA
  avg_s <- dataL0 %>% 
    group_by(subj,block,effortcondition) %>%
    summarize(across(all_of(step_var),mean,na.rm = TRUE)
              #slf = mean(paste(step_var[[1]]),na.rm = TRUE),
              #sls = mean(all_of(paste( step, "_slow",sep="")), na.rm = TRUE)
    )
  # no difference between legs
  avg_s$avgs <- rowMeans(subset(avg_s,select = c(all_of(step_var))),na.rm = TRUE)
  # avg_sl <- gather(avg_sl0,key = "leg",value = "var" ,all_of(step_var))
  avg_sl <- avg_sl %>% ungroup()
  avg_sl$subj <- as.factor(avg_sl$subj)
  avg_sl$block <- as.factor(avg_sl$block)
  avg_sl$effortcondition <- as.factor(avg_sl$effortcondition)
  base.sl_aov <- anova_test(
    data = avg_sl, dv = avgs, wid = subj,
    between = c(effortcondition),within = block)
  base_aov[[step]] <- base.sl_aov
  #get_anova_table(base.sl_aov)
}














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
