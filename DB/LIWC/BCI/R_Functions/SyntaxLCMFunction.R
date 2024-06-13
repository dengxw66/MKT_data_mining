#-------------------------------------------------------------------------#
# FUNCTION: syntaxLCM
# AUTHOR: KATE GREY
#-------------------------------------------------------------------------#
#' syntaxLCM function
#' Step 3 in syntaxLCM
#' The syntaxLCM function takes the syntax features document term matrix, sums up the abstract features
#' columns and sums the concrete features columns. It then calculates a syntaxLCM score by multiplying
#' the abstract features by 2 and adding it to the concrete feature sum before dividing this sum by the
#' total number of features present in the sentence.



#' @export
syntaxLCM <- function(syntaxcol, textcol, dict){
  library(quanteda)
  library(stringi)
  liwcscore <- dfm(textcol, dictionary = dict)
  liwcdf <- convert(liwcscore, to = "data.frame")
  colnames(liwcdf) <- c("textnum","DAV2","IAV2","SV2")
  colnames(liwcdf)
  syntaxLCM.output <- as.data.frame(matrix(NA, ncol = 5, nrow = length(syntaxcol)))
  colnames(syntaxLCM.output) <- c("absadjcount", "absverbcount", "concount", "totalcount", "syntaxLCM")
  abstractadjlex <- c("amod", "compound", "cop", "expl", "JJ", "nmodnpmod") # Abstract adjective features
  abstractverblex <- c("vbz", "vbn", "mark", "xcomp", "auxpass") # Abstract verb features
  concretelex <- c( "appos","advcl","case","conj","csubj","discourse","mwe", "nnps","nsubj","nummod", "vbg") #concrete features
  for (r in 1:length(syntaxcol)){
    print(r)
    words <- strsplit(syntaxcol[r], " ")
    words <- unlist(words, use.names = FALSE)
    contained <- sapply(abstractadjlex, grepl, words)
    syntaxLCM.output$absadjcount[r] <- sum(contained[contained == "TRUE"])
    contained <- sapply(abstractverblex, grepl, words)
    syntaxLCM.output$absverbcount[r] <- sum(contained[contained == "TRUE"])
    contained <- sapply(concretelex, grepl, words)
    syntaxLCM.output$concount[r] <- sum(contained[contained == "TRUE"])
    syntaxLCM.output$totalcount[r] <- sum(syntaxLCM.output$absadjcount[r], syntaxLCM.output$absverbcount[r], syntaxLCM.output$concount[r], liwcdf$SV2[r], liwcdf$DAV2[r], liwcdf$IAV2[r], na.rm = TRUE)
    }
  syntaxLCM.output$syntaxLCM <- ((syntaxLCM.output$absadjcount*4) + (liwcdf$SV2*3) + (syntaxLCM.output$absverbcount*2) + ((liwcdf$IAV2)*2) + (syntaxLCM.output$concount) + (liwcdf$DAV2)) / (syntaxLCM.output$totalcount)
  syntaxLCM.output <<- syntaxLCM.output
}
