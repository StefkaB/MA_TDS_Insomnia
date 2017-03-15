# import Matlab Package
library(R.matlab)

# load file
matfile_all <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age.mat'
matfile_f <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_f.mat'
matfile_m <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/nmean_age_m.mat'
data_all <- readMat(matfile_all)
data_f <- readMat(matfile_f)
data_m <- readMat(matfile_m)

# show type of data
typeof(data_all)

#---------------------------------------
# extract information from whole data
#---------------------------------------
nmean_all_age <- array(unlist(data_all), dim = c(nrow(data_all[[1]]), ncol(data_all[[1]]), 4))
nmean_all_ds <- nmean_age[,1,1]
nmean_all_ls <- nmean_age[,1,2]
nmean_all_r <- nmean_age[,1,3]
nmean_all_w <- nmean_age[,1,4]
age_all <- nmean_age[,2,1]

# create data frame
insomdata_all_ds <- data.frame(age_all, nmean_all_ds)
insomdata_all_ls <- data.frame(age_all, nmean_all_ls)
insomdata_all_r <- data.frame(age_all, nmean_all_r)
insomdata_all_w <- data.frame(age_all, nmean_all_w)

# create formulas
insomdata_all_ds.lm <- lm(nmean_all_ds~age_all,data=insomdata_all_ds)
insomdata_all_ls.lm <- lm(nmean_all_ls~age_all,data=insomdata_all_ls)
insomdata_all_r.lm <- lm(nmean_all_r~age_all,data=insomdata_all_r)
insomdata_all_w.lm <- lm(nmean_all_w~age_all,data=insomdata_all_w)


#---------------------------------------
# extract information from female data
#---------------------------------------
nmean_f_age <- array(unlist(data_f), dim = c(nrow(data_f[[1]]), ncol(data_f[[1]]), 4))
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
nmean_m_age <- array(unlist(data_m), dim = c(nrow(data_m[[1]]), ncol(data_m[[1]]), 4))
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


#---------------------------------------
# plot data in deep sleep N3
#---------------------------------------
# plot data
plot(insomdata_f_ds,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(20,75), ylim=c(0,0.6), pch=19) #points as symbols
# add a line
points(insomdata_m_ds, pch=21)
# side = top margin
# adj = horizontal alignment
# line= vertical alignment
mtext("Tiefschlaf", adj=0.01, line=-1); 
abline(insomdata_all_ds.lm, col="green",lty=1)
abline(insomdata_f_ds.lm, col="red",lty=2)
abline(insomdata_m_ds.lm, col="blue",lty=3)
# Add a legend
legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in ligth sleep N2
#---------------------------------------
# plot data
plot(insomdata_f_ls,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(20,75), ylim=c(0,0.6), pch=19) #points as symbols
# add a line
points(insomdata_m_ls, pch=21)
# side = top margin
# adj = horizontal alignment
# line= vertical alignment
mtext("Leichtschlaf", adj=0.01, line=-1); 
abline(insomdata_all_ls.lm, col="green",lty=1)
abline(insomdata_f_ls.lm, col="red",lty=2)
abline(insomdata_m_ls.lm, col="blue",lty=3)
# Add a legend
legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in ligth REM sleep
#---------------------------------------
# plot data
plot(insomdata_f_r,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(20,75), ylim=c(0,0.6), pch=19) #points as symbols
# add a line
points(insomdata_m_r, pch=21)
# side = top margin
# adj = horizontal alignment
# line= vertical alignment
mtext("REM-Schlaf", adj=0.01, line=-1); 
abline(insomdata_all_r.lm, col="green",lty=1)
abline(insomdata_f_r.lm, col="red",lty=2)
abline(insomdata_m_r.lm, col="blue",lty=3)
# Add a legend
legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
       "red","blue"),pch = c(19,21,NA,NA,NA))


#---------------------------------------
# plot data in ligth REM sleep
#---------------------------------------
# plot data
plot(insomdata_f_w,xlab="Age [yrs]", ylab="Mean Link Strength (nmean)",
     xlim=c(20,75), ylim=c(0,0.6), pch=19) #points as symbols
# add a line
points(insomdata_m_w, pch=21)
# side = top margin
# adj = horizontal alignment
# line= vertical alignment
mtext("Wachzustand", adj=0.01, line=-1); 
abline(insomdata_all_w.lm, col="green",lty=1)
abline(insomdata_f_w.lm, col="red",lty=2)
abline(insomdata_m_w.lm, col="blue",lty=3)
# Add a legend
legend("topright",legend=c("weiblich","männlich","lm(a)","lm(f)","lm(m)"),
       lty=c(NA,NA,1,2,3),pt.cex=1,cex=0.8,col=c("black","black","green",
       "red","blue"),pch = c(19,21,NA,NA,NA))





#summary(insomdata_all_ds.lm)
#summary(insomdata_all_ls.lm)
#summary(insomdata_all_r.lm)
#summary(insomdata_all_w.lm)

#summary(insomdata_f_ds.lm)
#summary(insomdata_f_ls.lm)
#summary(insomdata_f_r.lm)
#summary(insomdata_f_w.lm)

#summary(insomdata_m_ds.lm)
#summary(insomdata_m_ls.lm)
#summary(insomdata_m_r.lm)
#summary(insomdata_m_w.lm)
