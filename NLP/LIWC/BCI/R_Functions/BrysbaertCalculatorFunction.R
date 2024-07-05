#-------------------------------------------------------------------------#
# FUNCTION: brysbaert.calculator
# AUTHOR: KATE GREY
#-------------------------------------------------------------------------#
# This function iterates through your text, counts the words from the Brysbaert 40,000 concreteness
# ratings weighted by their concreteness scores, and averages them.
# Make sure that the text input is the newly generated keepwords_output$newtext dataset

brysbaert.calculator <- function(text, keep){
  require(quanteda)
  text <- as.character(text)
  brys.output <- as.data.frame(matrix(NA,
                                      ncol = 3,
                                      nrow = length(text)))
  colnames(brys.output) <- c("newtext", "wc", "bryscore")
  brys.output$bryscore <- 0
  for (i in 1:length(text)){
    if (i %% 100 == 0){
    print(paste0(i," done"))
    }
    words <- strsplit(text[i], " ")[[1]]
    words <- sapply(words, tolower)
    brys.output$newtext[i] <- paste(words[words %in% keep],
                                    collapse = " ")
    words <- strsplit(brys.output$newtext[i], " ")[[1]]
    for (w in words){
      index <- which(!is.na(match(brysbaert$Word, w)))
      weight <- brysbaert$Conc.M[index]
      brys.output$bryscore[i] <- brys.output$bryscore[i] + weight
    }
  }
  bryscorpus <- corpus(brys.output$newtext)
  brysdfm <- dfm(bryscorpus)
  brys.output$wc <- rowSums(brysdfm)
  brys.output$bryscore <- brys.output$bryscore / brys.output$wc
  brys.output <<- brys.output
}
