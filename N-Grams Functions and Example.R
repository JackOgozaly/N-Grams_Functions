#Code to create functions that create unigrams and bigrams given a column of text
#built on R version 4.0.3 (2020-10-10)

#Libraries needed for these functions
.libPaths("C:/Program Files/R/R-4.0.3/library")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidytext")
install.packages("tm")
install.packages("NLP")
library(dplyr) #Used for data manipulation/filtering
library(ggplot2) #Used for plotting n-grams output
library(tidytext)#Used for tokenization
library(tm) #Used for removing numbers and stopwords 
library(stringr)
install.packages("stringr")
install.packages("tm")
#[1] tidytext_0.3.0    dplyr_1.0.2     ggplot2_3.3.3     tm_0.7-8          NLP_0.2-1    


#Our first function, unigram, plots unigrams with numbers, and stopwords removed
unigram <- function(text_input, # should be a columm from a dataframe
                    plot = TRUE, # return a plot? TRUE by defult
                    occurence_filter=8,#unigram must occur this many times
                    amount_to_graph=15) # number of topics (8 by default)
{    
  # creates a temporary dataframe with a duplicate column of text
  column_one <- text_input
  column_one <- removeNumbers(column_one)
  column_one <- as.data.frame(column_one)
  colnames(column_one) <- c("column_one")
  text_df1 <- mutate(column_one, text= column_one)
  #Creates object unigram which has the unigrams and stopwords removed 
  unigram <- text_df1 %>% 
    mutate(line= row_number()) %>%
    unnest_tokens(word, text) %>% 
    anti_join(stop_words) %>% 
    count(word, sort = TRUE)%>%
    filter(n> occurence_filter) %>%
    mutate(word= reorder(word, n))
  #Now we have the code to plot the graph
  if(plot == TRUE){
    #Select the 15 most common unigrams
    unigram_plot <- unigram[0:amount_to_graph,]
    ggplot(data=unigram_plot, aes(word, n)) + geom_col(fill= "#5886a5") +
      coord_flip()+ xlab("Unigram\n") + ylab("\nFrequency") + 
      ggtitle("Unigram Plot") +  
      theme(plot.title = element_text(hjust = 0.5), text = element_text(size=20))
  }else{ 
    # if the user does not request a plot
    return(View(unigram))
  }
}

bigram <- function(text_input, # should be a column from a dataframe
                   plot = TRUE, # return a plot? TRUE by default
                   occurence_filter=8, #If a bigram occurs less than this 
                   #amount of times it is excluded
                   amount_to_graph=15) # number of bigrams to plot (15 by default)
{    
  # Removes stopwords, punctuation, and numbers from our dataframe 
  filtered_text <- text_input
  filtered_text <- removeNumbers(filtered_text)
  filtered_text <- removePunctuation(filtered_text)
  filtered_text <- removeWords(filtered_text, stop_words$word)
  #Creates a dataframe which our bigrams will be made on
  text_df1 <- as.data.frame(filtered_text)
  colnames(text_df1) <- c("column_one")
  text_df1 <- mutate(text_df1, text= column_one)
  #Creates object bigram with our bigrams and their count 
  bigram <- text_df1 %>%
    mutate(line= row_number()) %>%
    unnest_tokens(bigram, `text`, token = "ngrams", n = 2) %>%
    count(bigram, sort = TRUE)%>%
    filter(n>occurence_filter) %>%
    mutate(bigram= reorder(bigram, n))
  bigram <- na.omit(bigram)
  if(plot == TRUE){
    #Select the n most common bigrams (15 by default)
    bigram_plot <- bigram[0:amount_to_graph,]
    #Plots the 15 most common bigrams
    ggplot(data=bigram_plot, aes(bigram, n)) + geom_col(fill= "#5886a5") + 
      coord_flip()+ xlab("Bigram\n") + ylab("Frequency") + 
      ggtitle("Bigram Plot") + 
      theme(plot.title = element_text(hjust = 0.5), text = element_text(size=20))
  }else{ 
    # if the user does not request a plot
    return(View(bigram))
  }
}  


#Below is an example of how these functions can be easily used
library(janeaustenr) #loads in a library of Jane Auesten's work 
library(stringr) #Used to extract text for our example 

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(), chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",ignore_case = TRUE)))) %>%
  ungroup()
#Now we have a dataframe with a text field. Let's input the text field into our functions 
unigram(original_books$text)
bigram(original_books$text)

