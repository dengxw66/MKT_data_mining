#-------------------------------------------------------------------------#
# FUNCTION: ParseCorpus
# AUTHOR: KATE GREY
#-------------------------------------------------------------------------#
#' Step 1 of syntaxLCM
#' AnnotatedCorpus annotates your text to provide you with part of speech tags and dependency tree features.
#' Inputs: datacolumn (the data$column your text is in) and data (the name of your dataset)
#' Outputs: a data frame called "syntaxfeatures_output" that has 4 columns: one for the text analyzed,
#' one for POS tags, one for dependency features, and one for all generated features



#' @export
ParsedCorpus <- function(datacolumn, data){
  syntaxfeatures <- as.data.frame(matrix(NA,
                                      ncol = 4,
                                      nrow = nrow(data)))
  colnames(syntaxfeatures) <- c("text", "POStags", "dependencies", "allfeatures")
  syntaxfeatures$text <- datacolumn
  syntaxfeatures$POStags<- as.character(syntaxfeatures$POStags)
  syntaxfeatures$dependencies<- as.character(syntaxfeatures$dependencies)
  syntaxfeatures$allfeatures<- as.character(syntaxfeatures$allfeatures)
  datacolumn<- as.character(datacolumn)
  for (i in 1:length(datacolumn)){
    if (i %% 100 == 0){
      print(paste0(i," done"))
    }
    string <- datacolumn[i]
    output <- annotateString(string)
    token <- getToken(output)
    tokens <- paste(token$POS,
                    sep = " ")
    depend <- getDependency(output,
                            type = "basic")
    depends <- paste(depend$type,
                     sep = " ")
    dependlist <- paste(depend$type,
                        collapse = " ")
    poslist <- paste(token$POS,
                    collapse = " ")
    syntaxfeatures$POStags[i] <- poslist
    syntaxfeatures$dependencies[i] <- dependlist
    syntaxfeatures$allfeatures[i] <- paste(syntaxfeatures$POStags[i], syntaxfeatures$dependencies[i],
                                          collapse = " ")
  }
  syntaxfeatures.output <<- syntaxfeatures
}


