# load libraries
library(lmerTest)
library(sjPlot)
library(ggplot2)
library(jtools)
library(sjPlot)
library(sjmisc)
library(car)
library(DHARMa)
library(tidyverse)
library(dplyr)
library(glue)
library(rstatix)
library(emmeans)
library(afex)
# Read CSV into R
df <- read.csv(file="C:\\Users\\rache\\OneDrive\\Documents\\GitHub\\treadmill\\viconmatlab_starter\\Rstepmet_var.csv", header=TRUE, sep=",")

df <- na.omit(df)
df$effortcondition[df$effortcondition == 3] <- 0
df$subj <- as.factor(df$subj)
df$effortcondition <- as.factor(df$effortcondition)
df$block <- as.factor(df$block)


varnames <- c("length", "time", "width" )

## BASELINE ###
baseforce_aov <-list()
baseforceleg_aov <-list()
steptimevar_tt <- list()
steptimevar_grps <- matrix(list(), nrow = 3, ncol = 4)
db0 = df[df$visit == 1 & (df$block == 2 | df$block == 3),]

for (i in varnames) {
  ## baseline comparison (fast and slow leg; fast and slow baseline; effortcondition)
  var <- paste0(i, c("_fastvar_across", "_slowvar_across")) 
  #_f_initial", "_f_early","_f_late", "_f_plateau","_s_initial", "_s_early","_s_late", "_s_plateau"))
  db <- select(db0, subj, effortcondition, block, all_of(var))
  
  # bring fast and slow leg into long form
  db1 <- db %>%
    pivot_longer(
      cols = starts_with(paste(i)),
      names_to = c("leg","phase"), # phase is always "across"
      names_pattern = glue("{i}_([a-z]+)_([a-z]+)"), 
      values_to = "varval"
    )
  db1 <- db1 %>% ungroup()
  
  db$avg <- rowMeans(db[,4:5]) 
  
  bfaov_leg <- anova_test(
    data = db1, dv = varval, wid = subj,
    between = c(effortcondition),within = c(leg,block))
  
  bfaov <- anova_test(
    data = db, dv = avg, wid = subj,
    between = c(effortcondition),within = c(block))
  
  baseforceleg_aov[[i]] <- bfaov_leg
  baseforce_aov[[i]] <- bfaov
  
  print(paste(i, "variance"))
  # print(get_anova_table(bfaov_leg))
  print(get_anova_table((bfaov)))
  
  ix <- which(varnames == i)
  # if (ix == 2) {
  #   print(paste(i,"variance follow up"))
  #   # follow up for step time ###
  #   # compare fast and slow baseline within each group
  #   for (j in 0:2) {
  #     dbtt <- db[db$effortcondition == j,]
  #     a2 <- dbtt$avg[dbtt$block == 2]
  #     a3 <- dbtt$avg[dbtt$block == 3]
  #     tbtwbase <- t.test(a2,a3, paired = TRUE) 
  #     if (j == 0) {j = 3}
  #     steptimevar_tt[[j]] <-tbtwbase
  #     
  #     print(paste("effcond", j))
  #     print(tbtwbase )
  #   }
  # # compare between effort conditions in each baseline
  #   for (k in 2:3) {
  #     # anova, pair control to low, control to high, low to high
  #     steptimevar_grps[[k,1]] <-aov(avg ~ effortcondition, 
  #                                   data = db[db$block == k,])
  #     steptimevar_grps[[k,2]] <-t.test(avg ~ effortcondition, 
  #                                   data = db[db$block == k & db$effortcondition == 0 | db$effortcondition == 2,])
  #     steptimevar_grps[[k,3]] <-t.test(avg ~ effortcondition, 
  #                                   data = db[db$block == k & db$effortcondition == 0 | db$effortcondition == 1,])
  #     steptimevar_grps[[k,4]] <-t.test(avg ~ effortcondition, 
  #                                   data = db[db$block == k & db$effortcondition == 1 | db$effortcondition == 2,])
  #     print(paste("block",k))
  #     print(steptimevar_grps[[k,1]])
  #     print("control v low")
  #     print(steptimevar_grps[[k,2]])
  #     print("control v high")
  #     print(steptimevar_grps[[k,3]])
  #     print("low v high")
  #     print(steptimevar_grps[[k,4]])
  #   }
  # }
}

