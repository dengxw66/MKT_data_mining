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
syntaxLCM <- function(datacol){
  syntaxLCM.output <- as.data.frame(matrix(NA, ncol = 5, nrow = length(datacol)))
  colnames(syntaxLCM.output) <- c("absadjcount", "absverbcount", "concount", "totalcount", "syntaxLCM")
  abstractadjlex <- c("amod", "compound", "cop", "expl", "jj", "nmodnpmod") # Abstract adjective features
  abstractverblex <- c("vbz", "vbn", "mark", "xcomp", "auxpass") # Abstract verb features
  concretelex <- c( "appos","advcl","case","conj","csubj","discourse","mwe", "nnps","nsubj","nummod", "vbg") #concrete features
  for (r in 1:length(datacol)){
    print(r)
    words <- strsplit(datacol[r], " ")
    syntaxLCM.output$absadjcount[r] <- sum(stri_detect_fixed(words, abstractadjlex))
    syntaxLCM.output$absverbcount[r] <- sum(stri_detect_fixed(words, abstractverblex))
    syntaxLCM.output$concount[r] <- sum(stri_detect_fixed(words, concretelex))
    syntaxLCM.output$totalcount[r] <- sum(syntaxLCM.output$absadjcount[r], syntaxLCM.output$absverbcount[r], syntaxLCM.output$concount[r])
  }
  syntaxLCM.output$syntaxLCM <- ((syntaxLCM.output$absadjcount*4) + (syntaxLCM.output$absverbcount*2) + (syntaxLCM.output$concount)) / (syntaxLCM.output$totalcount)
  syntaxLCM.output <<- syntaxLCM.output
}



syntaxLCM2 <- function(datacol, liwc.dictionary){
  syntaxLCM.output <- as.data.frame(matrix(NA, ncol = 8, nrow = length(datacol)))
  colnames(syntaxLCM.output) <- c("absadjcount", "absverbcount", "concount", "totalcount", "syntaxLCM", "DAV2","SV2", "IAV2")
  abstractadjlex <- c("amod", "compound", "cop", "expl", "jj", "nmodnpmod") # Abstract adjective features
  abstractverblex <- c("vbz", "vbn", "mark", "xcomp", "auxpass") # Abstract verb features
  concretelex <- c( "appos","advcl","case","conj","csubj","discourse","mwe", "nnps","nsubj","nummod", "vbg") #concrete features
  liwcscore <- dfm(datacol, dictionary = liwc.dictionary)
  liwcdf <- as.data.frame(liwcscore)
  colnames(liwcdf) <- c("DAV2", "IAV2", "SV2")
  syntaxLCM.output$DAV2 <- liwcdf$DAV2
  syntaxLCM.output$IAV2 <- liwcdf$IAV2
  syntaxLCM.output$SV2 <- liwcdf$SV2
  iavcol <- liwcdf$IAV2
  davcol <- liwcdf$DAV2
  svcol <- liwcdf$SV2
  for (r in 1:length(datacol)){
    print(r)
    words <- strsplit(datacol[r], " ")
    syntaxLCM.output$absadjcount[r] <- sum(stri_detect_fixed(words, abstractadjlex), na.rm = TRUE)
    syntaxLCM.output$absverbcount[r] <- ((sum(stri_detect_fixed(words, abstractverblex))) + iavcol[r])
    syntaxLCM.output$concount[r] <- (sum(stri_detect_fixed(words, concretelex)) + davcol[r])
    syntaxLCM.output$totalcount[r] <- sum(syntaxLCM.output$absadjcount[r], syntaxLCM.output$absverbcount[r], syntaxLCM.output$concount[r], svcol[r], davcol[r], iavcol[r], na.rm = TRUE)
  }
  syntaxLCM.output$syntaxLCM <- ((syntaxLCM.output$absadjcount*4) + (svcol*3) + (syntaxLCM.output$absverbcount*2) + (syntaxLCM.output$concount)) / (syntaxLCM.output$totalcount)
  syntaxLCM.output <<- syntaxLCM.output
}
