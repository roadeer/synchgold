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
#pgd <- read_csv("shfe_autd2.csv")
#open_x <-with(pgd,open_x)
#open_y <- with(pgd,open_y)
#close_x <-with(pgd,close_x)
#close_y <- with(pgd,close_y)
#openxlr<-log(close_x)-log(open_x)
#open_ylr<-log(close_y)-log(open_y)
#ccf(openxlr, open_ylr, lag =200, correlation = TRUE, pl = TRUE)
#ohlc_x <- pgd[,c("Open_x","High_x","Low_x","Close_x")]
#volatility_x <- volatility(ohlc_x, calc="close", mean0=TRUE)
#volatility_x[is.na(volatility_x)] <- 0

#ohlc_y <- pgd[,c("Open_y","High_y","Low_y","Close_y")]
#volatility_y <- volatility(ohlc_y, calc="close", mean0=TRUE)
#volatility_y[is.na(volatility_y)] <- 0
#inia<-c(4.361e-07,8.327e-07);
#iniA<-diag(c(4.769e-02,1.349e-01));
#iniB<-diag(c(9.460e-01,8.546e-01));
#dcc.para<-c(0.01,0.97);
#dvar = cbind(volatility_x[10:1054], volatility_y[10:1054]);
#dcc.results <- dcc.estimation(inia, iniA, iniB, dcc.para, dvar, model="diagonal");
#out<-dcc.results$out;
#DCC<-dcc.results$DCC[,2];
#ts.plot(DCC)
pgd <- read_csv("vpintd1.csv")
#pgd <- read_csv("vpin99994.csv")
diff <-with(pgd,diff)
absreturn <-abs(diff)
cdfpin<-with(pgd,cdfvpin)
pin<-with(pgd,vpin)
open<-with(pgd,open)


describe(diff)
adfx=adf.test(diff)
ppx=pp.test(diff)


y=cbind(cdfpin,absreturn) 
dfglsy = urersTest(open_ylr, type = "DF-GLS", model = "constant",
                   +           lag.max = 4, doplot = TRUE)

sr.reg <- lm(formula = cdfpin[1:1878] ~ open[3:1880])


y=cbind(openxlr,open_ylr)
#y=cbind(openx,open_y)
jj_return <- ca.jo(y, type = "trace",ecdet = "trend", K = 3, spec = "transitory")
#y=cbind(openx,open_y)
myvecm.ols <- cajools(jj_return)
vartest1 = VAR(y,p = 1,lag.max=100)
irff =irf(vartest1, impulse = NULL, response = NULL, n.ahead = 10,
          ortho = TRUE, cumulative = FALSE, boot = TRUE, ci = 0.95,
          runs = 100, seed = NULL)

#y=cbind(openx,open_y) 
po.coint<-po.test(y,demean=TRUE,lshort=TRUE) 

q1 <- rq(open_ylr ~ openxlr, tau = seq(.1,.9,.1))
summary(q1)
plot(q1)
ghat <- npreg(open_ylr~openxlr, ckertype="epanechnikov", ckerorder=4)
SR <- matrix(1, nrow = 2, ncol = 2)
SR[2, 2] <- 0
SR[1, 2] <- 0
LR <- matrix(1, nrow = 2, ncol =2)
LR[1, 2] <- 0
LR[2, 2] <- 0
svec.b <- SVEC(vecm, LR = LR, SR = SR, r = 1, lrtest = FALSE, boot =FALSE)
summary(svec.b)
yJoTest=ca.jo(y,type=c("trace"),ecdet=c("none"),K=2)
jo.results = summary(yJoTest)
jo.results
