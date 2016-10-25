"""Parse Tweets and export them into a working format for Topic Modeling."""

import os
import re
import pandas as pd
os.chdir("/Users/tylerworthington/Git_Repos/CaseStudy2/Data/")

#Import CSV's
Washington = pd.read_csv("Washington_tweets.csv")
Texas = pd.read_csv("Texas_tweets.csv")

#Subsetting by language for ease
Wash = None
Wash = Washington[Washington['lang'] == 'en']

Tex = None
Tex = Texas[Texas['lang'] == 'en']

#counting tweets
print(len(set(Tex['id'])))
print(len(set(Tex['user.id'])))

print(len(set(Wash['id'])))
print(len(set(Wash['user.id'])))

#stripping non text characters ie @, # ,https://, ect
clean1 = []
for i in Tex['text']:
    tmp = ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", i).split())
    clean1.append(tmp)

Tex['cleaned.text'] = clean1

clean2 = []
for i in Wash['text']:
    tmp1 = ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", i).split())
    clean2.append(tmp1)

Wash['cleaned.text'] = clean2

#collapsing tweets by user.id
Wash['author.text'] = Wash[['user.id', 'cleaned.text']].groupby(['user.id'])['cleaned.text'].transform(lambda x: ','.join(x))
Tex['author.text'] = Tex[['user.id', 'cleaned.text']].groupby(['user.id'])['cleaned.text'].transform(lambda x: ','.join(x))

print(Wash['author.text'])

#Export Tweets
Tex.to_csv('Texas_cleaned.csv')
Wash.to_csv('Washington_cleaned.csv')
