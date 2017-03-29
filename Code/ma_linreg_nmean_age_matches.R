# script to calculate linear regression model and plot data from global mean
# link strength (nmean) and age of all patients, all female and all male of 
# matches for insomnia patients (see master thesis of Stefanie Breuer for 
# classification of matches) 

############### Metadaata ################
# Stefanie Breuer, 26.03.2017, 
# stefanie.breuer@student.htw-berlin.de
# version 1.0
##########################################

# import Matlab Package
library(R.matlab)

# matlab data paths
matfile_all <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_all_match.mat'
matfile_f <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_f_match.mat'
matfile_m <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_m_match.mat'

# load matlab files
data_all <- readMat(matfile_all)
data_f <- readMat(matfile_f)
data_m <- readMat(matfile_m)

# show type of data
typeof(data_all)

#---------------------------------------
# extract information from whole data
#---------------------------------------
# unlist data
nmean_all_age <- array(unlist(data_all), dim = c(nrow(data_all[[1]]), ncol(data_all[[1]]), 4))

# form vectors for each sleep stage and age
nmean_all_ds <- nmean_all_age[,1,1]
nmean_all_ls <- nmean_all_age[,1,2]
nmean_all_r <- nmean_all_age[,1,3]
nmean_all_w <- nmean_all_age[,1,4]
age_all <- nmean_all_age[,2,1]

# create data frames
insomdata_all_ds <- data.frame(age_all, nmean_all_ds)
insomdata_all_ls <- data.frame(age_all, nmean_all_ls)
insomdata_all_r <- data.frame(age_all, nmean_all_r)
insomdata_all_w <- data.frame(age_all, nmean_all_w)

# create linear models
insomdata_all_ds.lm <- lm(nmean_all_ds~age_all,data=insomdata_all_ds)
insomdata_all_ls.lm <- lm(nmean_all_ls~age_all,data=insomdata_all_ls)
insomdata_all_r.lm <- lm(nmean_all_r~age_all,data=insomdata_all_r)
insomdata_all_w.lm <- lm(nmean_all_w~age_all,data=insomdata_all_w)

#---------------------------------------
# extract information from female data
#---------------------------------------
# unlist data
nmean_f_age <- array(unlist(data_f), dim = c(nrow(data_f[[1]]), ncol(data_f[[1]]), 4))

# form vectors for each sleep stage and age
nmean_f_ds <- nmean_f_age[,1,1]
nmean_f_ls <- nmean_f_age[,1,2]
nmean_f_r <- nmean_f_age[,1,3]
nmean_f_w <- nmean_f_age[,1,4]
age_f <- nmean_f_age[,2,1]

# create data frame
insomdata_f_ds <- data.frame(age_f, nmean_f_ds)
insomdata_f_ls <- data.frame(age_f, nmean_f_ls)
insomdata_f_r <- data.frame(age_f, nmean_f_r)
insomdata_f_w <- data.frame(age_f, nmean_f_w)

# create formulas
insomdata_f_ds.lm <- lm(nmean_f_ds~age_f,data=insomdata_f_ds)
insomdata_f_ls.lm <- lm(nmean_f_ls~age_f,data=insomdata_f_ls)
insomdata_f_r.lm <- lm(nmean_f_r~age_f,data=insomdata_f_r)
insomdata_f_w.lm <- lm(nmean_f_w~age_f,data=insomdata_f_w)

#---------------------------------------
# extract information from male data
#---------------------------------------
# unlist data
nmean_m_age <- array(unlist(data_m), dim = c(nrow(data_m[[1]]), ncol(data_m[[1]]), 4))

# form vectors for each sleep stage and age
nmean_m_ds <- nmean_m_age[,1,1]
nmean_m_ls <- nmean_m_age[,1,2]
nmean_m_r <- nmean_m_age[,1,3]
nmean_m_w <- nmean_m_age[,1,4]
age_m <- nmean_m_age[,2,1]

# create data frame
insomdata_m_ds <- data.frame(age_m, nmean_m_ds)
insomdata_m_ls <- data.frame(age_m, nmean_m_ls)
insomdata_m_r <- data.frame(age_m, nmean_m_r)
insomdata_m_w <- data.frame(age_m, nmean_m_w)

# create formulas
insomdata_m_ds.lm <- lm(nmean_m_ds~age_m,data=insomdata_m_ds)
insomdata_m_ls.lm <- lm(nmean_m_ls~age_m,data=insomdata_m_ls)
insomdata_m_r.lm <- lm(nmean_m_r~age_m,data=insomdata_m_r)
insomdata_m_w.lm <- lm(nmean_m_w~age_m,data=insomdata_m_w)



# Multiplot
#par(mfrow=c(2,2))


