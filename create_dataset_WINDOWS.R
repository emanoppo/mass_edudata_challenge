####################################################################################################
# Mass EduData Challenge, 2014 (WINDOWS VERSION)
####################################################################################################

# Purpose: to explore Massachusetts data related to girls' achievement in STEM subjects.

# Population of interest: female students in Massachusetts middle and high schools, school year 2011-2012.

# What does this script file do?
# This syntax file downloads school-level datasets from the Massachusetts Department of Elementary and
#    Secondary Education (DESE) and the National Center for Education Statistics (NCES), and merges these
#    datasets to prepare a single dataset for analysis/data visualization.

# What are the inputs?
# This file downloads the following datasets from the Massachusetts DESE: (1) AP Exam Performance, and
#    (2) MCAS performance, and the following file from the National Center for Education Statistics:
#    2012 Common Core of Data: Public Elementary/Secondary School Universe Survey Data (more information:
#    http://nces.ed.gov/ccd/pubschuniv.asp)

# What is the output?
# A csv file called "MassGirlsSTEM2012.csv"

# Instructions:
# 1.) Specify folder location to store data files (line 30).
# 2.) Run entire script. MassGirlsInSTEM2012.csv will be in the folder specified.

####################################################################################################

# SPECIFY WORKING DIRECTORY HERE.
mainDirectory <- "ENTER FILE DIRECTORY HERE"
setwd(mainDirectory)

# Check to see if subfolder "downloaded files" exists -- if not, create new folder. Move to subfolder.
if (file.exists("downloaded files")) {
  setwd(paste(getwd(),"/downloaded files",sep=""))
} else {
  dir.create("downloaded files")
  setwd(paste(getwd(),"/downloaded files",sep=""))
}

####################################################################################################
# Download required files, pull into R.
####################################################################################################

# Massachusetts DESE Files:

# 2012 AP Exam Performance.
if (file.exists("MassDESEAPPerf0713")) {
} else {
  MassDESEAPPerf0713Url <- "https://raw.githubusercontent.com/hackreduce/MassEduDataChallenge/master/assessment/ap_performance_state_district_school_2007_2013.csv"
  download.file(MassDESEAPPerf0713Url, destfile = "MassDESEAPPerf0713.csv")
}
MassDESEAPPerf0713 <- read.csv("MassDESEAPPerf0713.csv", header = TRUE, sep = "\t")

# 2012 MCAS Performance
if (file.exists("MassDESEMCASPerf2012")) {
} else {
  MassDESEMCASPerf2012Url <- "https://raw.githubusercontent.com/hackreduce/MassEduDataChallenge/master/mcas/2012performance_growth_school.csv"
  download.file(MassDESEMCASPerf2012Url, destfile = "MassDESEMCASPerf2012.csv")
}
MassDESEMCASPerf2012 <- read.csv("MassDESEMCASPerf2012.csv", header = TRUE, sep = ",")

# National Center for Education Statistics File:
temp <- tempfile()
download.file("http://nces.ed.gov/ccd/Data/zip/sc111a_supp_txt.zip",temp)
NCES2012 <- read.csv(unz(temp, "sc111a_supp.txt"), header = TRUE, sep = "\t")
unlink(temp)

####################################################################################################
# Prep datasets for merge.
####################################################################################################

# Prep NCES dataset for merge: select only Massachusetts high schools (no middle schools exist that go beyond
#    9th grade).
NCES2012Mass <- subset(NCES2012, FIPST == 25 & LEVEL == 3, SURVYEAR:LONCOD)
NCES2012Mass$SEASCH <- as.numeric(as.character(NCES2012Mass$SEASCH))

# Prep AP Performance datasets for merge.

#    Calculus AB.
#    All Students
APCalcABAll <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "ALL" & AP_SUBJ_CODE == "CALCAB" & !is.na(SCHOOL))
APCalcABAll <- APCalcABAll[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APCalcABAll) <- c("SCHOOL","AP_TESTS_TAKEN.CalcAB.All","AP_PCT_3_5.CalcAB.All")
#    Female Students
APCalcABF <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "F" & AP_SUBJ_CODE == "CALCAB" & !is.na(SCHOOL))
APCalcABF <- APCalcABF[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APCalcABF) <- c("SCHOOL","AP_TESTS_TAKEN.CalcAB.F","AP_PCT_3_5.CalcAB.F")

