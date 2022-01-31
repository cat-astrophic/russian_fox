# This script assigns political metadata to tweets

# Importing required mdoules

import pandas as pd
import numpy as np
import datetime

# Directory info

username = ''
direc = 'C:/Users/' + username + '/Documents/Data/russian_fox/'

# Read in tweets

tweets_df = pd.read_csv(direc + 'clean_tweets/unprocessed.csv')

# Read in congressional metadata

cmeta = pd.read_csv(direc + 'congressional_metadata/legislators-current.csv')

# Subset cmeta for relevant data

cmeta = cmeta[['birthday', 'gender', 'type', 'state', 'party', 'twitter']]

# Merge congressional metadata into tweets_df

tweets_df = tweets_df.merge(cmeta, left_on = 'screen_name', right_on = 'twitter')

# Calculate age, treated/control

age = [int(np.floor((datetime.datetime.now() - datetime.datetime.strptime(tweets_df.birthday[i], '%Y-%m-%d')).days / 365)) for i in range(len(tweets_df))]
treated = [1 if tweets_df.party[i] == 'Republican' else 0 for i in range(len(tweets_df))]
control = [1 - t for t in treated]

# Add these to tweets_df

age = pd.Series(age, name = 'age')
treated = pd.Series(treated, name = 'treated')
control = pd.Series(control, name = 'control')
tweets_df = pd.concat([tweets_df, age, treated, control], axis = 1)

# Drop extraneous columns

tweets_df = tweets_df[['id', 'screen_name', 'user_id', 'time', 'link', 'text', 'source',
       'date', 'rt', 'qt', 'russia', 'ukraine', 'mention1', 'mention2', 'fox', 'pre',
       'post', 'gender', 'type', 'state', 'party', 'age', 'treated', 'control']]

# Save updated tweets_df to file

tweets_df.to_csv(direc + 'clean_tweets/ready_for_classification.csv', index = False)

