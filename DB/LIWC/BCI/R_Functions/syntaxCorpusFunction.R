#-------------------------------------------------------------------------#
# FUNCTION: SyntaxCorpus
# AUTHOR: KATE GREY
#-------------------------------------------------------------------------#
#' syntaxCorpus function
#' Step 2 of syntaxLCM
#' syntaxCorpus creates a clean corpus from the document term matrix where each column is frequency count
#' for each of the syntax and dependency tree features present in the text.

#' @export
  syntaxCorpus <- function(datacolumn){
    library(tm)
    library(stringi)
    abstract.corpus <- Corpus(VectorSource(datacolumn))
    abstract.corpus.clean <- abstract.corpus %>%
      tm_map(removePunctuation) %>%
      tm_map(stripWhitespace)
    abstract.dtm <- DocumentTermMatrix(abstract.corpus.clean,
                                       control = list(wordLengths = c(1, Inf)))
    abstract.matrix <- as.matrix(abstract.dtm)
    syntax.dtm <<- as.data.frame(abstract.matrix)
  }