## BASELINE STEP METRIC ###
baseforce_aov <-list()
steptime_tt <- list()
steptime_grps <- matrix(list(), nrow = 3, ncol = 4)
db0 = df[df$visit == 1 & (df$block == 2 | df$block == 3),]

for (i in varnames) {
  ## baseline comparison (fast and slow leg; fast and slow baseline; effortcondition)
  var <- paste0(i, c("_fast_across", "_slow_across")) 
  #_f_initial", "_f_early","_f_late", "_f_plateau","_s_initial", "_s_early","_s_late", "_s_plateau"))
  db <- dplyr::select(db0, subj, effortcondition, block, all_of(var))
  
  # bring fast and slow leg into long form
  db1 <- db %>%
    pivot_longer(
      cols = starts_with(paste(i)),
      names_to = c("leg","phase"), # phase is always "across"
      names_pattern = glue("{i}_([a-z]+)_([a-z]+)"), 
      values_to = "varval"
    )
  db1 <- db1 %>% ungroup()
  
  db$avg <- rowMeans(db[,4:5]) 
  
  bfaov <- anova_test(
    data = db, dv = avg, wid = subj,
    between = c(effortcondition),within = c(block))
  
  baseforce_aov[[i]] <- bfaov
  
  print(paste(i, "variance"))
  print(get_anova_table((bfaov)))
}


## in learning washout and relearning in visit 1 ####
force_aov <- matrix(list(), nrow = length(varnames), ncol = 6)
for (ib in 4:6) {
  for (i in varnames[2]) {
    ## baseline comparison (fast and slow leg; fast and slow baseline; effortcondition)
    dl0 = df[df$visit == 1 & df$block == ib,]
    # var <- paste0(i, c("_fastvar_initial", "_fastvar_early","_fastvar_late",
    #                    "_fastvar_plateau","_slowvar_initial", "_slowvar_early",
    #                    "_slowvar_late", "_slowvar_plateau"))
    var <- paste0(i, c("_fast_initial", "_fast_early","_fast_late",
                       "_fast_plateau","_slow_initial", "_slow_early",
                       "_slow_late", "_slow_plateau"))
    dl <- select(dl0, subj, effortcondition, block, all_of(var))
    
    # bring fast and slow leg into long form
    dl1 <- dl %>%
      pivot_longer(
        cols = starts_with(paste(i)),
        names_to = c("leg", "phase"),
        names_pattern = glue("{i}_([a-z]+)_([a-z]+)"), 
        values_to = "varval"
      )
    
    dl1 <- dl1 %>% ungroup()
    
    f_aov <- anova_test(
      data = dl1, dv = varval, wid = subj,
      between = c(effortcondition),
      within = c(leg,phase))
    ix = which( varnames==i )
    force_aov[[ix,ib]] <- f_aov
    
    faov <- afex::aov_ez(
      id = "subj",
      dv = "varval",
      data = dl1,
      between = "effortcondition",
      within = c("phase","leg")
    )
    
    print(" ")
    #print(paste("step",i, "variance"))
    print(paste("step",i))
    print(paste("block:", ib))
    print(get_anova_table(f_aov))
    
    pdl1 <- ggplot(data=dl1, #[dl1$phase != "initial",], 
           aes(x = phase, y = (varval), 
           shape = leg, color = as.factor(effortcondition))) +
      geom_jitter()
    print(pdl1)
    
    s0 <- dl1$varval[dl1$effortcondition == 0]
    s1 <- dl1$varval[dl1$effortcondition == 1]
    s2 <- dl1$varval[dl1$effortcondition == 2]
    cl <- t.test(s0,s2)
    ch <- t.test(s0,s1)
    lh <- t.test(s1,s2)
    
    # varmeans <- dl1 %>%
    #   group_by(phase, effortcondition, leg) %>%
    #   summarise(meanvar= mean(varval), na.rm = TRUE)
    # print(varmeans)
    
    #estimated marginal means
    emm <- emmeans(faov,~ effortcondition | phase * leg)
    contrast_results <- emmeans::contrast(emm, method = "pairwise", adjust = "bonferroni")
    summary(contrast_results)
  }
}
