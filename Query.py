#import re
from pymongo import MongoClient
client = MongoClient('localhost', 27017)
db = client['Washington_tweets']
collection = db['twitter_collection']
tweets_iterator = collection.find()
tweets = []
for tweet in tweets_iterator:
    tweets.append(tweet['id'])

print(len(tweets))
    #if tweet['lang'] == 'en':
        #for i in tweets_iterator:
        #tmp = ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet['text']).split())
        #print(tweet['text'])
#text = tweet['text']
#user_screen_name = tweet['user']['screen_name']
#user_name = tweet['user']['name']
#retweet_count = tweet['retweeted_status']['retweet_count']
#retweeted_name = tweet['retweeted_status']['user']['name']
#retweeted_screen_name = tweet['retweeted_status']['user']['screen_name']
