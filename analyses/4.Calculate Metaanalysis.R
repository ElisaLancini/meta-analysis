# CALCULATE RANDOM EFFECT MODEL 
# Elisa Lancini (elisa.lancini@dzne.de)

#  Change path  ----------------------
mypath="/Users/elisalancini/Dropbox/PhD/SynAge/review"

# Load libraries ----------------------
library(dmetar)
library(meta)
library(metafor)
library(grid)
library(readxl)
library(magrittr)
library(dplyr)
library(readxl)
library(openxlsx)
library(writexl)

# CSF data ----------------------
# path
setwd(paste(mypath,"/analyses",sep=""))

# load anche change name for each loop
for(i in 1:4) {
  if (i == 1) {
    dataname<-"NA_AD"
    data <- read_excel(paste(mypath,"/analyses/3.ES NA_AD.xlsx",sep=""), sheet = dataname)
    toexclude<-as.numeric(c(3,7))
    
  } else if (i == 2) {
    rm(data)
    rm(dataname)
    dataname<-"NA_PD"
    data <- read_excel(paste(mypath,"/analyses/3.ES NA_PD.xlsx",sep=""), sheet = dataname)
    toexclude<-as.numeric(c(1,6))
    
    
  } else if (i == 3){
    rm(data)
    rm(dataname)
    dataname<-"MHPG_AD"
    data <- read_excel(paste(mypath,"/analyses/3.ES MHPG_AD.xlsx",sep=""), sheet = dataname)
    toexclude<-as.numeric(c(13,9,6))
    
  } else if (i == 4) {
    rm(data)
    rm(dataname)
    dataname<-"MHPG_PD"
    data <- read_excel(paste(mypath,"/analyses/3.ES MHPG_PD.xlsx",sep=""), sheet = dataname)
    toexclude<-as.numeric(c(8))
    
  }
  
  # define as numeric , to avoid errors 
  data$se<-as.numeric(data$se)
  
  # open pdf to save results
  pdfname<-gsub(" ", "", paste("4." , dataname,".pdf"))
  pdf(pdfname)
  
  # calculate effect size from already calculated data
  metadata <- metagen(g,
                      se,
                      data = data,
                      studlab = paste(Author),
                      comb.fixed = FALSE,
                      comb.random = TRUE,
                      method.tau = "SJ",
                      hakn = TRUE,
                      prediction = TRUE,
                      sm = "SMD")
  metadata
  
  # save in variable
  metares<-setNames(data.frame(matrix(ncol = 17, nrow = 3)), c("k","SMD", "se", "low", "high", "t", "pval" , "I2","lowI2","highI2","pvalI2","out","out1","out2","out3","out4","out5"))
  metares[1,1]<-metadata[["k"]]
  metares[1,2]<-metadata[["TE.random"]]
  metares[1,3]<-metadata[["seTE.random"]]
  metares[1,4]<-metadata[["lower.random"]]
  metares[1,5]<-metadata[["upper.random"]]
  metares[1,6]<-metadata[["zval.random"]]
  metares[1,7]<-metadata[["pval.random"]]
  metares[1,8]<-metadata[["I2"]]
  metares[1,9]<-metadata[["lower.I2"]]
  metares[1,10]<-metadata[["upper.I2"]]  
  metares[1,11]<-metadata[["pval.Q"]]
  
  
  # 6.2 detect outliers (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/detecting-outliers-influential-cases.html)
  library(dmetar)
  find.outliers(metadata) # put an asterisk on outlier studies
  fo <- find.outliers(metadata)
  metadata_cleaned1<-forest(fo, col.predict = "blue") # # re-run excluding those studies
  metadata_cleaned1
  
  
  # save in variable
  metares[2,1]<-lapply(fo$m.random$k, '[[', 1)
  metares[2,2]<-lapply(fo$m.random$TE.random, '[[', 1)
  metares[2,3]<-lapply(fo$m.random$seTE.random, '[[', 1)
  metares[2,4]<-lapply(fo$m.random$lower.random, '[[', 1)
  metares[2,5]<-lapply(fo$m.random$upper.random, '[[', 1)
  metares[2,6]<-lapply(fo$m.random$zval.random, '[[', 1)
  metares[2,7]<-lapply(fo$m.random$pval.random, '[[', 1)
  metares[2,8]<-lapply(fo$m.random$I2, '[[', 1)
  metares[2,9]<-lapply(fo$m.random$lower.I2, '[[', 1)
  metares[2,10]<-lapply(fo$m.random$upper.I2, '[[', 1)
  metares[2,11]<-lapply(fo$m.random$pval.Q, '[[', 1)
  tryCatch({
    metares[2,12]<-lapply(fo$out.study.random, '[[', 1)
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  
  
  # 6.3 Influence analysis (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/influenceanalyses.html)
  library(dmetar) # Not only outliers can influence, here we check if some studies exert an high influence on the overall analysis (precision)
  inf.analysis <- InfluenceAnalysis(x = metadata,
                                    random = TRUE)
  summary(inf.analysis)
  
  plot(inf.analysis, "influence")
  plot(inf.analysis, "baujat")
  plot(inf.analysis, "es")
  plot(inf.analysis, "i2")
  
  # 6.4 GOSH Plot analysis (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/gosh-plot-analysis.html)
  library(metafor) #Is there more than one “population” of effect sizes in our data?
  m.rma <- rma(yi = metadata$TE, 
               sei = metadata$seTE,
               method = metadata$method.tau,
               test = "knha")
  dat.gosh <- gosh(m.rma) 
  plot(dat.gosh, alpha= 0.1, col = "blue") ##  If the effect sizes in our sample are homogeneous, the GOSH plot should form a symmetric distribution with one peak.
  
  library(dmetar) #if there are subclusters, which studies cause those patterns, and may thus belong to which subcluster? 
  goshresults<-gosh.diagnostics(dat.gosh) 

  # re-run excluding those studies: !!!!!!!!!!!!!!!! CHANGEEEEEEE DEPENDING ON THE GOSH RESULTS !!!!!!!!!!!!
  metadata_cleaned2<-metagen(g,
                             se,
                             data=data,
                             studlab=paste(Author),
                             comb.fixed = FALSE,
                             comb.random = TRUE,
                             method.tau = "SJ",
                             hakn = TRUE,
                             prediction=TRUE,
                             sm="SMD",
                             exclude = toexclude) # put here studies to be excluded
  metadata_cleaned2
  
  # save in variable
  metares[3,1]<-metadata_cleaned2[["k"]]
  metares[3,2]<-metadata_cleaned2[["TE.random"]]
  metares[3,3]<-metadata_cleaned2[["seTE.random"]]
  metares[3,4]<-metadata_cleaned2[["lower.random"]]
  metares[3,5]<-metadata_cleaned2[["upper.random"]]
  metares[3,6]<-metadata_cleaned2[["zval.random"]]
  metares[3,7]<-metadata_cleaned2[["pval.random"]]
  metares[3,8]<-metadata_cleaned2[["I2"]]
  metares[3,9]<-metadata_cleaned2[["lower.I2"]]
  metares[3,10]<-metadata_cleaned2[["upper.I2"]]  
  metares[3,11]<-metadata_cleaned2[["pval.Q"]]
  tryCatch({
    whichrow<-as.data.frame(toexclude)
    row1<-whichrow[1,1]
    row2<-whichrow[2,1]
    row3<-whichrow[3,1]
    row4<-whichrow[4,1]
    row5<-whichrow[5,1]
    row6<-whichrow[6,1]
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  tryCatch({
    metares[3,12]<-data[row1,1]
    metares[3,13]<-data[row2,1]
    metares[3,14]<-data[row3,1]
    metares[3,15]<-data[row4,1]
    metares[3,16]<-data[row5,1]
    metares[3,17]<-data[row6,1]
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  
  # 9) Publication bias (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/smallstudyeffects.html)
  # 9.1) Funnel plots: Are small studies with small effect sizes missing?
  tryCatch({
    funnel(metadata,xlab = "Hedges' g") # If no publication bias, all studies would lie symmetrically around our pooled effect size (the striped line) within the form of the funnel.
    funnel(metadata,xlab = "g",studlab = TRUE) # same but with study names
    # contour-enhanced funnel plots, which help to distinguish publication bias from other forms of asymmetry (drives by p values..)
    funnel(metadata, xlab="Hedges' g", 
           contour = c(.95,.975,.99),
           col.contour=c("darkblue","blue","lightblue"))+
      legend(1.4, 0, c("p < 0.05", "p<0.025", "< 0.01"),bty = "n",
             fill=c("darkblue","blue","lightblue"))
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  #Egger’s test (only for more than 10 studies)
  library(dmetar)
  tryCatch({
    egger_test=eggers.test(x = metadata)
    if (egger_test$p < 0.05) {
      # If Egger's test is significant, Duval & Tweedie’s trim-and-fill procedure to estimate what the actaul effect size would be had the “missing” small studies been published
      trimfill(metadata)
      metadata$TE.random #compare with initial "g"
      metadata.trimfill<-trimfill(metadata)
      funnel(metadata.trimfill,xlab = "Hedges' g") # funnel plots including the imputed studies.
    } 
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  # 9.2) P-curve Analysis:  an alternative way to assess publication bias and estimate the true effect behind our collected data.
  library(dmetar)
  tryCatch(
    {
    pcurve(metadata) # on raw data
    pcurve(metadata_cleaned2)}, 
  error=function(err){cat("ERROR :",conditionMessage(err), "\n")
    })
  # close pdf to save results and save results
  dev.off()
  resname<-paste("A", i, sep = "")
  assign(resname, metares)
  # close loop
}

tryCatch(estimatemodel(dataset), error = function() next)

# outside loop merge results and save
mergedresults<-bind_rows(A1,A2,A3,A4)
addthis<-c("NA_ADraw","NA_ADout","NA_ADgosh","NA_PDraw","NA_PDout","NA_PDgosh","MHPG_ADraw","MHPG_ADout","MHPG_ADgosh","MHPG_PDraw","MHPG_PDout","MHPG_PDgosh")
dim(addthis) <- c(length(addthis), 1)
mergedresults<-bind_cols(addthis,mergedresults)

write.xlsx(mergedresults, file=paste(mypath,"/analyses/4.CSF Metanalysis_results.xlsx",sep=""), row.names=FALSE)

# PET data ----------------------
# path
setwd(paste(mypath,"/analyses",sep=""))
# load anche change name for each loop
for(i in 1:5) {
  if (i == 1) {
    dataname<-"hypothalamus"
    data <- read_excel(paste(mypath,"/analyses/3.ES PET hypothalamus.xlsx",sep=""))
  } else if (i == 2) {
    rm(data)
    rm(dataname)
    dataname<-"lc"
    data <- read_excel(paste(mypath,"/analyses/3.ES PET lc.xlsx",sep=""))
    
  } else if (i == 3){
    rm(data)
    rm(dataname)
    dataname<-"medianaraphe"
    data <- read_excel(paste(mypath,"/analyses/3.ES PET medianaraphe.xlsx",sep=""))
    
  } else if (i == 4) {
    rm(data)
    rm(dataname)
    dataname<-"nucleusruber"
    data <- read_excel(paste(mypath,"/analyses/3.ES PET nucleusruber.xlsx",sep=""))
    
  } else if (i == 5) {
    rm(data)
    rm(dataname)
    dataname<-"thalamus"
    data <- read_excel(paste(mypath,"/analyses/3.ES PET thalamus.xlsx",sep=""))
    
  }
  
  # define as numeric , to avoid errors 
  data$se<-as.numeric(data$se)
  
  # open pdf to save results
  pdfname<-gsub(" ", "", paste("4." , dataname,".pdf"))
  pdf(pdfname)
  
  # calculate effect size from already calculated data
  metadata <- metagen(g,
                      se,
                      data = data,
                      studlab = paste(Author),
                      comb.fixed = FALSE,
                      comb.random = TRUE,
                      method.tau = "SJ",
                      hakn = TRUE,
                      prediction = TRUE,
                      sm = "SMD")
  metadata
  
  # save in variable
  metares<-setNames(data.frame(matrix(ncol = 17, nrow = 3)), c("k","SMD", "se", "low", "high", "t", "pval" , "I2","lowI2","highI2","pvalI2","out","out1","out2","out3","out4","out5"))
  metares[1,1]<-metadata[["k"]]
  metares[1,2]<-metadata[["TE.random"]]
  metares[1,3]<-metadata[["seTE.random"]]
  metares[1,4]<-metadata[["lower.random"]]
  metares[1,5]<-metadata[["upper.random"]]
  metares[1,6]<-metadata[["zval.random"]]
  metares[1,7]<-metadata[["pval.random"]]
  metares[1,8]<-metadata[["I2"]]
  metares[1,9]<-metadata[["lower.I2"]]
  metares[1,10]<-metadata[["upper.I2"]]  
  metares[1,11]<-metadata[["pval.Q"]]
  
  
  # 6.2 detect outliers (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/detecting-outliers-influential-cases.html)
  library(dmetar)
  find.outliers(metadata) # put an asterisk on outlier studies
  fo <- find.outliers(metadata)
  metadata_cleaned1<-forest(fo, col.predict = "blue") # # re-run excluding those studies
  metadata_cleaned1
  
  
  # save in variable
  metares[2,1]<-lapply(fo$m.random$k, '[[', 1)
  metares[2,2]<-lapply(fo$m.random$TE.random, '[[', 1)
  metares[2,3]<-lapply(fo$m.random$seTE.random, '[[', 1)
  metares[2,4]<-lapply(fo$m.random$lower.random, '[[', 1)
  metares[2,5]<-lapply(fo$m.random$upper.random, '[[', 1)
  metares[2,6]<-lapply(fo$m.random$zval.random, '[[', 1)
  metares[2,7]<-lapply(fo$m.random$pval.random, '[[', 1)
  metares[2,8]<-lapply(fo$m.random$I2, '[[', 1)
  metares[2,9]<-lapply(fo$m.random$lower.I2, '[[', 1)
  metares[2,10]<-lapply(fo$m.random$upper.I2, '[[', 1)
  metares[2,11]<-lapply(fo$m.random$pval.Q, '[[', 1)
  tryCatch({
    metares[2,12]<-lapply(fo$out.study.random, '[[', 1)
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  
  tryCatch({
    # 6.3 Influence analysis (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/influenceanalyses.html)
    library(dmetar) # Not only outliers can influence, here we check if some studies exert an high influence on the overall analysis (precision)
    inf.analysis <- InfluenceAnalysis(x = metadata,
                                      random = TRUE)
    summary(inf.analysis)
    
    plot(inf.analysis, "influence")
    plot(inf.analysis, "baujat")
    plot(inf.analysis, "es")
    plot(inf.analysis, "i2")
    
    # 6.4 GOSH Plot analysis (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/gosh-plot-analysis.html)
    library(metafor) #Is there more than one “population” of effect sizes in our data?
    m.rma <- rma(yi = metadata$TE, 
                 sei = metadata$seTE,
                 method = metadata$method.tau,
                 test = "knha")
    dat.gosh <- gosh(m.rma) 
    plot(dat.gosh, alpha= 0.1, col = "blue") ##  If the effect sizes in our sample are homogeneous, the GOSH plot should form a symmetric distribution with one peak.
    
    library(dmetar) #if there are subclusters, which studies cause those patterns, and may thus belong to which subcluster? 
    goshresults<-gosh.diagnostics(dat.gosh) 
    toexclude<-as.numeric(goshresults[["outliers.dbscan"]])
    
    # re-run excluding those studies: !!!!!!!!!!!!!!!! CHANGEEEEEEE DEPENDING ON THE GOSH RESULTS !!!!!!!!!!!!
    metadata_cleaned2<-metagen(g,
                               se,
                               data=data,
                               studlab=paste(Author),
                               comb.fixed = FALSE,
                               comb.random = TRUE,
                               method.tau = "SJ",
                               hakn = TRUE,
                               prediction=TRUE,
                               sm="SMD",
                               exclude = toexclude) # put here studies to be excluded
    metadata_cleaned2
    
    # save in variable
    metares[3,1]<-metadata_cleaned2[["k"]]
    metares[3,2]<-metadata_cleaned2[["TE.random"]]
    metares[3,3]<-metadata_cleaned2[["seTE.random"]]
    metares[3,4]<-metadata_cleaned2[["lower.random"]]
    metares[3,5]<-metadata_cleaned2[["upper.random"]]
    metares[3,6]<-metadata_cleaned2[["zval.random"]]
    metares[3,7]<-metadata_cleaned2[["pval.random"]]
    metares[3,8]<-metadata_cleaned2[["I2"]]
    metares[3,9]<-metadata_cleaned2[["lower.I2"]]
    metares[3,10]<-metadata_cleaned2[["upper.I2"]]  
    metares[3,11]<-metadata_cleaned2[["pval.Q"]]
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  
  
  tryCatch({
    whichrow<-as.data.frame(toexclude)
    row1<-whichrow[1,1]
    row2<-whichrow[2,1]
    row3<-whichrow[3,1]
    row4<-whichrow[4,1]
    row5<-whichrow[5,1]
    row6<-whichrow[6,1]
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  tryCatch({
    metares[3,12]<-data[row1,1]
    metares[3,13]<-data[row2,1]
    metares[3,14]<-data[row3,1]
    metares[3,15]<-data[row4,1]
    metares[3,16]<-data[row5,1]
    metares[3,17]<-data[row6,1]
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  
  # 9) Publication bias (https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/smallstudyeffects.html)
  # 9.1) Funnel plots: Are small studies with small effect sizes missing?
  tryCatch({
    funnel(metadata,xlab = "Hedges' g") # If no publication bias, all studies would lie symmetrically around our pooled effect size (the striped line) within the form of the funnel.
    funnel(metadata,xlab = "g",studlab = TRUE) # same but with study names
    # contour-enhanced funnel plots, which help to distinguish publication bias from other forms of asymmetry (drives by p values..)
    funnel(metadata, xlab="Hedges' g", 
           contour = c(.95,.975,.99),
           col.contour=c("darkblue","blue","lightblue"))+
      legend(1.4, 0, c("p < 0.05", "p<0.025", "< 0.01"),bty = "n",
             fill=c("darkblue","blue","lightblue"))
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  #Egger’s test (only for more than 10 studies)
  library(dmetar)
  tryCatch({
    egger_test=eggers.test(x = metadata)
    if (egger_test$p < 0.05) {
      # If Egger's test is significant, Duval & Tweedie’s trim-and-fill procedure to estimate what the actaul effect size would be had the “missing” small studies been published
      trimfill(metadata)
      metadata$TE.random #compare with initial "g"
      metadata.trimfill<-trimfill(metadata)
      funnel(metadata.trimfill,xlab = "Hedges' g") # funnel plots including the imputed studies.
    } 
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  # 9.2) P-curve Analysis:  an alternative way to assess publication bias and estimate the true effect behind our collected data.
  library(dmetar)
  tryCatch({
    pcurve(metadata) # on raw data
    pcurve(metadata_cleaned2) # on clean data
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  # close pdf to save results and save results
  dev.off()
  resname<-paste("A", i, sep = "")
  assign(resname, metares)
  # close loop
  rm(toexclude)
}

# outside loop merge results and save
mergedresults<-bind_rows(A1,A2,A3,A4,A5)
addthis<-c("HypothalamusRaw","HypothalamusOut","HypothalamusGosh",
           "LcRaw","LcOut","LcGosh",
           "MedianarapheRaw","MedianarapheOut","MedianarapheGosh",
           "NucleusruberRaw","NucleusruberOut","NucleusruberGosh",
           "ThalamusRaw","ThalamusOut","ThalamusGosh")
dim(addthis) <- c(length(addthis), 1)
mergedresults<-bind_cols(addthis,mergedresults)

write.xlsx(mergedresults, file=paste(mypath,"/analyses/4.PET Metanalysis_results.xlsx",sep=""), row.names=FALSE)