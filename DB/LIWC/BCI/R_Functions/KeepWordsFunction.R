#-------------------------------------------------------------------------#
# FUNCTION: keep.words
# AUTHOR: KATE GREY
#-------------------------------------------------------------------------#
##KEEP WORDS FUNCTION:
##Opposite of stop words. Filters out all words except those in a pre-defined list

keep.words <- function(text, keep) {
  require(tm)
  text <- as.character(text)
  text <- iconv(text, 'UTF-8', 'ASCII')
  text[sapply(text, is.character)] <- lapply(text[sapply(text, is.character)], tolower) 
  text <- as.character(text)
  text<-removePunctuation(text)
  keepwords.output <- as.data.frame(matrix(NA,
                                           ncol = 1,
                                           nrow = length(text)))
  colnames(keepwords.output) <- c("newtext")
  for (i in 1:length(text)){
    if (i %% 100 == 0){
      print(paste0(i," done"))
    }
    words <- strsplit(text[i], " ")[[1]]
    keepwords.output$newtext[i] <- paste(words[words %in% keep],
                                         collapse = " ")
  }
  keepwords.output <<- keepwords.output
}
