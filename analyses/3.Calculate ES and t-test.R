# CALCULATE EFFECT-SIZES (HEDGE'S G) AND WELCH'S TEST 
# Elisa Lancini (elisa.lancini@dzne.de)

## Description:
  # Effect sizes and Welch's test p-values are calculated and saved into excel files.
  # The significance levels are coded as ns, * , ** , *** and entered in a column in the excel file.
  # The type of t-test is reported in a column in the excel file.
  # The type of shape to use in the plot is determined based on methods used, and stored in a respective column

#  Change path  ----------------------
mypath="/Users/elisalancini/Dropbox/PhD/SynAge/review"

# Load libraries ----------------------
library(readxl)
library(openxlsx)
library(writexl)
library(esc)
library(magrittr)
library(dplyr)

# Function for Welch's test (by Calida Pereira) ----------------------
# Adapted from https://stats.stackexchange.com/questions/30394/how-to-perform-two-sample-t-tests-in-r-by-inputting-sample-statistics-rather-tha

t.test2 <- function(m1,m2,s1,s2,n1,n2,m0=0,equal.variance=FALSE)
{
  if( equal.variance==FALSE ) 
  {
    se <- sqrt( (s1^2/n1) + (s2^2/n2) )
    df <- ( (s1^2/n1 + s2^2/n2)^2 )/( (s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1) )
  } else
  {
    # pooled standard deviation, scaled by the sample sizes
    se <- sqrt( (1/n1 + 1/n2) * ((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2) ) 
    df <- n1+n2-2
  }      
  t <- (m1-m2-m0)/se 
  dat <- c(m1-m2, se, t, 2*pt(-abs(t),df))    
  names(dat) <- c("Difference of means", "Std Error", "t", "p-value")
  return(dat) 
}

# CSF MHPG data -------------------------------------------------------------------

dataMHPG <- read_excel(paste(mypath,"/data/1.Articles and data.xlsx",sep=""), sheet = "Incl_CSF_MHPG_HCsplit")
View(dataMHPG)

########## Calculate Hedge's g from MEAN AND SD
# healthy
n2<-round(dataMHPG$nC, digits =9)
m2<-round(dataMHPG$MeanHC, digits =9)
sd2<-round(dataMHPG$SDHC, digits =9)

# pathology
n1<-round(dataMHPG$nP, digits =9)
m1<-round(as.numeric(dataMHPG$`Mean P`), digits =9)
sd1<-round(dataMHPG$SDP, digits =9)

# Calculate (no rounding)
effectsizes=esc_mean_sd(grp1m= m1,
                        grp1sd= sd1,
                        grp1n= n1,
                        grp2m= m2,
                        grp2sd= sd2,
                        grp2n=n2,
                        es.type="g")

# paste into data
dataMHPG$g<-effectsizes[["es"]]
dataMHPG$se<-effectsizes[["se"]]
dataMHPG$var<-effectsizes[["var"]]
dataMHPG$lower<-effectsizes[["ci.lo"]]
dataMHPG$upper<-effectsizes[["ci.hi"]]
dataMHPG$weight<-effectsizes[["w"]]

#remove variables
rm(m1)
rm(m2)
rm(sd1)
rm(sd2)
rm(n1)
rm(n2)

##########  Calculate Welch-test between each condition

# calculate p-value in loop
max=as.numeric(length(dataMHPG$nC))
for (i in 1:max){
  m1=dataMHPG$MeanHC[i]
  m2=dataMHPG$`Mean P`[i]
  sd1=dataMHPG$SDHC[i]
  sd2=dataMHPG$SDP[i]
  n1=dataMHPG$nC[i]
  n2=dataMHPG$nP[i]
  
  # calculate
  tt2 <- t.test2(m1,m2,sd1,sd2,n1,n2)
  
  # extract p value
  pval<-as.numeric(tt2[4])
  
  # paste pval into dataset , convert into * when significant and add method of analysis
  dataMHPG$signif[i]<-round(pval, digits = 4)
  if(dataMHPG$signif[i] > 0.05){
    dataMHPG$`sign in txt`[i]<-"ns"
  } else if (dataMHPG$signif[i] <= 0.001) {
    dataMHPG$`sign in txt`[i]<-"***"
  } else if (dataMHPG$signif[i] <= 0.01) {
    dataMHPG$`sign in txt`[i]<-"**"
  } else if (dataMHPG$signif[i] <= 0.05) {
    dataMHPG$`sign in txt`[i]<-"*"
  }
  dataMHPG$`calculated with` [i]<-"Welch's t-test R"
  
  #remove variables
  rm(m1)
  rm(m2)
  rm(sd1)
  rm(sd2)
  rm(n1)
  rm(n2)
  rm(pval)
}  

########## Write shape based on methods
max=as.numeric(length(dataMHPG$nC))
for (i in 1:max){
  if(dataMHPG$Method[i] == "HPLC" || dataMHPG$Method[i] =="LC-ED" || dataMHPG$Method[i] =="HPLC-ECD"||dataMHPG$Method[i] == "HPLC-AD" ||dataMHPG$Method[i] =="RP-HPLC IP"|| dataMHPG$Method[i] =="RP-HPLC-ECD"|| dataMHPG$Method[i] =="LC-ED" || dataMHPG$Method[i] =="RP-UHPLC-ECD" ){
    dataMHPG$shape[i]<-"fpDrawNormalCI"
    dataMHPG$Method[i]<-"Liquid"
  } else if (dataMHPG$Method[i] == "GC/MS"|| dataMHPG$Method[i] =="GLC"|| dataMHPG$Method[i] =="MF"|| dataMHPG$Method[i] =="GC"){
    dataMHPG$shape[i]<-"fpDrawDiamondCI"
    dataMHPG$Method[i]<-"Gas"
  } else if (dataMHPG$Method[i] == "RM"){
    dataMHPG$shape[i]<-"fpDrawCircleCI"
  }
}

# filter data to create different excel excel sheets
wherePD<-dataMHPG[dataMHPG$Pathology == "PD", ]
temp.AD<-dataMHPG[dataMHPG$Pathology == "AD", ]
temp.DAT<-dataMHPG[dataMHPG$Pathology == "DAT", ]
temp.SDAT<-dataMHPG[dataMHPG$Pathology == "SDAT", ]
temp.ADSDAT<-dataMHPG[dataMHPG$Pathology == "AD/SDAT", ]
whereAD = bind_rows(temp.AD,temp.DAT,temp.SDAT,temp.ADSDAT)

# write it
write.xlsx(dataMHPG, file=paste(mypath,"/analyses/3.ES MHPG.xlsx",sep=""), sheetName="MHPG", row.names=FALSE)
write.xlsx(wherePD, file=paste(mypath,"/analyses/3.ES MHPG_PD.xlsx",sep=""), sheetName="MHPG_PD", row.names=FALSE)
write.xlsx(whereAD, file=paste(mypath,"/analyses/3.ES MHPG_AD.xlsx",sep=""), sheetName="MHPG_AD", row.names=FALSE)

#---------------------------------- clean -----------------------------------
#remove temporary variables created
rm(list = ls(pattern = "^temp\\."))
rm(list = ls(pattern = "^where."))

#remove others
rm(effectsizes)
rm(max)
rm(i)
rm(tt2)


# CSF NA data -------------------------------------------------------------------
dataNA <- read_excel(paste(mypath,"/data/1.Articles and data.xlsx",sep=""), sheet = "Incl_CSF_NA_HCsplit")
View(dataNA)

########## Calculate Hedge's g from MEAN AND SD
# healthy
n2<-round(dataNA$nC, digits =9)
m2<-round(dataNA$MeanHC, digits =9)
sd2<-round(dataNA$SDHC, digits =9)

# pathology
n1<-round(dataNA$nP, digits =9)
m1<-round(as.numeric(dataNA$`Mean P`), digits =9)
sd1<-round(dataNA$SDP, digits =9)

# Calculate (no rounding)
effectsizes=esc_mean_sd(grp1m= m1,
                          grp1sd= sd1,
                          grp1n= n1,
                          grp2m= m2,
                          grp2sd= sd2,
                          grp2n=n2,
                          es.type="g")
# paste into data
dataNA$g<-effectsizes[["es"]]
dataNA$se<-effectsizes[["se"]]
dataNA$var<-effectsizes[["var"]]
dataNA$lower<-effectsizes[["ci.lo"]]
dataNA$upper<-effectsizes[["ci.hi"]]
dataNA$weight<-effectsizes[["w"]]

#remove variables
rm(m1)
rm(m2)
rm(sd1)
rm(sd2)
rm(n1)
rm(n2)

##########  Calculate Welch-test between each condition
# calculate p-value 
max=as.numeric(length(dataNA$nC))
for (i in 1:max){
  m1=dataNA$MeanHC[i]
  m2=dataNA$`Mean P`[i]
  sd1=dataNA$SDHC[i]
  sd2=dataNA$SDP[i]
  n1=dataNA$nC[i]
  n2=dataNA$nP[i]
  
  # calculate
  tt2 <- t.test2(m1,m2,sd1,sd2,n1,n2)
  
  # extract p value
  pval<-as.numeric(tt2[4])
  
  # paste pval into dataset , convert into * when significant, and add method of analysis
  dataNA$signif[i]<-round(pval, digits = 4)
  if(dataNA$signif[i] > 0.05){
    dataNA$`sign in txt`[i]<-"ns"
  } else if (dataNA$signif[i] <= 0.001) {
    dataNA$`sign in txt`[i]<-"***"
  } else if (dataNA$signif[i] <= 0.01) {
    dataNA$`sign in txt`[i]<-"**"
  } else if (dataNA$signif[i] <= 0.05) {
    dataNA$`sign in txt`[i]<-"*"
  }
  dataNA$`calculated with` [i]<-"Welch's t-test R"
  
  #remove variables
  rm(m1)
  rm(m2)
  rm(sd1)
  rm(sd2)
  rm(n1)
  rm(n2)
  rm(pval)
}

########## Write shape based on methods
max=as.numeric(length(dataNA$nC))
for (i in 1:max){
  if(dataNA$Method[i] == "HPLC" || dataNA$Method[i] =="LC-ED" || dataNA$Method[i] =="HPLC-ECD"||dataNA$Method[i] == "HPLC-AD" ||dataNA$Method[i] =="RP-HPLC IP"|| dataNA$Method[i] =="RP-HPLC-ECD"|| dataNA$Method[i] =="RP-UHPLC-ECD"||dataNA$Method[i] =="LC-ED" ){
    dataNA$shape[i]<-"fpDrawNormalCI"
    dataNA$Method[i]<-"Liquid"
    
  } else if (dataNA$Method[i] == "GC/MS"|| dataNA$Method[i] =="GLC"|| dataNA$Method[i] =="MF"){
    dataNA$shape[i]<-"fpDrawDiamondCI"
    dataNA$Method[i]<-"Gas"
    
  } else if (dataNA$Method[i] == "RM"){
    dataNA$shape[i]<-"fpDrawCircleCI "
  }
}

# filter data to create different excel files
wherePD<-dataNA[dataNA$Pathology == "PD", ]
temp.AD<-dataNA[dataNA$Pathology == "AD", ]
temp.DAT<-dataNA[dataNA$Pathology == "DAT", ]
temp.SDAT<-dataNA[dataNA$Pathology == "SDAT", ]
temp.ADSDAT<-dataNA[dataNA$Pathology == "AD/SDAT", ]
whereAD = bind_rows(temp.AD,temp.DAT,temp.SDAT,temp.ADSDAT)

# write 
write.xlsx(dataNA, file=paste(mypath,"/analyses/3.ES NA.xlsx",sep=""), sheetName="NA", row.names=FALSE)
write.xlsx(wherePD, file=paste(mypath,"/analyses/3.ES NA_PD.xlsx",sep=""), sheetName="NA_PD", row.names=FALSE)
write.xlsx(whereAD, file=paste(mypath,"/analyses/3.ES NA_AD.xlsx",sep=""), sheetName="NA_AD", row.names=FALSE)

#---------------------------------- clean -----------------------------------
#remove temporary variables created
rm(list = ls(pattern = "^temp\\."))
rm(list = ls(pattern = "^where."))

#remove others
rm(effectsizes)
rm(max)
rm(i)
rm(tt2)

# PET data -------------------------------------------------------------------
dataMener <- read_excel(paste(mypath,"/data/1.Articles and data.xlsx",sep=""), sheet = "Incl_PET MeNer")
View(dataMener)

########## Calculate Hedge's g from MEAN AND SD
# healthy
n2<-round(dataMener$nC, digits =9)
m2<-round(as.numeric(dataMener$`Mean HC`), digits =9)
sd2<-round(as.numeric(dataMener$`SD HC`), digits =9)

# pathology
n1<-round(dataMener$nP, digits =9)
m1<-round(as.numeric(dataMener$`Mean P`), digits =9)
sd1<-round(as.numeric(dataMener$`SD P`), digits =9)

# Calculate (no rounding)
effectsizes=esc_mean_sd(grp1m= m1,
                        grp1sd= sd1,
                        grp1n= n1,
                        grp2m= m2,
                        grp2sd= sd2,
                        grp2n=n2,
                        es.type="g")
# paste into data
dataMener$g<-effectsizes[["es"]]
dataMener$se<-effectsizes[["se"]]
dataMener$var<-effectsizes[["var"]]
dataMener$lower<-effectsizes[["ci.lo"]]
dataMener$upper<-effectsizes[["ci.hi"]]
dataMener$weight<-effectsizes[["w"]]

#remove variables
rm(m1)
rm(m2)
rm(sd1)
rm(sd2)
rm(n1)
rm(n2)

##########  Calculate Welch-test between each condition

# calculate p-value 
max=as.numeric(length(dataMener$nC))
for (i in 1:max){
  m1=as.numeric(dataMener$`Mean HC`[i])
  m2=as.numeric(dataMener$`Mean P`[i])
  sd1=as.numeric(dataMener$`SD HC`[i])
  sd2=as.numeric(dataMener$`SD P`[i])
  n1=dataMener$nC[i]
  n2=dataMener$nP[i]
  
  # calculate
  tt2 <- t.test2(m1,m2,sd1,sd2,n1,n2)
  
  # extract p value
  pval<-as.numeric(tt2[4])
  
  # paste pval into dataset , convert into * when significant, and add method of analysis
  dataMener$signif[i]<-round(pval, digits = 4)
  if(dataMener$signif[i] > 0.05){
    dataMener$`sign in txt`[i]<-"ns"
  } else if (dataMener$signif[i] <= 0.001) {
    dataMener$`sign in txt`[i]<-"***"
  } else if (dataMener$signif[i] <= 0.01) {
    dataMener$`sign in txt`[i]<-"**"
  } else if (dataMener$signif[i] <= 0.05) {
    dataMener$`sign in txt`[i]<-"*"
  }
  dataMener$`calculated with` [i]<-"Welch's t-test R"
  
  #remove variables
  rm(m1)
  rm(m2)
  rm(sd1)
  rm(sd2)
  rm(n1)
  rm(n2)
  rm(pval)
}


# filter data to create different files
thalamus<-dataMener[dataMener$Region == "thalamus", ]
hypothalamus<-dataMener[dataMener$Region == "hypothalamus", ]
lc<-dataMener[dataMener$Region == "LC", ]
medianraphe<-dataMener[dataMener$Region == "median raphe", ]
nucleusruber<-dataMener[dataMener$Region == "nucleus ruber", ]

# write 
write.xlsx(dataMener, file=paste(mypath,"/analyses/3.ES PET.xlsx",sep=""), sheetName="Mener", row.names=FALSE)
write.xlsx(thalamus, file=paste(mypath,"/analyses/3.ES PET thalamus.xlsx",sep=""), sheetName="thalamus", row.names=FALSE)
write.xlsx(hypothalamus, file=paste(mypath,"/analyses/3.ES PET hypothalamus.xlsx",sep=""), sheetName="hypothalamus", row.names=FALSE)
write.xlsx(lc, file=paste(mypath,"/analyses/3.ES PET lc.xlsx",sep=""), sheetName="lc", row.names=FALSE)
write.xlsx(medianraphe, file=paste(mypath,"/analyses/3.ES PET medianaraphe.xlsx",sep=""), sheetName="median raphe", row.names=FALSE)
write.xlsx(nucleusruber, file=paste(mypath,"/analyses/3.ES PET nucleusruber.xlsx",sep=""), sheetName="nucleus ruber", row.names=FALSE)
