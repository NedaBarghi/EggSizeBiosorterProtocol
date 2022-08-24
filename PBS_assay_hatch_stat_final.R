#load needed libraries
library(lme4)
library(car)
library(lsmeans)
library(nortest)

#+++++++++++++++++++++++++++++
#analyze PBS viability assay
#+++++++++++++++++++++++++++++

##########
#read data
##########

hatch = read.table("/Users/Neda/Dropbox (PopGen)/tmp/egg_size_method_paper/hatchability/PBS_sort_viability_mod.txt",header = TRUE, sep = '\t')

#check the data types
str(hatch)

#set treatments and sub-replicate as factor
hatch$PBS_expo <- as.factor(hatch$PBS_expo)
hatch$subreplicate <- as.factor(hatch$subreplicate)

#check the data types
str(hatch)

#check the average and sd of eclosed flies for each treatment
for (i in  c("4","6","8")){
  print(round(mean(hatch$fly_num[hatch$PBS_expo == i]),digits = 2))
  print(round(sd(hatch$fly_num[hatch$PBS_expo == i]),digits = 2))
}

##################
#data manipulation
##################

#we remove sort data for now
hatch_sub <- subset(hatch,(hatch$sort == 'no'))

# assign a binomial statistic to data
#Each egg is a success or failure (whether it hatched or not), so if you have 40 larvae our of 50 eggs you have a 2 column matrix:(40,10)
success <- cbind(hatch_sub$fly_num,hatch_sub$egg_num-hatch_sub$fly_num)

#check the average and sd of eclosed flies for each treatment after removing sorted data
for (i in  c("4","6","8")){
  print(round(mean(hatch_sub$fly_num[hatch_sub$PBS_expo == i]),digits = 2))
  print(round(sd(hatch_sub$fly_num[hatch_sub$PBS_expo == i]),digits = 2))
}

#plot the viability data
pdf(file="/Users/Neda/Dropbox (PopGen)/tmp/egg_size_method_paper/plots/boxplot_PBS_viability.pdf")
boxplot(hatch_sub$fly_num[hatch_sub$PBS_expo == '4'],hatch_sub$fly_num[hatch_sub$PBS_expo == '6'],hatch_sub$fly_num[hatch_sub$PBS_expo == '8'],
        names = c("4","6","8"),ylim=c(0,50), xlab="PBS submerssion time (hr)", ylab="No. eclosed flies", col=c('coral1','coral1','coral1'))
dev.off()

#############
#fit a GLMM
#############

#set the levels of fixed factors
hatch_sub$PBS_expo <- factor(hatch_sub$PBS_expo, levels = c("4","6","8"))
contrasts(hatch_sub$PBS_expo) = contr.sum(3)

#GLMM binomial
hatchModel <- glmer(success ~ PBS_expo + (1|subreplicate), data = hatch_sub, family="binomial", contrasts = 'contr.sum')

summary(hatchModel)
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: binomial  ( logit )
# Formula: success ~ PBS_expo + (1 | subreplicate)
# Data: hatch_sub
# 
# AIC      BIC   logLik deviance df.resid 
# 122.7    127.1    -57.4    114.7       18 
# 
# Scaled residuals: 
#   Min      1Q  Median      3Q     Max 
# -2.1783 -0.6923  0.1980  0.9655  2.1783 
# 
# Random effects:
#   Groups       Name        Variance Std.Dev.
# subreplicate (Intercept) 0        0       
# Number of obs: 22, groups:  subreplicate, 14
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  1.56888    0.09482  16.545   <2e-16 ***
#   PBS_expo1    0.21358    0.14074   1.518    0.129    
# PBS_expo2    0.16572    0.11281   1.469    0.142    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#   (Intr) PBS_x1
# PBS_expo1  0.137       
# PBS_expo2 -0.491 -0.350
# optimizer (Nelder_Mead) convergence code: 0 (OK)
# boundary (singular) fit: see help('isSingular')

isSingular(hatchModel, tol = 1e-6)
plot(hatchModel, which = 1) 
model.matrix(hatchModel,  contrasts.arg = contr.sum(3))
qqnorm(residuals(hatchModel), main = 'Residuals')
qqline(residuals(hatchModel))
qqnorm(ranef(hatchModel)[[1]][,1] , main = 'Random effect')

Anova(hatchModel, type = 3)
# Analysis of Deviance Table (Type III Wald chisquare tests)
# 
# Response: success
# Chisq Df Pr(>Chisq)    
# (Intercept) 273.7502  1    < 2e-16 ***
#   PBS_expo      6.8641  2    0.03232 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#test for normality of residuals

ad.test(residuals(hatchModel))
#the residuals have normal distribution

# Anderson-Darling normality test
# 
# data:  residuals(hatchModel)
# A = 0.23435, p-value = 0.7659

###################################################
#contrast a model with and without the fixed effect 
###################################################

