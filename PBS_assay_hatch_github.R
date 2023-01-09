#+++++++++++++++++++++++++++++++++++
# Load needed libraries
#+++++++++++++++++++++++++++++++++++

library(lme4)
library(car)
library(lsmeans)
library(nortest)

#+++++++++++++++++++++++++++++++++++
# Read data
#+++++++++++++++++++++++++++++++++++

hatch = read.table("/Users/Neda/Dropbox (PopGen)/tmp/egg_size_method_paper/hatchability/PBS_viability_Nov242022_mod.txt",header = TRUE, sep = '\t')

#check the data types
str(hatch)

#set treatments and sub-replicate as factor
hatch$treatment <- as.factor(hatch$treatment)
hatch$replicate <- as.factor(hatch$replicate)

#+++++++++++++++++++++++++++++++++++
# plot the data
#+++++++++++++++++++++++++++++++++++

pdf(file="/Users/Neda/Dropbox (PopGen)/tmp/egg_size_method_paper/plots/final_plots/boxplot_PBS_viability_revision.pdf")
boxplot(hatch$total_fly[hatch$treatment == "no_PBS"],hatch$total_fly[hatch$treatment == "PBS_20min"],hatch$total_fly[hatch$treatment =="PBS_3:45"],hatch$total_fly[hatch$treatment =="PBS3:45_sort"],
        names = c('no PBS', '0-hour', '4-hour', 'sorted 4-hour'),ylim=c(0,55), xlab="", ylab="No. eclosed flies", col=c('coral1','coral1','coral1', 'darkseagreen'))
dev.off()

#+++++++++++++++++++++++++++++++++++
# fit a GLMM
#+++++++++++++++++++++++++++++++++++

# assign a binomial statistic to data
#Each egg is a success or failure (whether it hatched or not), so if you have 40 larvae our of 50 eggs you have a 2 column matrix:(40,10)
success <- cbind(hatch$total_fly,hatch$egg_num-hatch$total_fly)

#set the levels of fixed factors
hatch$treatment <- factor(hatch$treatment, levels = c("no_PBS","PBS_20min","PBS_3:45","PBS3:45_sort"))
contrasts(hatch$treatment) = contr.sum(4)

ad.test(residuals(hatchModel))

---------------------------------
# Anderson-Darling normality test
# 
# data:  residuals(hatchModel)
# A = 0.32393, p-value = 0.5046
---------------------------------
  
#GLMM binomial
hatchModel <- glmer(success ~ treatment + (1|replicate), data = hatch, family="binomial", contrasts = 'contr.sum')

summary(hatchModel)

---------------------------------
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: binomial  ( logit )
# Formula: success ~ treatment + (1 | replicate)
# Data: hatch
# 
# AIC      BIC   logLik deviance df.resid 
# 138.2    143.4    -64.1    128.2       16 
# 
# Scaled residuals: 
#   Min     1Q Median     3Q    Max 
# -3.262 -1.342  0.504  1.303  2.308 
# 
# Random effects:
#   Groups    Name        Variance Std.Dev.
# replicate (Intercept) 0.02082  0.1443  
# Number of obs: 21, groups:  replicate, 7
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   1.7164     0.1130  15.185   <2e-16 ***
#   treatment1    0.0346     0.1549   0.223    0.823    
# treatment2   -0.2362     0.1606  -1.470    0.141    
# treatment3    0.1648     0.1598   1.032    0.302    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#   (Intr) trtmn1 trtmn2
# treatment1  0.084              
# treatment2 -0.015 -0.383       
# treatment3  0.125 -0.316 -0.402
---------------------------------

plot(hatchModel, which = 1) 
model.matrix(hatchModel,  contrasts.arg = contr.sum(3))
qqnorm(residuals(hatchModel), main = 'Residuals')
qqline(residuals(hatchModel))
qqnorm(ranef(hatchModel)[[1]][,1] , main = 'Random effect')

###################################################
#contrast a model with and without the fixed effect 
###################################################

hatchModel_1 <- glmer(success ~ treatment + (1|replicate), data = hatch, family="binomial")
hatchModel_2 <- glmer(success ~  (1|replicate) , data = hatch, family="binomial")
anova(hatchModel_1,hatchModel_2)

---------------------------------
# Data: hatch
# Models:
#   hatchModel_2: success ~ (1 | replicate)
# hatchModel_1: success ~ treatment + (1 | replicate)
# npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)
# hatchModel_2    2 134.56 136.65 -65.282   130.56                     
# hatchModel_1    5 138.20 143.42 -64.099   128.20 2.3657  3        0.5
---------------------------------
  
###################################################
#contrast a model with and without the random effect 
###################################################

hatchModel_3 <- glmer(success ~ treatment + (1|replicate), data = hatch, family="binomial")
hatchModel_4 <- glm(success ~  treatment , data = hatch, family="binomial")

anova(hatchModel_3,hatchModel_4) 

---------------------------------
# Data: hatch
# Models:
#   hatchModel_4: success ~ treatment
# hatchModel_3: success ~ treatment + (1 | replicate)
# npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)
# hatchModel_4    4 136.47 140.65 -64.233   128.47                     
# hatchModel_3    5 138.20 143.42 -64.099   128.20 0.2693  1     0.6038
---------------------------------

###############
#get p-values
###############

(lsmeans <- lsmeans(hatchModel,"treatment"))

---------------------------------
# treatment    lsmean    SE  df asymp.LCL asymp.UCL
# no_PBS         1.75 0.199 Inf      1.36      2.14
# PBS_20min      1.48 0.195 Inf      1.10      1.86
# PBS_3:45       1.88 0.207 Inf      1.48      2.29
# PBS3:45_sort   1.75 0.161 Inf      1.44      2.07
# 
# Results are given on the logit (not the response) scale. 
# Confidence level used: 0.95 
---------------------------------
  
contrast(lsmeans, "pairwise")

---------------------------------
# contrast                 estimate    SE  df z.ratio p.value
# no_PBS - PBS_20min        0.27079 0.262 Inf   1.032  0.7307
# no_PBS - PBS_3:45        -0.13025 0.255 Inf  -0.510  0.9567
# no_PBS - PBS3:45_sort    -0.00214 0.239 Inf  -0.009  1.0000
# PBS_20min - PBS_3:45     -0.40104 0.268 Inf  -1.495  0.4405
# PBS_20min - PBS3:45_sort -0.27293 0.240 Inf  -1.136  0.6673
# PBS_3:45 - PBS3:45_sort   0.12810 0.246 Inf   0.521  0.9540
# 
# Results are given on the log odds ratio (not the response) scale. 
# P value adjustment: tukey method for comparing a family of 4 estimates 
---------------------------------
  