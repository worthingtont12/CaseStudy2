washington <- read.csv('Washington_cleaned.csv')
texas <- read.csv('Texas_cleaned.csv')
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

# clean Seattle data
seattle.text <- VCorpus(DataframeSource(as.data.frame(seattle$author.text)))
seattle.text.clean = tm_map(seattle.text, stripWhitespace)                          # remove extra whitespace
seattle.text.clean = tm_map(seattle.text.clean, removeNumbers)                      # remove numbers
seattle.text.clean = tm_map(seattle.text.clean, removePunctuation)                  # remove punctuation
seattle.text.clean = tm_map(seattle.text.clean, content_transformer(tolower))       # ignore case
seattle.text.clean = tm_map(seattle.text.clean, removeWords, stopwords("english"))  # remove stop words
seattle.text.clean = tm_map(seattle.text.clean, stemDocument, lazy = TRUE)                       # stem all words
seattle.text.clean.tf = DocumentTermMatrix(seattle.text.clean, control = list(weighting = weightTf))

# clean Washington.Other data
washington.other.text <- VCorpus(DataframeSource(as.data.frame(washington.other$author.text)))
washington.other.text.clean = tm_map(washington.other.text, stripWhitespace)                          # remove extra whitespace
washington.other.text.clean = tm_map(washington.other.text.clean, removeNumbers)                      # remove numbers
washington.other.text.clean = tm_map(washington.other.text.clean, removePunctuation)                  # remove punctuation
washington.other.text.clean = tm_map(washington.other.text.clean, content_transformer(tolower))       # ignore case
washington.other.text.clean = tm_map(washington.other.text.clean, removeWords, stopwords("english"))  # remove stop words
washington.other.text.clean = tm_map(washington.other.text.clean, stemDocument, lazy = TRUE)          # stem all words
washington.other.text.clean.tf = DocumentTermMatrix(washington.other.text.clean, control = list(weighting = weightTf))

# clean Houston data
houston.text <- VCorpus(DataframeSource(as.data.frame(houston$author.text)))
houston.text.clean = tm_map(houston.text, stripWhitespace)                          # remove extra whitespace
houston.text.clean = tm_map(houston.text.clean, removeNumbers)                      # remove numbers
houston.text.clean = tm_map(houston.text.clean, removePunctuation)                  # remove punctuation
houston.text.clean = tm_map(houston.text.clean, content_transformer(tolower))       # ignore case
houston.text.clean = tm_map(houston.text.clean, removeWords, stopwords("english"))  # remove stop words
houston.text.clean = tm_map(houston.text.clean, stemDocument, lazy = TRUE)          # stem all words
houston.text.clean.tf = DocumentTermMatrix(houston.text.clean, control = list(weighting = weightTf))

# clean Austin data
austin.text <- VCorpus(DataframeSource(as.data.frame(austin$author.text)))
austin.text.clean = tm_map(austin.text, stripWhitespace)                          # remove extra whitespace
austin.text.clean = tm_map(austin.text.clean, removeNumbers)                      # remove numbers
austin.text.clean = tm_map(austin.text.clean, removePunctuation)                  # remove punctuation
austin.text.clean = tm_map(austin.text.clean, content_transformer(tolower))       # ignore case
austin.text.clean = tm_map(austin.text.clean, removeWords, stopwords("english"))  # remove stop words
austin.text.clean = tm_map(austin.text.clean, stemDocument, lazy = TRUE)          # stem all words
austin.text.clean.tf = DocumentTermMatrix(austin.text.clean, control = list(weighting = weightTf))

# clean Dallas data
dallas.text <- VCorpus(DataframeSource(as.data.frame(dallas$author.text)))
dallas.text.clean = tm_map(dallas.text, stripWhitespace)                          # remove extra whitespace
dallas.text.clean = tm_map(dallas.text.clean, removeNumbers)                      # remove numbers
dallas.text.clean = tm_map(dallas.text.clean, removePunctuation)                  # remove punctuation
dallas.text.clean = tm_map(dallas.text.clean, content_transformer(tolower))       # ignore case
dallas.text.clean = tm_map(dallas.text.clean, removeWords, stopwords("english"))  # remove stop words
dallas.text.clean = tm_map(dallas.text.clean, stemDocument, lazy = TRUE)          # stem all words
dallas.text.clean.tf = DocumentTermMatrix(dallas.text.clean, control = list(weighting = weightTf))

# clean Texas.Other data
texas.other.text <- VCorpus(DataframeSource(as.data.frame(texas.other$author.text)))
texas.other.text.clean = tm_map(texas.other.text, stripWhitespace)                          # remove extra whitespace
texas.other.text.clean = tm_map(texas.other.text.clean, removeNumbers)                      # remove numbers
texas.other.text.clean = tm_map(texas.other.text.clean, removePunctuation)                  # remove punctuation
texas.other.text.clean = tm_map(texas.other.text.clean, content_transformer(tolower))       # ignore case
texas.other.text.clean = tm_map(texas.other.text.clean, removeWords, stopwords("english"))  # remove stop words
texas.other.text.clean = tm_map(texas.other.text.clean, stemDocument, lazy = TRUE)          # stem all words
texas.other.text.clean.tf = DocumentTermMatrix(texas.other.text.clean, control = list(weighting = weightTf))




###############################


austin_text <- paste(austin$author.text, collapse = ' ')
seattle_text <- paste(seattle$author.text, collapse = ' ')
dallas_text <- paste(dallas$author.text, collapse = ' ')
houston_text <- paste(houston$author.text, collapse = ' ')
texas.other_text <- paste(texas.other$author.text, collapse = ' ')
washington.other_text <- paste(washington.other$author.text, collapse = ' ')

text.df <- as.data.frame(c(seattle_text, washington.other_text, austin_text, dallas_text, houston_text, texas.other_text))

text.df = VCorpus(DataframeSource(text.df))
text.clean = tm_map(text.df, stripWhitespace)                          # remove extra whitespace
text.clean = tm_map(text.clean, removeNumbers)                      # remove numbers
text.clean = tm_map(text.clean, removePunctuation)                  # remove punctuation
text.clean = tm_map(text.clean, content_transformer(tolower))       # ignore case
text.clean = tm_map(text.clean, removeWords, stopwords("english"))  # remove stop words
text.clean = tm_map(text.clean, stemDocument)                       # stem all words

text.clean.tfidf = DocumentTermMatrix(text.clean, control = list(weighting = weightTfIdf))
doc.tfidf = t(inspect(text.clean.tfidf[]))

seattle.ss <- sum((doc.tfidf[,1])^2)
washington.other.ss <- sum((doc.tfidf[,2])^2)
austin.ss <- sum((doc.tfidf[,3])^2)
dallas.ss <- sum((doc.tfidf[,4])^2)
houston.ss <- sum((doc.tfidf[,5])^2)
texas.other.ss <- sum((doc.tfidf[,6])^2)

seattle.vs.washington <- sum(doc.tfidf[,1]*doc.tfidf[,2])
seattle.vs.washington / sqrt((seattle.ss)*(washington.other.ss))

seattle.vs.austin <- sum(doc.tfidf[,1]*doc.tfidf[,3])
seattle.vs.austin / sqrt((seattle.ss)*(austin.ss))

seattle.vs.houston <- sum(doc.tfidf[,1]*doc.tfidf[,5])
seattle.vs.houston / sqrt((seattle.ss)*(houston.ss))

houston.vs.austin <- sum(doc.tfidf[,5]*doc.tfidf[,3])
houston.vs.austin / sqrt((houston.ss)*(austin.ss))
