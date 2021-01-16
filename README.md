# N-Grams_Functions
Easy to use functions that take any column of text data in R and generate nice unigram and bigram plots. 

This project creates two functions: unigram() and bigram() which processes text using NLP and generates unigram and bigram plots. 

Functions: 
unigram(text_input, plot=TRUE, occurence_filter, amount_to_graph) 
bigram(text_input, plot=TRUE, occurence_filter, amount_to_graph) 

Arguments: 
text_input: A column of text. This text does not need to be pre-processed. 

plot: Should be true or false. If true it will display an n-gram plot if false it will display a table with the n-grams and their count. Default is true. 

occurence_filter: Numeric. This condition allows you to filter out n-grams that appear less than this amount. Default is 8. 

amount_to_graph: Numeric. This allows you to select how many n-grams will appear on the graph. Default is 15.

Necessary Packages: 
library(dplyr) 
library(ggplot2)
library(tidytext)
library(tm)

 Built with tidytext_0.3.0    dplyr_1.0.2     ggplot2_3.3.3     tm_0.7-8          NLP_0.2-1    
