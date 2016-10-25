washington <- read.csv('Washington_tweets.csv')
texas <- read.csv('Texas_tweets.csv')

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



library(XML)
library(tm)
library(topicmodels)

# clean and compute tfidf

seattle.text <- VCorpus(DataframeSource(as.data.frame(seattle$text)))
seattle.text.clean = tm_map(seattle.text, stripWhitespace)                          # remove extra whitespace
seattle.text.clean = tm_map(seattle.text.clean, removeNumbers)                      # remove numbers
seattle.text.clean = tm_map(seattle.text.clean, removePunctuation)                  # remove punctuation
seattle.text.clean = tm_map(seattle.text.clean, content_transformer(tolower))       # ignore case
seattle.text.clean = tm_map(seattle.text.clean, removeWords, stopwords("english"))  # remove stop words

seattle.text.clean[[2]]$content

seattle.text.clean = tm_map(seattle.text.clean, stemDocument)                       # stem all words
seattle.text.clean.tf = DocumentTermMatrix(seattle.text.clean, control = list(weighting = weightTf))