#    Computer science.
#    All Students
APCompSciAAll <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "ALL" & AP_SUBJ_CODE == "COMSCA" & !is.na(SCHOOL))
APCompSciAAll <- APCompSciAAll[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APCompSciAAll) <- c("SCHOOL","AP_TESTS_TAKEN.CompSciA.All","AP_PCT_3_5.CompSciA.All")
#    Female Students
APCompSciAF <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "F" & AP_SUBJ_CODE == "COMSCA" & !is.na(SCHOOL))
APCompSciAF <- APCompSciAF[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APCompSciAF) <- c("SCHOOL","AP_TESTS_TAKEN.CompSciA.F","AP_PCT_3_5.CompSciA.F")

#    Biology.
#    All Students
APBioAll <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "ALL" & AP_SUBJ_CODE == "BIOL" & !is.na(SCHOOL))
APBioAll <- APBioAll[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APBioAll) <- c("SCHOOL","AP_TESTS_TAKEN.Bio.All","AP_PCT_3_5.Bio.All")
#    Female Students
APBioF <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "F" & AP_SUBJ_CODE == "BIOL" & !is.na(SCHOOL))
APBioF <- APBioF[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APBioF) <- c("SCHOOL","AP_TESTS_TAKEN.Bio.F","AP_PCT_3_5.Bio.F")

#    Chemistry.
#    All Students
APChemAll <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "ALL" & AP_SUBJ_CODE == "CHEM" & !is.na(SCHOOL))
APChemAll <- APChemAll[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APChemAll) <- c("SCHOOL","AP_TESTS_TAKEN.Chem.All","AP_PCT_3_5.Chem.All")
#    Female Students
APChemF <- subset(MassDESEAPPerf0713, REC_YEAR == 2012 & AP_STU_GROUP_CODE == "F" & AP_SUBJ_CODE == "CHEM" & !is.na(SCHOOL))
APChemF <- APChemF[,c("SCHOOL","AP_TESTS_TAKEN","AP_PCT_3_5")]
colnames(APChemF) <- c("SCHOOL","AP_TESTS_TAKEN.Chem.F","AP_PCT_3_5.Chem.F")

# Prep AP Performance datasets for merge.

#    All 10th Grade Students
MCASAll10thGrd <- subset(MassDESEMCASPerf2012, Grade == "10" & Group == "All Students")
MCASAll10thGrd <- MCASAll10thGrd[,c("Org_code","mpro_num","madv_num","mtotal","spro_num","sadv_num","stotal")]
colnames(MCASAll10thGrd) <- c("Org_code","mpro_num.All","madv_num.All","mtotal.All","spro_num.All",
                              "sadv_num.All","stotal.All")
MCASAll10thGrd$mathPercProAdv.All <- round((MCASAll10thGrd$mpro_num.All + MCASAll10thGrd$madv_num.All) / 
                                             MCASAll10thGrd$mtotal.All * 100, 1)
MCASAll10thGrd$STEPercProAdv.All <- round((MCASAll10thGrd$spro_num.All + MCASAll10thGrd$sadv_num.All) / 
                                            MCASAll10thGrd$stotal.All * 100, 1)
#    Female Students
MCASF10thGrd <- subset(MassDESEMCASPerf2012, Grade == "10" & Group == "Female")
MCASF10thGrd <- MCASF10thGrd[,c("Org_code","mpro_num","madv_num","mtotal","spro_num","sadv_num","stotal")]
colnames(MCASF10thGrd) <- c("Org_code","mpro_num.F","madv_num.F","mtotal.F","spro_num.F", "sadv_num.F","stotal.F")
MCASF10thGrd$mathPercProAdv.F <- round((MCASF10thGrd$mpro_num.F + MCASF10thGrd$madv_num.F) / 
                                         MCASF10thGrd$mtotal.F * 100, 1)
MCASF10thGrd$STEPercProAdv.F <- round((MCASF10thGrd$spro_num.F + MCASF10thGrd$sadv_num.F) / 
                                        MCASF10thGrd$stotal.F * 100, 1)

####################################################################################################
# Merge datasets.
####################################################################################################

mergedDataset <- merge(NCES2012Mass, APCalcABAll, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, APCalcABF, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, APCompSciAAll, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, APCompSciAF, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, APBioAll, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, APBioF, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, APChemAll, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, APChemF, by.x="SEASCH", by.y="SCHOOL", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, MCASAll10thGrd, by.x = "SEASCH", by.y = "Org_code", all.x = TRUE, all.y = FALSE)
mergedDataset <- merge(mergedDataset, MCASF10thGrd, by.x = "SEASCH", by.y = "Org_code", all.x = TRUE, all.y = FALSE)

####################################################################################################
# Save merged dataset.
####################################################################################################

setwd("../")
write.csv(mergedDataset, file="MassGirlsSTEM2012.csv")

####################################################################################################
# END OF FILE.
####################################################################################################