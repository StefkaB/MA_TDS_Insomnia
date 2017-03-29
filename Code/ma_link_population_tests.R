# script to apply two-sided hypothesis tests on insomnia data and matches 
# from healthy controls of siesta data (see master thesis of Stefanie Breuer)

############### Metadaata ################
# Stefanie Breuer, 26.03.2017, 
# stefanie.breuer@student.htw-berlin.de
# version 1.0
##########################################

# import Matlab Package
library(R.matlab)

# matlab data paths
matfile_link_insom_ds <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_insom_ds.mat'
matfile_link_insom_ls <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_insom_ls.mat'
matfile_link_insom_r <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_insom_r.mat'
matfile_link_insom_w <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_insom_w.mat'
matfile_link_match_ds <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_match_ds.mat'
matfile_link_match_ls <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_match_ls.mat'
matfile_link_match_r <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_match_r.mat'
matfile_link_match_w <- 'C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/link_match_w.mat'

# format of data: rows=number of patients, columns=all 378 possible links

# load matlab files
link_insom_ds <- readMat(matfile_link_insom_ds)
link_insom_ls <- readMat(matfile_link_insom_ls)
link_insom_r <- readMat(matfile_link_insom_r)
link_insom_w <- readMat(matfile_link_insom_w)
link_match_ds <- readMat(matfile_link_match_ds)
link_match_ls <- readMat(matfile_link_match_ls)
link_match_r <- readMat(matfile_link_match_r)
link_match_w <- readMat(matfile_link_match_w)

#------------------------------------------------
# loop over links (tds elements) of deep sleep
#------------------------------------------------
# allocate counters and vector for p-values
countnorm <- 0
countwil <- 0
countttest <- 0
countwelchtest <- 0
p_population_ds <- numeric(378)

# loop over all links
for (i in seq(from=1, to=378, by=1)) {
  
  # extract link strengths of all patients and matches for each link
  insom_ds <- link_insom_ds[[1]][,i]
  match_ds <- link_match_ds[[1]][,i]
  
  # check for normality, apply shapiro wilk
  p_insom_shapiro <- shapiro.test(insom_ds)$p.value
  p_match_shapiro <- shapiro.test(match_ds)$p.value
  
  # check if both populations show normal distribution
  if (p_insom_shapiro>=0.05 && p_match_shapiro>=0.05) {
    
    # if normal distribution in both data sets apply variance test
    p_variance <- var.test(insom_ds,match_ds)$p.value
    countnorm <- countnorm+1
    
    # check homogeneity of variances
    if (p_variance>=0.05) {
      # apply student's t-test with silimar variances
      p_value <- t.test(insom_ds,match_ds,var.equal=TRUE,paired=FALSE,alternative="two.sided")$p.value
      counttttest <- countttest+1
    }
    else {
      # apply welch test with differing variances
      p_value <- t.test(insom_ds,match_ds,var.equal=FALSE,paired=FALSE,alternative="two.sided")$p.value
      countwelchtest <- countwelchtest+1
    }
  }
  else {
    # if at least one data set is not normal distributed apply wilcoxon rank sum test
    p_value <- wilcox.test(insom_ds,match_ds,alternative = "two.sided")$p.value
    #print(p_wilcox)
    countwil <- countwil+1
  }
  
  # write p-value into result vector
  p_population_ds[i] <- p_value
}


#------------------------------------------------
# loop over links (tds elements) of light sleep
#------------------------------------------------
# allocate counters and vector for p-values
countnorm <- 0
countwil <- 0
countttest <- 0
countwelchtest <- 0
p_population_ls <- numeric(378)

# loop over all links
for (i in seq(from=1, to=378, by=1)) {
  
  # extract link strengths of all patients and matches for each link
  insom_ls <- link_insom_ls[[1]][,i]
  match_ls <- link_match_ls[[1]][,i]
  
  # check for normality, apply shapiro wilk
  p_insom_shapiro <- shapiro.test(insom_ls)$p.value
  p_match_shapiro <- shapiro.test(match_ls)$p.value
  
  # check if both populations show normal distribution
  if (p_insom_shapiro>=0.05 && p_match_shapiro>=0.05) {
    
    # if normal distribution in both data sets, apply variance test
    p_variance <- var.test(insom_ls,match_ls)$p.value
    countnorm <- countnorm+1
    
    # check homogeneity of variances
    if (p_variance>=0.05) {
      # apply student's t-test with silimar variances
      p_value <- t.test(insom_ls,match_ls,var.equal=TRUE,paired=FALSE,alternative="two.sided")$p.value
      counttttest <- countttest+1
    }
    else {
      # apply welch test with differing variances
      p_value <- t.test(insom_ls,match_ls,var.equal=FALSE,paired=FALSE,alternative="two.sided")$p.value
      countwelchtest <- countwelchtest+1
    }
  }
  else {
    # if at least one data set is not normal distributed
    # apply wilcoxon rank sum test
    p_value <- wilcox.test(insom_ls,match_ls,alternative = "two.sided")$p.value
    #print(p_wilcox)
    countwil <- countwil+1
  }
  
  # write p-value into result vector
  p_population_ls[i] <- p_value
}


