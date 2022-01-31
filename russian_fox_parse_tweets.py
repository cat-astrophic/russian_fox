# This scripts parses the raw tweets

# Importing required modules

import glob
import pandas as pd

# Directory info

username = ''
direc = 'C:/Users/' + username + '/Documents/Data/russian_fox/'

# Files to parse

files = glob.glob(direc + 'raw_tweets/*')

# Parsing tweets

tweets = []

for file in files:
    
    with open(file) as f:
        
        text = f.read()
        f.close()
        
    while len(text) > 0:
        
        idx = text.find('},')
        
        if idx  == -1:
            
            tweets.append(text)
            text = ''
            
        else:
            
            tweets.append(text[:idx+1])
            text = text[idx+2:]
            
ids = []
screen_names = []
user_ids = []
times = []
links = []
texts = []
sources = []

for t in tweets:
    
    t = t[7:]
    idx = t.find('","')
    ids.append(t[:idx])
    
    t = t[idx+17:]
    idx = t.find('","')
    screen_names.append(t[:idx])
    
    t = t[idx+13:]
    idx = t.find('","')
    user_ids.append(t[:idx])
    
    t = t[idx+10:]
    idx = t.find('","')
    times.append(t[:idx])
    
    t = t[idx+10:]
    idx = t.find('","')
    links.append(t[:idx])
    
    t = t[idx+10:]
    idx = t.find('","')
    texts.append(t[:idx])
    
    t = t[idx+12:]
    idx = t.find('"')
    sources.append(t[:idx])
    
ids = pd.Series(ids, name = 'id')
screen_names = pd.Series(screen_names, name = 'screen_name')
user_ids = pd.Series(user_ids, name = 'user_id')
times = pd.Series(times, name = 'time')
links = pd.Series(links, name = 'link')
texts = pd.Series(texts, name = 'text')
sources = pd.Series(sources, name = 'source')

tweets_df = pd.concat([ids, screen_names, user_ids, times, links, texts, sources], axis = 1)

dates = [tweets_df.time[i][8:10] for i in range(len(tweets_df))]
rts = [1 if tweets_df.text[i][:2] == 'RT' else 0 for i in range(len(tweets_df))]
qts = [1 if 'QT' in tweets_df.text[i] else 0 for i in range(len(tweets_df))]
russia1 = [1 if 'russia' in tweets_df.text[i] else 0 for i in range(len(tweets_df))]
russia2 = [1 if 'Russia' in tweets_df.text[i] else 0 for i in range(len(tweets_df))]
russia = [max(russia1[i], russia2[i]) for i in range(len(russia1))]
ukraine1 = [1 if 'ukraine' in tweets_df.text[i] else 0 for i in range(len(tweets_df))]
ukraine2 = [1 if 'Ukraine' in tweets_df.text[i] else 0 for i in range(len(tweets_df))]
ukraine = [max(ukraine1[i], ukraine2[i]) for i in range(len(ukraine1))]
mention1 = [max(russia[i], ukraine[i]) for i in range(len(russia))]
mention2 = [1 if russia[i] + ukraine[i] == 2 else 0 for i in range(len(russia))]
fox1 = [1 if 'fox' in tweets_df.text[i] else 0 for i in range(len(tweets_df))]
fox2 = [1 if 'Fox' in tweets_df.text[i] else 0 for i in range(len(tweets_df))]
fox = [max(fox1[i], fox2[i]) for i in range(len(fox1))]
pre = [1 if int(d) < 22 else 0 for d in dates]
post = [1 - p for p in pre]

dates = pd.Series(dates, name = 'date')
rts = pd.Series(rts, name = 'rt')
qts = pd.Series(qts, name = 'qt')
russia = pd.Series(russia, name = 'russia')
ukraine = pd.Series(ukraine, name = 'ukraine')
mention1 = pd.Series(mention1, name = 'mention1')
mention2 = pd.Series(mention2, name = 'mention2')
fox = pd.Series(fox, name = 'fox')
pre = pd.Series(pre, name = 'pre')
post = pd.Series(post, name = 'post')

tweets_df = pd.concat([tweets_df, dates, rts, qts,  russia, ukraine, mention1, mention2, fox, pre, post], axis = 1)

# Save raw tweets to file

tweets_df.to_csv(direc + 'clean_tweets/unprocessed_all.csv', index = False)

# Subset for relevant tweets only and save to file

tweets_df = tweets_df[tweets_df.mention1 == 1].reset_index(drop = True)
tweets_df.to_csv(direc + 'clean_tweets/unprocessed.csv', index = False)

