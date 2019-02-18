library(readr)
library(readxl)
library(lattice)
library(zoo)
library(quadprog)
library(tseries)
library(urca)
library(vars)
library(ccgarch)
library(fGarch)
library(MASS)
library(FinTS)
library(TTR)
library(fUnitRoots)
library(lmtest)
library(np)                                  
library(quantreg)
library(quantreg)
library(psych)
library(frequencyConnectedness)

data(exampleSim)
# Shorten the data, rolling estimation takes quite some time
exampleSim <- exampleSim[1:600,]
pgd <- read_csv("lbma_au9999_datatd.csv")
#openx <-with(pgd,open)
#open_y <- with(pgd,Open)
openx <-with(pgd,Open)
open_y <- with(pgd,Open_x)
open_z <- with(pgd,Open_y)
LBMA_logreturn<-diff(log(openx))
Au9999_logreturn<-diff(log(open_y))
AuTD_logreturn<-diff(log(open_z))
time <- with(pgd,Dates)
time1 <-time[2:length(time)]
describe(openx)
ccf(Au9999_logreturn, AuTD_logreturn, ylab="CCF",lag.max = 20,type = "correlation", plot = TRUE, na.action = na.fail) 

y <- data.frame(LBMA_logreturn,Au9999_logreturn,AuTD_logreturn) 
#array(NA,c(32487,3))
#dimnames(y ) <- ('y1' 'y2' 'y3')
#y[,1]<-openxl
#y[,2]<-open_yl
#y[,3]<-open_yl

#exampleSim<-cbind(y,open_zl)
est <- VAR(y, p = 14, type = "const")
#irff =irf(est, impulse = NULL, response = NULL, n.ahead = 10,
#          ortho = TRUE, cumulative = FALSE, boot = TRUE, ci = 0.95,
#          runs = 100, seed = NULL)
#plot(irff)
spilloverDY12(est, n.ahead = 100, no.corr = F)
sp <- spilloverRollingDY12(y, n.ahead = 100, no.corr = F, "VAR", params_est = params_est, window = 3600)
