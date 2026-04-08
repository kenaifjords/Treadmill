# load libraries
library(lmerTest)
library(sjPlot)
library(ggplot2)
#library(moderndive)
library(jtools)
library(sjPlot)
library(sjmisc)
library(car)
library(DHARMa)
library(tidyverse)
library(dplyr)
library(tidyr)
library(glue)
library(rstatix)
# Read CSV into R
df <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rforcephase_var.csv", header=TRUE, sep=",")

# Rmat_v3.csv"
df <- na.omit(df)
df$effortcondition[df$effortcondition == 3] <- 0
df$subj <- as.factor(df$subj)
df$effortcondition <- as.factor(df$effortcondition)
df$block <- as.factor(df$block)


varnames <- c("pkpush", "pkfz", "pkbrake", "imp" ,"pky_asym","miny_asym","pkz_asym","imp_asym")

## BASELINE ###
baseforce_aov <-list()
baseforceleg_aov <-list()
db0 = df[df$visit == 1 & (df$block == 2 | df$block == 3),]

for (i in varnames) {
  ## baseline comparison (fast and slow leg; fast and slow baseline; effortcondition)
  var <- paste0(i, c("_f_across", "_s_across")) 
        #_f_initial", "_f_early","_f_late", "_f_plateau","_s_initial", "_s_early","_s_late", "_s_plateau"))
  db <- select(db0, subj, effortcondition, block, all_of(var))
  db$effortcondition <- as.factor(db$effortcondition)
  db$block <- as.factor(db$block)
  
  # bring fast and slow leg into long form
  db1 <- db %>%
    pivot_longer(
      cols = starts_with(paste(i)),
      names_to = c("leg","phase"), # phase is always "across"
      names_pattern = glue("{i}_([fs])_([a-z]+)"), 
      values_to = "varval"
    )
  db2 <- db1 %>% ungroup()
  
  db$avg <- rowMeans(db[,4:5]) 
  
  bfaov_leg <- anova_test(
    data = db1, dv = varval, wid = subj,
    between = c(effortcondition),within = c(leg,block))
  
  bfaov <- anova_test(
    data = db, dv = avg, wid = subj,
    between = c(effortcondition),within = c(block))
  
  baseforceleg_aov[[i]] <- bfaov_leg
  baseforce_aov[[i]] <- bfaov
  
  print(i)
  print(get_anova_table(bfaov_leg))
  print(get_anova_table((bfaov)))
}

## in learning washout and relearning in visit 1 ####
force_aov <- matrix(list(), nrow = length(varnames), ncol = 6)
for (ib in 6) {
  for (i in varnames[1:4]) {
    ## baseline comparison (fast and slow leg; fast and slow baseline; effortcondition)
    dl0 = df[df$visit == 1 & df$block == ib,]
    var <- paste0(i, c("_f_initial", "_f_early","_f_late", "_f_plateau","_s_initial", "_s_early","_s_late", "_s_plateau"))
    if (i == varnames[5]) {
       var <- paste0(i, c("_initial", "_early","_late", "_plateau"))
     }
    dl <- dplyr::select(dl0, subj, effortcondition, block, all_of(var))
    dl$effortcondition <- as.factor(dl$effortcondition)
    dl$block <- as.factor(dl$block)
    
    # bring fast and slow leg into long form
    dl1 <- dl %>%
    pivot_longer(
      cols = starts_with(paste(i)),
      names_to = c("leg", "phase"),
      names_pattern = glue("{i}_([fs])_([a-z]+)"), 
      values_to = "varval"
    )
  
    dl1 <- dl1 %>% ungroup()

    f_aov <- anova_test(
      data = dl1, dv = varval, wid = subj,
      between = c(effortcondition),
      within = c(leg,phase))
    ix = which( varnames==i )
    force_aov[[ix,ib]] <- f_aov
    
    pdl1 <- ggplot(data=dl1, 
                   aes(x = phase, y = (varval), 
                       color = as.factor(leg))) +
      geom_point()
    print(pdl1)
    
    print(" ")
    print(i)
    print(paste("block:", ib))
    print(get_anova_table(f_aov))
  }
}

