# script to calculate linear regression model over all tds links for each sleep stage

############### Metadaata ################
# Stefanie Breuer, 27.03.2017, 
# stefanie.breuer@student.htw-berlin.de
# version 1.0
##########################################

# import Matlab Package
library(R.matlab)

# matlab data paths
matfile_ds_link <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/ds_link.mat'
matfile_ls_link <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/ls_link.mat'
matfile_r_link <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/r_link.mat'
matfile_w_link <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/w_link.mat'
matfile_pat_age <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/pat_age.mat'

# load data from matlab files
# format of data: 378 rows for all links, 41 columns for all patients
ds_link <- readMat(matfile_ds_link)
ls_link <- readMat(matfile_ls_link)
r_link <- readMat(matfile_r_link)
w_link <- readMat(matfile_w_link)
pat_age_list <- readMat(matfile_pat_age)
pat_age <- pat_age_list[[1]][1,]

num_pat <- length(pat_age)

# allocate zero vectors for slopes and p-values
linreg_m_ds <- numeric(378) #slopes
linreg_m_ls <- numeric(378)
linreg_m_r <- numeric(378)
linreg_m_w <- numeric(378)
linreg_p_ds <- numeric(378) #p-values
linreg_p_ls <- numeric(378)
linreg_p_r <- numeric(378)
linreg_p_w <- numeric(378)

# example: tds element for all patients in ds_link with ds_link[1,]
# all ages in pat_age with pat_age[,]

# create linear models for each link over all patients
for (i in seq(from=1, to=378, by=1)) {
  links_ds <- ds_link[[1]][i,]
  links_ds.lm <- lm(links_ds~pat_age)
  links_ls <- ls_link[[1]][i,]
  links_ls.lm <- lm(links_ls~pat_age)
  links_r <- r_link[[1]][i,]
  links_r.lm <- lm(links_r~pat_age)
  links_w <- w_link[[1]][i,]
  links_w.lm <- lm(links_w~pat_age)
  # extract slope and p-value
  m_ds <- summary(links_ds.lm)$coefficients[2,1] #slope
  p_ds <- summary(links_ds.lm)$coefficients[2,4] #p-value
  # save slope and p-value for patient i for deep sleep
  linreg_m_ds[i] <- m_ds
  linreg_p_ds[i] <- p_ds
  m_ls <- summary(links_ls.lm)$coefficients[2,1] #slope
  p_ls <- summary(links_ls.lm)$coefficients[2,4] #p-value
  # save slope and p-value for patient i for light sleep
  linreg_m_ls[i] <- m_ls
  linreg_p_ls[i] <- p_ls
  m_r <- summary(links_r.lm)$coefficients[2,1] #slope
  p_r <- summary(links_r.lm)$coefficients[2,4] #p-value
  # save slope and p-value for patient i for rem sleep
  linreg_m_r[i] <- m_r
  linreg_p_r[i] <- p_r
  m_w <- summary(links_w.lm)$coefficients[2,1] #slope
  p_w <- summary(links_w.lm)$coefficients[2,4] #p-value
  # save slope and p-value for patient i for sleep stage awake
  linreg_m_w[i] <- m_w
  linreg_p_w[i] <- p_w
}

# adjust significance levels with bonferroni correction by deviding 
# all p-values by the number of extracted p-values which is for tds
# matrices with 28x28 dim (28^2-28)/2 = 378
linreg_p_ds_corrected <- p.adjust(linreg_p_ds, method = "bonferroni")
linreg_p_ls_corrected <- p.adjust(linreg_p_ls, method = "bonferroni")
linreg_p_r_corrected <- p.adjust(linreg_p_r, method = "bonferroni")
linreg_p_w_corrected <- p.adjust(linreg_p_w, method = "bonferroni")

# write slopes, uncorrected and corrected p-values into .mat file
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_m_ds.mat",linreg_m_ds=linreg_m_ds)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_m_ls.mat",linreg_m_ls=linreg_m_ls)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_m_r.mat",linreg_m_r=linreg_m_r)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_m_w.mat",linreg_m_w=linreg_m_w)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_ds.mat",linreg_p_ds=linreg_p_ds)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_ls.mat",linreg_p_ls=linreg_p_ls)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_r.mat",linreg_p_r=linreg_p_r)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_w.mat",linreg_p_w=linreg_p_w)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_ds_corrected.mat",linreg_p_ds_corrected=linreg_p_ds_corrected)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_ls_corrected.mat",linreg_p_ls_corrected=linreg_p_ls_corrected)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_r_corrected.mat",linreg_p_r_corrected=linreg_p_r_corrected)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/linreg_p_w_corrected.mat",linreg_p_w_corrected=linreg_p_w_corrected)

# to plot slopes in matlab use ma_build_matrix_linreg_groups.m  
# to plot p-values use ma_plot_linreg_groups.m afterwards