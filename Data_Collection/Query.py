#import re
from pymongo import MongoClient
client = MongoClient('localhost', 27017)
db = client['Texas_tweets']
collection = db['twitter_collection']
tweets_iterator = collection.find()
tweets = []
for tweet in tweets_iterator:
    tweets.append(tweet['id'])

print(len(tweets))

#Export Database
#./mongoexport --host localhost --db Washington_tweets --collection twitter_collection --csv > Washington_tweets.csv --fields id,user.id,text,lang,user.lang,user.location,user.screen_name,coordinates
