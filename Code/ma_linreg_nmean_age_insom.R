# script to calculate linear regression model and plot data from global mean
# link strength (nmean) and age of all patients, all female and all male of 
# group "insomnia" (see master thesis of Stefanie Breuer for classification of
#  groups) 

############### Metadaata ################
# Stefanie Breuer, 21.03.2017, 
# stefanie.breuer@student.htw-berlin.de
# version 1.0
##########################################

# import Matlab Package
library(R.matlab)

# matlab data paths
matfile_insom <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_insom.mat'
matfile_insom_f <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_insom_f.mat'
matfile_insom_m <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_insom_m.mat'

# load data from matlab files
data_insom <- readMat(matfile_insom)
data_insom_f <- readMat(matfile_insom_f)
data_insom_m <- readMat(matfile_insom_m)

# show type of data
typeof(data_insom)

#---------------------------------------
# extract information from whole insomnia data
#---------------------------------------
# unlist data
nmean_age_insom <- array(unlist(data_insom), dim = c(nrow(data_insom[[1]]), ncol(data_insom[[1]]), 4))

# form vectors for each sleep stage and age
nmean_insom_ds <- nmean_age_insom[,1,1]
nmean_insom_ls <- nmean_age_insom[,1,2]
nmean_insom_r <- nmean_age_insom[,1,3]
nmean_insom_w <- nmean_age_insom[,1,4]
age_insom <- nmean_age_insom[,2,1]

# create data frames
insomdata_insom_ds <- data.frame(age_insom, nmean_insom_ds)
insomdata_insom_ls <- data.frame(age_insom, nmean_insom_ls)
insomdata_insom_r <- data.frame(age_insom, nmean_insom_r)
insomdata_insom_w <- data.frame(age_insom, nmean_insom_w)

# create formulas
insomdata_insom_ds.lm <- lm(nmean_insom_ds~age_insom,data=insomdata_insom_ds)
insomdata_insom_ls.lm <- lm(nmean_insom_ls~age_insom,data=insomdata_insom_ls)
insomdata_insom_r.lm <- lm(nmean_insom_r~age_insom,data=insomdata_insom_r)
insomdata_insom_w.lm <- lm(nmean_insom_w~age_insom,data=insomdata_insom_w)

#---------------------------------------
# extract information from female insomnia data
#---------------------------------------
# unlist data
nmean_age_insom_f <- array(unlist(data_insom_f), dim = c(nrow(data_insom_f[[1]]), ncol(data_insom_f[[1]]), 4))

# form vectors for each sleep stage and age
nmean_insom_f_ds <- nmean_age_insom_f[,1,1]
nmean_insom_f_ls <- nmean_age_insom_f[,1,2]
nmean_insom_f_r <- nmean_age_insom_f[,1,3]
nmean_insom_f_w <- nmean_age_insom_f[,1,4]
age_insom_f <- nmean_age_insom_f[,2,1]

# create data frame
insomdata_insom_f_ds <- data.frame(age_insom_f, nmean_insom_f_ds)
insomdata_insom_f_ls <- data.frame(age_insom_f, nmean_insom_f_ls)
insomdata_insom_f_r <- data.frame(age_insom_f, nmean_insom_f_r)
insomdata_insom_f_w <- data.frame(age_insom_f, nmean_insom_f_w)

# create formulas
insomdata_insom_f_ds.lm <- lm(nmean_insom_f_ds~age_insom_f,data=insomdata_insom_f_ds)
insomdata_insom_f_ls.lm <- lm(nmean_insom_f_ls~age_insom_f,data=insomdata_insom_f_ls)
insomdata_insom_f_r.lm <- lm(nmean_insom_f_r~age_insom_f,data=insomdata_insom_f_r)
insomdata_insom_f_w.lm <- lm(nmean_insom_f_w~age_insom_f,data=insomdata_insom_f_w)

#---------------------------------------
# extract information from male insomnia data
#---------------------------------------
# unlist data
nmean_age_insom_m <- array(unlist(data_insom_m), dim = c(nrow(data_insom_m[[1]]), ncol(data_insom_m[[1]]), 4))

# form vectors for each sleep stage and age
nmean_insom_m_ds <- nmean_age_insom_m[,1,1]
nmean_insom_m_ls <- nmean_age_insom_m[,1,2]
nmean_insom_m_r <- nmean_age_insom_m[,1,3]
nmean_insom_m_w <- nmean_age_insom_m[,1,4]
age_insom_m <- nmean_age_insom_m[,2,1]

# create data frame
insomdata_insom_m_ds <- data.frame(age_insom_m, nmean_insom_m_ds)
insomdata_insom_m_ls <- data.frame(age_insom_m, nmean_insom_m_ls)
insomdata_insom_m_r <- data.frame(age_insom_m, nmean_insom_m_r)
insomdata_insom_m_w <- data.frame(age_insom_m, nmean_insom_m_w)

# create formulas
insomdata_insom_m_ds.lm <- lm(nmean_insom_m_ds~age_insom_m,data=insomdata_insom_m_ds)
insomdata_insom_m_ls.lm <- lm(nmean_insom_m_ls~age_insom_m,data=insomdata_insom_m_ls)
insomdata_insom_m_r.lm <- lm(nmean_insom_m_r~age_insom_m,data=insomdata_insom_m_r)
insomdata_insom_m_w.lm <- lm(nmean_insom_m_w~age_insom_m,data=insomdata_insom_m_w)

