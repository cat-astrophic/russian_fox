# This script uses twint to harvest relevant twitter data

# Importing required modules

import twint
import nest_asyncio
import pandas as pd

# Use nest_asyncio to permit asynchronous loops

nest_asyncio.apply()

# Keywords to search for

keywords = ['russia', 'ukraine']

# Initializing results df

twitter_df = pd.DataFrame()

# Running twint

for k in keywords:
    
    t = twint.Config()
    t.Search = k
    t.Since = '2022-01-18'
    t.Until = '2022-01-25'
    t.Store_csv = True
    t.Pandas = True
    twint.run.Search(t)
    twint.storage.panda.save
    Tweets_df = twint.storage.panda.Tweets_df
    twitter_df = pd.concat([twitter_df, Tweets_df], axis = 0)
    
    t = twint.Config()
    t.Search = k
    t.Since = '2022-01-25'
    t.Until = '2022-01-31'
    t.Store_csv = True
    t.Pandas = True
    twint.run.Search(t)
    twint.storage.panda.save
    Tweets_df = twint.storage.panda.Tweets_df
    twitter_df = pd.concat([twitter_df, Tweets_df], axis = 0)

# Writing the raw data file :: UPDATE USER / FILEPATH

#twitter_df.to_csv('C:/Users/Michael/Documents/Data/russian_fox/twint/raw_twitter_data.csv', index = False)
twitter_df.to_csv('F:/russian_fox/twint/raw_twitter_data.csv', index = False)

