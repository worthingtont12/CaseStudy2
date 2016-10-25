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