hatchModel_1 <- glmer(success ~ PBS_expo + (1|subreplicate), data = hatch_sub, family="binomial")
hatchModel_2 <- glmer(success ~  (1|subreplicate) , data = hatch_sub, family="binomial")
anova(hatchModel_1,hatchModel_2) #p-value 0.04585

# Data: hatch_sub
# Models:
#   hatchModel_2: success ~ (1 | subreplicate)
# hatchModel_1: success ~ PBS_expo + (1 | subreplicate)
# npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)  
# hatchModel_2    2 124.89 127.07 -60.445   120.89                       
# hatchModel_1    4 122.73 127.09 -57.363   114.73 6.1646  2    0.04585 *
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#so we should keep the fixed effect in the model

###################################################
#contrast a model with and without the random effect 
###################################################

hatchModel_1 <- glmer(success ~ PBS_expo + (1|subreplicate), data = hatch_sub, family="binomial")
hatchModel_2 <- glm(success ~  PBS_expo , data = hatch_sub, family="binomial")
anova(hatchModel_1,hatchModel_2) #p-value  1

#so we should remove the random effect in the model

###########
#final model
###########

hatchModel <- glmer(success ~  PBS_expo + (1|subreplicate), data = hatch_sub, family="binomial")
summary(hatchModel)
plot(hatchModel, which = 1) 
model.matrix(hatchModel,  contrasts.arg = contr.sum(3))
qqnorm(residuals(hatchModel), main = 'Residuals')
qqline(residuals(hatchModel))

Anova(hatchModel, type = 3)
# Analysis of Deviance Table (Type III Wald chisquare tests)
# 
# Response: success
# Chisq Df Pr(>Chisq)    
# (Intercept) 273.7502  1    < 2e-16 ***
#   PBS_expo      6.8641  2    0.03232 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

###############
#get p-values
###############

(lsmeans <- lsmeans(hatchModel,"PBS_expo"))
# PBS_expo lsmean    SE  df asymp.LCL asymp.UCL
# 4          1.78 0.180 Inf     1.429      2.14
# 6          1.73 0.106 Inf     1.527      1.94
# 8          1.19 0.193 Inf     0.811      1.57
# 
# Results are given on the logit (not the response) scale. 
# Confidence level used: 0.95 

contrast(lsmeans, "pairwise")
# contrast estimate    SE  df z.ratio p.value
# 4 - 6      0.0479 0.209 Inf   0.229  0.9715
# 4 - 8      0.5929 0.264 Inf   2.245  0.0638
# 6 - 8      0.5450 0.220 Inf   2.476  0.0355
# 
# Results are given on the log odds ratio (not the response) scale. 
# P value adjustment: tukey method for comparing a family of 3 estimates

#+++++++++++++++++++++++++++++++++++
#analyze sort viability assay
#+++++++++++++++++++++++++++++++++++

###################################
#load the sort viability assay data
###################################

hatch_srt <- subset(hatch,(hatch$PBS_expo == '6'))

str(hatch_srt)

#set the levels of fixed factors
hatch_srt$PBS_expo <- factor(hatch_srt$PBS_expo, levels = c("6"))

str(hatch_srt)

# assign a binomial statistic to data
#Each egg is a success or failure (whether it hatched or not), so if you have 40 larvae our of 50 eggs you have a 2 column matrix:(40,10)
success_srt <- cbind(hatch_srt$fly_num,hatch_srt$egg_num-hatch_srt$fly_num)

#sneak peak
#pdf(file="/Users/Neda/Dropbox (PopGen)/tmp/egg_size_method_paper/plots/boxplot_sort_viability.pdf")
boxplot(hatch_srt$fly_num[hatch_srt$sort == 'no'],hatch_srt$fly_num[hatch_srt$sort == 'yes'],
        names = c("Not sorted","Sorted"),ylim=c(0,50),ylab="No. eclosed flies", col=c('darkseagreen','darkseagreen'))
dev.off()

#compute mean and sd of sorted and not sorted datasets
for (i in  c("no","yes")){
  print(round(mean(hatch_srt$fly_num[hatch_srt$sort == i]),digits = 2))
  print(round(sd(hatch_srt$fly_num[hatch_srt$sort == i]),digits = 2))
}

############
#fit a GLMM
############

#set the levels of fixed factors
hatch_srt$sort <- factor(hatch_srt$sort, levels = c("no","yes"))
contrasts(hatch_srt$sort) = contr.sum(2)

#GLMM binomial
srtModel <- glmer(success_srt ~ sort + (1|subreplicate), data = hatch_srt, family="binomial", contrasts = 'contr.sum')