## force asym
forceasym_aov <- matrix(list(), nrow = length(varnames), ncol = 6)
for (ib in 4) {
  for (i in varnames[5:8]) {
    ## baseline comparison (fast and slow leg; fast and slow baseline; effortcondition)
    dl0 = df[df$visit == 1 & df$block == ib,]
    var <- paste0(i, c("_initial", "_early","_late", "_plateau"))
    dl <- dplyr::select(dl0, subj, effortcondition, block, all_of(var))
    dl$effortcondition <- as.factor(dl$effortcondition)
    dl$block <- as.factor(dl$block)
    
    # bring fast and slow leg into long form
    dl1 <- dl %>%
      pivot_longer(
        cols = starts_with(paste(i)),
        names_to = c("phase"),
        names_pattern = glue("{i}_([a-z]+)"), 
        values_to = "varval"
      )
    
    dl1 <- dl1 %>% ungroup()
    
    f_aov <- anova_test(
      data = dl1, dv = varval, wid = subj,
      between = c(effortcondition),
      within = c(phase))
    ix = which( varnames==i )
    forceasym_aov[[ix,ib]] <- f_aov
    
    print(" ")
    print(i)
    print(paste("block:", ib))
    print(get_anova_table(f_aov))
    
    pdl1 <- ggplot(data=dl1, 
                   aes(x = phase, y = (varval), 
                       color = as.factor(effortcondition))) +
      geom_point()
    print(pdl1)
  }
}

## savings in force asymm
# compare params between learning and relearning
save_ttest <- matrix(list(), nrow = length(varnames), ncol = 4)
rownames(save_ttest) <- varnames
colnames(save_ttest) <- c("initial","elary","late","plat") #("control","high","low")
save_rmanova <- list()
save_lm <- list()
for (i in 5:8) {
  #compare between learning and savings ttest for each group
  
    datatt <- df[ df$visit == 1 & (df$block == 4 | df$block == 6),]
    paramvar <- paste0(varnames[i], c("_initial", "_early","_late", "_plateau"))
    for (iphase in 1:4) {
      # save_ttest[[ip,igrp]] <- t.test(formula, data = datatt, paired = TRUE)
      temp <-datatt[,c("subj","block",paramvar[iphase])]
      wide <- pivot_wider(temp,names_from = block, values_from = paramvar[iphase])
      bnames <- setdiff(names(wide),"subj")
      save_ttest[[i,iphase]] <- t.test(wide[[bnames[1]]], wide[[bnames[2]]], paired = TRUE)
      print(paste(varnames[i], "for phase", iphase, "ttest learn v relearn" ))
      print(save_ttest[[i,iphase]])
    }
  
  # RM-ANOVA (between groups, within subj)
  dataov = df[df$visit == 1 & (df$block == 4 | df$bloc == 6),]
  paramvar <- paste0(varnames[i], c("_initial", "_early","_late", "_plateau"))
  daov <- dplyr::select(dataov, subj, effortcondition,block,all_of(paramvar))
  
  # bring fast and slow leg into long form
  daov1 <- daov %>%
    pivot_longer(
      cols = starts_with(paste(varnames[i])),
      names_to = c("phase"),
      names_pattern = glue("{varnames[i]}_([a-z]+)"), 
      values_to = "varval"
    )
  
  save_aov <- anova_test(
    data = daov1, dv = varval, wid = subj,
    between = c(effortcondition),within = c(block,phase))
  save_rmanova[[ip]] <- save_aov
  
  print(paste(varnames[ip],"rm-anova for learning and relearning"))
  print(get_anova_table(save_aov))
  
  pdl1 <- ggplot(data=daov1, 
                 aes(x = phase, y = (varval), 
                     color = as.factor(block))) +
    geom_point()
  print(pdl1)
  
  # slm <- lmer(sla ~ phase +...)
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
