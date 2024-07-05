#-------------------------------------------------------------------------#
# EXAMPLE SCRIPT FOR ANALYZING DATA USING BRYSBAERT AND SYNTAX LCM
# AUTHOR: KATE GREY
#-------------------------------------------------------------------------#

#PREWORK (Only do the first time): Java and CoreNLP
install.packages('rJava')

# You will need to install the java runtime environment for your machine (available here: http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html)
# Once installed, you will have to point your RStudio to that folder. To do this on Windows computers, find where its saved and enter
# the following command IN R STUDIO (replacing java folder name with your folder name:
options(java.home = "C:\\Program Files\\Java\\jre1.8.0_151")
install.packages('coreNLP')
library(rJava)
library(coreNLP)
downloadCoreNLP()

# Source in Functions: Navigate to "FUNCTIONS" folder in RStudio.
# Go to menu at top of page and set working directory to files pane location.
source("LoadSyntaxFunctionsFunction.R")
LoadSyntaxFunctions()

#-------------------------------------------------------------------------#
# READ IN DATA
#-------------------------------------------------------------------------#

df <- read.csv(file = "YOURFILENAME.csv",
                    stringsAsFactors = FALSE,
                    header = TRUE)
colnames(df)

#-------------------------------------------------------------------------#
# BRYSBAERT FUNCTION ANALYSES
# NOTE: DOES NOT HANDLE BIGRAMS IN BRYSBAERT DATASET
#-------------------------------------------------------------------------#
# load in the Brysbaert concreteness scores text file available here: http://crr.ugent.be/archives/1330.
brysbaert <- read.table(file = 'brysbaert.txt',
                        sep = '\t',
                        header = TRUE)

keep.words(df$TEXT, brysbaert$Word) # Change text to the name of the column that contains your text data to be analyzed

brysbaert.calculator(keepwords.output$newtext, brysbaert$Word)

df = cbind(df, brys.output)
head(df)
remove(brys.output)
remove(keepwords.output)

#-------------------------------------------------------------------------#
# SYNTAX LCM FUNCTIONS
#-------------------------------------------------------------------------#
library(quanteda)
initCoreNLP() #Only need to run once each time you launch R
LCMdict <- dictionary(file = "LCM.dic", format = "LIWC") # read in the verb dictionaries
ParsedCorpus(df$TEXT, df) # Change TEXT to name of text column
df <- cbind(df, syntaxfeatures.output)

syntaxCorpus(df$allfeatures)
syntaxLCM(syntaxcol = df$allfeatures, df$TEXT, dict = LCMdict )  # Change TEXT to name of text column
df <- cbind(df, syntaxLCM.output, syntax.dtm)