#---------------------------------------
# plot data in deep sleep N3 for whole data
#---------------------------------------
# define axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# plot grid
grid()
# scatter plot of all female data
points(insomdata_f_ds,pch=19)
# scatter plot of all male data
points(insomdata_m_ds, pch=21)
# add text containing sleep stage
mtext("Tiefschlaf", adj=0.01, line=-1); 
# add linear regression lines for whole data, female and male data
abline(insomdata_all_ds.lm, col="green",lty=1)
abline(insomdata_f_ds.lm, col="red",lty=2)
abline(insomdata_m_ds.lm, col="blue",lty=3)
# add a legend
#legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
#       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
#       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in light sleep N2 for whole data
#---------------------------------------
# define axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# plot grid
grid()
# scatter plot for all female data
points(insomdata_f_ls,pch=19)
# scatter plot for all male data
points(insomdata_m_ls, pch=21)
# add text containing sleep stage
mtext("Leichtschlaf", adj=0.01, line=-1); 
# add linear regression line for whole data, female and male data
abline(insomdata_all_ls.lm, col="green",lty=1)
abline(insomdata_f_ls.lm, col="red",lty=2)
abline(insomdata_m_ls.lm, col="blue",lty=3)
# add a legend
legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
                                                 "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in REM sleep for whole data
#---------------------------------------
# define axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# plot grid
grid()
# scatter plot of all female data
points(insomdata_f_r,pch=19)
# scatter plot of all male data
points(insomdata_m_r, pch=21)
# add text containing sleep stage
mtext("REM-Schlaf", adj=0.01, line=-1);
# add linear regression lines for whole data, female and male data
abline(insomdata_all_r.lm, col="green",lty=1)
abline(insomdata_f_r.lm, col="red",lty=2)
abline(insomdata_m_r.lm, col="blue",lty=3)
# add a legend
#legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
#       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
#       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in AWAKE for whole data
#---------------------------------------
# define axis
plot(1:10, 1:10,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(22,75), ylim=c(0.023,0.5795))
# plot grid
grid()
# scatter plot of all female data
points(insomdata_f_w,pch=19)
# scatter plot of all male data
points(insomdata_m_w, pch=21)
# add text containing sleep stage
mtext("Wachzustand", adj=0.01, line=-1); 
# add linear regressin line for whole data, female and male data
abline(insomdata_all_w.lm, col="green",lty=1)
abline(insomdata_f_w.lm, col="red",lty=2)
abline(insomdata_m_w.lm, col="blue",lty=3)
# add a legend
#legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
#       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
#       "red","blue"),pch = c(19,21,NA,NA,NA))



#---------------------------------------
# linear regression and correlation
#---------------------------------------
# show linear regression parameters for whole data
summary(insomdata_all_ds.lm)
summary(insomdata_all_ls.lm)
summary(insomdata_all_r.lm)
summary(insomdata_all_w.lm)

# show linear regression parameters for female data
summary(insomdata_f_ds.lm)
summary(insomdata_f_ls.lm)
summary(insomdata_f_r.lm)
summary(insomdata_f_w.lm)

# show linear regression parameters for male data
summary(insomdata_m_ds.lm)
summary(insomdata_m_ls.lm)
summary(insomdata_m_r.lm)
summary(insomdata_m_w.lm)


# extract variables from data frames
attach(insomdata_all_ds) #extracts age_all and nmean_all_ds
attach(insomdata_all_ls) #extracts age_all and nmean_all_ls
attach(insomdata_all_r) #extracts age_all and nmean_all_r
attach(insomdata_all_w) #extracts age_all and nmean_all_w

attach(insomdata_f_ds) #extracts age_f and nmean_f_ds
attach(insomdata_f_ls) #extracts age_f and nmean_f_ls
attach(insomdata_f_r) #extracts age_f and nmean_f_r
attach(insomdata_f_w) #extracts age_f and nmean_f_w

attach(insomdata_m_ds) #extracts age_m and nmean_m_ds
attach(insomdata_m_ls) #extracts age_m and nmean_m_ls
attach(insomdata_m_r) #extracts age_m and nmean_m_r
attach(insomdata_m_w) #extracts age_m and nmean_m_w



# test for normality with shapiro wilk test
shapiro.test(nmean_m_ds)
shapiro.test(age_m)

# if p-value of shapiro wilk test > 0.05 apply pearson
# if |r| of pearson close to 1 and p-value < 0.05 = significant correlation
cor.test(nmean_m_ds, age_m, method="pearson")

# if p-value of shapiro wilk test !> 0.05 apply spearman
# if |rho| of spearman close to 1 and p-value < 0.05 - significant correlation
cor.test(nmean_m_ds, age_m, method="spearman")
