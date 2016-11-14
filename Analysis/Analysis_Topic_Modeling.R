#Finish Cleaning Data and Begin Topic Modeling Process
library(XML)
library(tm)
library(topicmodels)
#set wd
setwd("~/Git_Repos/CaseStudy2/Data/")

#load data
washington <- read.csv('Washington_cleaned.csv')
texas <- read.csv('Texas_cleaned.csv')

#Variable Subsetting
#variables deleted were duplicates from collapsing process
texas <- texas[-2]
texas <- texas[-3]
texas <- texas[-3]
texas <- texas[-6]
texas <- texas[-6]
texas <- texas[-1]
texas <- unique(texas)
washington <- washington[-2]
washington <- washington[-3]
washington <- washington[-3]
washington <- washington[-6]
washington <- washington[-6]
washington <- washington[-1]
washington <- unique(washington)

#Defining Locations
#we used user submitted locations for expediance and because we wanted to filter out tourists
seattle <- washington[grepl('seattle', washington$user.location, ignore.case = TRUE),]
washington.other <- washington[!grepl('seattle', washington$user.location, ignore.case = TRUE) &
                             (grepl('WA', washington$user.location) |
                                grepl('washington', washington$user.location, ignore.case = TRUE)), ]

austin <- texas[grepl('austin', texas$user.location, ignore.case = TRUE),]
dallas <- texas[grepl('dallas', texas$user.location, ignore.case = TRUE),]
houston <- texas[grepl('houston', texas$user.location, ignore.case = TRUE),]
texas.other <- texas[! (grepl('austin', texas$user.location, ignore.case = TRUE) |
                          grepl('dallas', texas$user.location, ignore.case = TRUE) |
                          grepl('houston', texas$user.location, ignore.case = TRUE)) &
                       (grepl('TX', texas$user.location) |
                          grepl('texas', texas$user.location, ignore.case = TRUE)), ]


#' Topic Model Prepping
#' Insert df and this function will do the necessary prepocessing for topic modeling
#' @param df, The data we are querying (data.frame)
#' @return A data.frame with all initial values substituted by target value.
tmprep <- function(df){
  df.text <- VCorpus(DataframeSource(as.data.frame(df$author.text)))
  df.text.clean = tm_map(df.text, stripWhitespace)                          # remove extra whitespace
  df.text.clean = tm_map(df.text.clean, removeNumbers)                      # remove numbers
  df.text.clean = tm_map(df.text.clean, removePunctuation)                  # remove punctuation
  df.text.clean = tm_map(df.text.clean, content_transformer(tolower))       # ignore case
  df.text.clean = tm_map(df.text.clean, removeWords, stopwords("english"))  # remove stop words
  df.text.clean = tm_map(df.text.clean, stemDocument, lazy = TRUE)                       # stem all words
  df.text.clean.tf = DocumentTermMatrix(df.text.clean, control = list(weighting = weightTf))
  return(df.text.clean.tf)
}

#cleaning up text
seattle.text.clean.tf <- tmprep(seattle)
austin.text.clean.tf <- tmprep(austin)
dallas.text.clean.tf <- tmprep(dallas)
houston.text.clean.tf <- tmprep(houston) 
texas.other.text.clean.tf <- texas.other
washington.other.text.clean.tf <- washington.other

###############################
#Topic Modeling

# train topic model with 10 topics
#Austin
austin.topic.model = LDA(austin.text.clean.tf, 10)
terms(austin.topic.model, 10)[,1:10]
#Dallas
dallas.topic.model = LDA(dallas.text.clean.tf, 10)
terms(dallas.topic.model, 10)[,1:10]
#Houston
houston.topic.model = LDA(austin.text.clean.tf, 10)
terms(houston.topic.model, 10)[,1:10]
#Texas
row.sums = apply(texas.other.text.clean.tf, 1, sum)
texas.other.text.clean.tf = texas.other.text.clean.tf[row.sums > 0,]
texas.topic.model = LDA(texas.other.text.clean.tf, 10)
terms(texas.topic.model, 10)[,1:10]
#Seattle
seattle.topic.model = LDA(seattle.text.clean.tf, 10)
terms(seattle.topic.model, 10)[,1:10]
#Washington State
washington.topic.model = LDA(washington.other.text.clean.tf, 10)
terms(washington.topic.model, 10)[,1:10]

###############################
#Cosign Similarity

austin_text <- paste(austin$author.text, collapse = ' ')
seattle_text <- paste(seattle$author.text, collapse = ' ')
dallas_text <- paste(dallas$author.text, collapse = ' ')
houston_text <- paste(houston$author.text, collapse = ' ')
texas.other_text <- paste(texas.other$author.text, collapse = ' ')
washington.other_text <- paste(washington.other$author.text, collapse = ' ')
texas.cities_text <- paste(c(dallas_text, houston_text, austin_text), collapse = ' ')

text.df <- as.data.frame(c(seattle_text, washington.other_text, austin_text, dallas_text, houston_text, texas.cities_text, texas.other_text))


text.df = VCorpus(DataframeSource(text.df))
text.clean = tm_map(text.df, stripWhitespace)                          # remove extra whitespace
text.clean = tm_map(text.clean, removeNumbers)                      # remove numbers
text.clean = tm_map(text.clean, removePunctuation)                  # remove punctuation
text.clean = tm_map(text.clean, content_transformer(tolower))       # ignore case
text.clean = tm_map(text.clean, removeWords, stopwords("english"))  # remove stop words
text.clean = tm_map(text.clean, stemDocument)                       # stem all words

#TFIDF
text.clean.tfidf = DocumentTermMatrix(text.clean, control = list(weighting = weightTfIdf))
doc.tfidf = t(inspect(text.clean.tfidf[]))
colnames(doc.tfidf) = c('seattle', 'washington.other', 'austin', 'dallas', 'houston', 'texas.cities', 'texas.other')

cosine.similarity <- matrix(nrow=7,ncol=7)
colnames(cosine.similarity) <- colnames(doc.tfidf)
rownames(cosine.similarity) <- colnames(doc.tfidf)

#table of results
for (i in 1:7) {
  for (j in 1:7) {
    ivsj <- sum(doc.tfidf[,i]*doc.tfidf[,j])
    iss <- sum((doc.tfidf[,i])^2)
    jss <- sum((doc.tfidf[,j])^2)
    cosine.similarity[i,j] <- ivsj / sqrt(iss*jss)
  }
}
cosine.similarity
