washington <- read.csv('Washington_tweets.csv')
texas <- read.csv('Texas_tweets.csv')

seattle <- washington[grepl('seattle', washington$user.location, ignore.case = TRUE),]
washington.other <- washington[!grepl('eattle', washington$user.location) & 
                             (grepl('WA', washington$user.location) | 
                                grepl('ashington', washington$user.location)), ]

austin <- texas[grepl('austin', texas$user.location, ignore.case = TRUE),]
dallas <- texas[grepl('dallas', texas$user.location, ignore.case = TRUE),]
houston <- texas[grepl('houston', texas$user.location, ignore.case = TRUE),]
texas.other <- texas[! (grepl('austin', texas$user.location, ignore.case = TRUE) | 
                          grepl('dallas', texas$user.location, ignore.case = TRUE) | 
                          grepl('ouston', texas$user.location, ignore.case = TRUE)) & 
                       (grepl('TX', texas$user.location) | 
                          grepl('texas', texas$user.location, ignore.case = TRUE)), ]
