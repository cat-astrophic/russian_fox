# This script creates the classification

# Importing required mdoules

import pandas as pd

# Directory info

username = ''
direc = 'C:/Users/' + username + '/Documents/Data/russian_fox/'

# Read in tweets

tweets_df = pd.read_csv(direc + 'clean_tweets/ready_for_classification.csv')

# Classification process

classes = []
res = False

while res == False:
    
    res = input('Manually classification of tweets:\nAnti-Russia |->  1\nIndeterminate |-> 0\nPro-Russia |-> -1\nPress any key to continue.......\n')
    
    if res != '':
        
        res = True
        
for t in tweets_df.text:
    
    print('Tweet ' + str(list(tweets_df.text).index(t) + 1) + ' of ' + str(len(tweets_df)) + '.......\n')
    print(t)
    res = 2
    
    while res not in [-1,0,1]:
        
        try:
            
            res = int(input('Classification == '))
            
        except:
            
            res = 2
        
    classes.append(res)
    print('\n')
    
# Add to classes tweets_df and save to file

classes = pd.Series(classes, name = 'class')
tweets_df = pd.concat([tweets_df, classes], axis = 1)

tweets_df.to_csv(direc + 'clean_tweets/classified_data.csv', index = False)