#------------------------------------------------
# loop over links (tds elements) of REM sleep
#------------------------------------------------
# allocate counters and vector for p-values
countnorm <- 0
countwil <- 0
countttest <- 0
countwelchtest <- 0
p_population_r <- numeric(378)

# loop over all links
for (i in seq(from=1, to=378, by=1)) {
  
  # extract link strengths of all patients and matches for each link
  insom_r <- link_insom_r[[1]][,i]
  match_r <- link_match_r[[1]][,i]
  
  # check for normality, apply shapiro wilk
  p_insom_shapiro <- shapiro.test(insom_r)$p.value
  p_match_shapiro <- shapiro.test(match_r)$p.value
  
  # check if both populations show normal distribution
  if (p_insom_shapiro>=0.05 && p_match_shapiro>=0.05) {
    
    # if normal distribution in both data sets, apply variance test
    p_variance <- var.test(insom_r,match_r)$p.value
    countnorm <- countnorm+1
    
    # check homogeneity of variances
    if (p_variance>=0.05) {
      # apply student's t-test with silimar variances
      p_value <- t.test(insom_r,match_r,var.equal=TRUE,paired=FALSE,alternative="two.sided")$p.value
      counttttest <- countttest+1
    }
    else {
      # apply welch test with differing variances
      p_value <- t.test(insom_r,match_r,var.equal=FALSE,paired=FALSE,alternative="two.sided")$p.value
      countwelchtest <- countwelchtest+1
    }
  }
  else {
    # if at least one data set is not normal distributed, apply wilcoxon rank sum test
    p_value <- wilcox.test(insom_r,match_r,alternative = "two.sided")$p.value
    #print(p_wilcox)
    countwil <- countwil+1
  }
  
  # write p-value into result vector
  p_population_r[i] <- p_value
}


#------------------------------------------------
# loop over links (tds elements) of wake
#------------------------------------------------
# allocate counters and vector for p-values
countnorm <- 0
countwil <- 0
countttest <- 0
countwelchtest <- 0
p_population_w <- numeric(378)

# loop over all links
for (i in seq(from=1, to=378, by=1)) {
  
  # extract link strengths of all patients and matches for each link
  insom_w <- link_insom_w[[1]][,i]
  match_w <- link_match_w[[1]][,i]
  
  # check for normality, apply shapiro wilk
  p_insom_shapiro <- shapiro.test(insom_w)$p.value
  p_match_shapiro <- shapiro.test(match_w)$p.value
  
  # check if both populations show normal distribution
  if (p_insom_shapiro>=0.05 && p_match_shapiro>=0.05) {
    
    # if normal distribution in both data sets, apply variance test
    p_variance <- var.test(insom_w,match_w)$p.value
    countnorm <- countnorm+1
    
    # check homogeneity of variances
    if (p_variance>=0.05) {
      
      # apply student's t-test with silimar variances
      p_value <- t.test(insom_w,match_w,var.equal=TRUE,paired=FALSE,alternative="two.sided")$p.value
      counttttest <- countttest+1
    }
    else {
      # apply welch test with differing variances
      p_value <- t.test(insom_w,match_w,var.equal=FALSE,paired=FALSE,alternative="two.sided")$p.value
      countwelchtest <- countwelchtest+1
    }
  }
  else {
    # if at least one data set is not normal distributed, apply wilcoxon rank sum test
    p_value <- wilcox.test(insom_w,match_w,alternative = "two.sided")$p.value
    #print(p_wilcox)
    countwil <- countwil+1
  }
  
  # write p-value into result vector
  p_population_w[i] <- p_value
}


#------------------------------------------------
# adjust p-values for multiple comparison
#------------------------------------------------
# adjust significance levels with bonferroni correction by deviding 
# all p-values by the number of extracted p-values which is for tds
# matrices with 28x28 dim (28^2-28)/2 = 378
p_population_ds_corrected <- p.adjust(p_population_ds, method = "bonferroni")
p_population_ls_corrected <- p.adjust(p_population_ls, method = "bonferroni")
p_population_r_corrected <- p.adjust(p_population_r, method = "bonferroni")
p_population_w_corrected <- p.adjust(p_population_w, method = "bonferroni")

#------------------------------------------------
# save data into .mat file
#------------------------------------------------
# write uncorrected and corrected p-values into .mat file
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_ds.mat",p_population_ds=p_population_ds)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_ls.mat",p_population_ls=p_population_ls)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_r.mat",p_population_r=p_population_r)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_w.mat",p_population_w=p_population_w)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_ds_corrected.mat",p_population_ds_corrected=p_population_ds_corrected)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_ls_corrected.mat",p_population_ls_corrected=p_population_ls_corrected)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_r_corrected.mat",p_population_r_corrected=p_population_r_corrected)
writeMat("C:/Users/Stefka/Documents/MATLAB/TDS_Insomnia/p_population_w_corrected.mat",p_population_w_corrected=p_population_w_corrected)

# to plot p-values in matlab use ma_plot_p_values_insom_match.m