#---------------------------------------
# plot data in deep sleep N3 for insom data
#---------------------------------------
# define axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# add grid
grid()
# scatter plot of all female data
points(insomdata_insom_f_ds,pch=19)
# scatter plot of all male data
points(insomdata_insom_m_ds, pch=21)
# add text containing sleep stage
mtext("Tiefschlaf", adj=0.01, line=-1); 
# add linear regression lines for whole data, female and male data
abline(insomdata_insom_ds.lm, col="green",lty=1)
abline(insomdata_insom_f_ds.lm, col="red",lty=2)
abline(insomdata_insom_m_ds.lm, col="blue",lty=3)
# add a legend
#legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
#       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
#       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in light sleep N2 for insom data
#---------------------------------------
# define axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# plot grid
grid()
# scatter plot of all female data
points(insomdata_insom_f_ls,pch=19)
# scatter plot of all male data
points(insomdata_insom_m_ls, pch=21)
# add text containing sleep stage
mtext("Leichtschlaf", adj=0.01, line=-1);
# add linear regression line for whole data, female and male data
abline(insomdata_insom_ls.lm, col="green",lty=1)
abline(insomdata_insom_f_ls.lm, col="red",lty=2)
abline(insomdata_insom_m_ls.lm, col="blue",lty=3)
# add a legend
legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
                                                 "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in REM sleep for insom data
#---------------------------------------
# define axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# plot grid
grid()
# scatter plot of all female data
points(insomdata_insom_f_r,pch=19)
# scatter plot of all male data
points(insomdata_insom_m_r, pch=21)
# add text containing sleep stage
mtext("REM-Schlaf", adj=0.01, line=-1); 
# add linear regression lines for whole data, female and male data
abline(insomdata_insom_r.lm, col="green",lty=1)
abline(insomdata_insom_f_r.lm, col="red",lty=2)
abline(insomdata_insom_m_r.lm, col="blue",lty=3)
# add a legend
#legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
#       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
#       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in AWAKE for insom data
#---------------------------------------
# degine axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# plot grid
grid()
# scatter plot of all female data
points(insomdata_insom_f_w,pch=19)
# scatter plot of all male data
points(insomdata_insom_m_w, pch=21)
# add text containing sleep stage
mtext("Wachzustand", adj=0.01, line=-1); 
# add linear regression lines for whole data, female and male data
abline(insomdata_insom_w.lm, col="green",lty=1)
abline(insomdata_insom_f_w.lm, col="red",lty=2)
abline(insomdata_insom_m_w.lm, col="blue",lty=3)
# add a legend
#legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
#       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
#       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# linear regression and correlation
#---------------------------------------
# show linear regression parameters for whole data
summary(insomdata_insom_ds.lm)
summary(insomdata_insom_ls.lm)
summary(insomdata_insom_r.lm)
summary(insomdata_insom_w.lm)

# show linear regression parameters for female data
summary(insomdata_insom_f_ds.lm)
summary(insomdata_insom_f_ls.lm)
summary(insomdata_insom_f_r.lm)
summary(insomdata_insom_f_w.lm)

# show linear regression parameters for male data
summary(insomdata_insom_m_ds.lm)
summary(insomdata_insom_m_ls.lm)
summary(insomdata_insom_m_r.lm)
summary(insomdata_insom_m_w.lm)



# extract variables from data frames
attach(insomdata_insom_ds) #extracts age_insom and nmean_insom_ds
attach(insomdata_insom_ls) #extracts age_insom and nmean_insom_ls
attach(insomdata_insom_r) #extracts age_insom and nmean_insom_r
attach(insomdata_insom_w) #extracts age_insom and nmean_insom_w

attach(insomdata_insom_f_ds) #extracts age_insom_f and nmean_insom_f_ds
attach(insomdata_insom_f_ls) #extracts age_insom_f and nmean_insom_f_ls
attach(insomdata_insom_f_r) #extracts age_insom_f and nmean_insom_f_r
attach(insomdata_insom_f_w) #extracts age_insom_f and nmean_insom_f_w

attach(insomdata_insom_m_ds) #extracts age_insom_m and nmean_insom_m_ds
attach(insomdata_insom_m_ls) #extracts age_insom_m and nmean_insom_m_ls
attach(insomdata_insom_m_r) #extracts age_insom_m and nmean_insom_m_r
attach(insomdata_insom_m_w) #extracts age_insom_m and nmean_insom_m_w



# test for normality with shapiro wilk test
shapiro.test(nmean_insom_m_w)
shapiro.test(age_insom_m)

# if p-value of shapiro wilk test > 0.05 apply pearson
# if |r| of pearson close to 1 and p-value < 0.05 = significant correlation
cor.test(nmean_insom_m_w, age_insom_m, method="pearson")

# if p-value of shapiro wilk test !> 0.05 apply spearman
# if |rho| of spearman close to 1 and p-value < 0.05 - significant correlation
cor.test(nmean_insom_m_w, age_insom_m, method="spearman")