summary(srtModel)
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: binomial  ( logit )
# Formula: success_srt ~ sort + (1 | subreplicate)
# Data: hatch_srt
# 
# AIC      BIC   logLik deviance df.resid 
# 170.8    174.9    -82.4    164.8       26 
# 
# Scaled residuals: 
#   Min       1Q   Median       3Q      Max 
# -2.02658 -0.78188  0.06137  0.56015  2.11069 
# 
# Random effects:
#   Groups       Name        Variance Std.Dev.
# subreplicate (Intercept) 0.05549  0.2356  
# Number of obs: 29, groups:  subreplicate, 15
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  1.34589    0.09090  14.807  < 2e-16 ***
#   sort1        0.38932    0.06739   5.778 7.58e-09 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#   (Intr)
# sort1 0.192

plot(srtModel, which = 1) 
model.matrix(srtModel,  contrasts.arg = contr.sum(2))
qqnorm(residuals(srtModel), main = 'Residuals')
qqline(residuals(srtModel))
qqnorm(ranef(srtModel)[[1]][,1] , main = 'Random effect')

Anova(srtModel, type = 3)
# Analysis of Deviance Table (Type III Wald chisquare tests)
# 
# Response: success
# Chisq Df Pr(>Chisq)    
# (Intercept) 219.24  1  < 2.2e-16 ***
#   sort         33.38  1  7.581e-09 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#test for normality of residuals

ad.test(residuals(srtModel))
#the residuals have normal distribution
# 
# Anderson-Darling normality test
# 
# data:  residuals(hatchModel)
# A = 0.28, p-value = 0.6188

###################################################
#contrast a model with and without the fixed effect 
###################################################

srtModel_1 <- glmer(success_srt ~ sort + (1|subreplicate), data = hatch_srt, family="binomial")
srtModel_2 <- glmer(success_srt ~  (1|subreplicate) , data = hatch_srt, family="binomial")
anova(srtModel_1,srtModel_2) #p-value 4.146e-09

# Data: hatch_srt
# Models:
#   hatchModel_2: success_srt ~ (1 | subreplicate)
# hatchModel_1: success_srt ~ sort + (1 | subreplicate)
# npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)    
# hatchModel_2    2 203.36 206.09 -99.680   199.36                         
# hatchModel_1    3 170.81 174.91 -82.403   164.81 34.554  1  4.146e-09 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#so we should keep the fixed effect in the model

###################################################
#contrast a model with and without the random effect 
###################################################

srtModel_1 <- glmer(success_srt ~ sort + (1|subreplicate), data = hatch_srt, family="binomial")
srtModel_2 <- glm(success_srt ~  sort , data = hatch_srt, family="binomial")
anova(srtModel_1,srtModel_2) 

# Data: hatch_srt
# Models:
#   hatchModel_2: success_srt ~ sort
# hatchModel_1: success_srt ~ sort + (1 | subreplicate)
# npar    AIC    BIC  logLik deviance Chisq Df Pr(>Chisq)  
# hatchModel_2    2 172.29 175.03 -84.147   168.29                      
# hatchModel_1    3 170.81 174.91 -82.403   164.81 3.488  1    0.06181 .
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#so we should not keep the random effect in the model

############
#final model
############

srtModel <- glmer(success_srt ~  sort+ (1|subreplicate) , data = hatch_srt, family="binomial")
Anova(srtModel, type = 3) 
# Analysis of Deviance Table (Type III Wald chisquare tests)
# 
# Response: success_srt
# Chisq Df Pr(>Chisq)    
# (Intercept) 219.24  1  < 2.2e-16 ***
#   sort         33.38  1  7.581e-09 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

summary(srtModel)
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: binomial  ( logit )
# Formula: success_srt ~ sort + (1 | subreplicate)
# Data: hatch_srt
# 
# AIC      BIC   logLik deviance df.resid 
# 170.8    174.9    -82.4    164.8       26 
# 
# Scaled residuals: 
#   Min       1Q   Median       3Q      Max 
# -2.02658 -0.78188  0.06137  0.56015  2.11069 
# 
# Random effects:
#   Groups       Name        Variance Std.Dev.
# subreplicate (Intercept) 0.05549  0.2356  
# Number of obs: 29, groups:  subreplicate, 15
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  1.34589    0.09090  14.807  < 2e-16 ***
#   sort1        0.38932    0.06739   5.778 7.58e-09 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#   (Intr)
# sort1 0.192

###########
#get pvalue
###########

(lsmeans <- lsmeans(srtModel,"sort"))
# sort lsmean    SE  df asymp.LCL asymp.UCL
# no    1.735 0.123 Inf     1.494      1.98
# yes   0.957 0.102 Inf     0.756      1.16
# 
# Results are given on the logit (not the response) scale. 
# Confidence level used: 0.95 

contrast(lsmeans, "pairwise")
# contrast estimate    SE  df z.ratio p.value
# no - yes    0.779 0.135 Inf   5.778  <.0001
# 
# Results are given on the log odds ratio (not the response) scale. 
