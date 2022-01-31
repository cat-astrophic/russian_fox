# This scripts gets raw tweets from alexlitel/congresstweets on github

# Importing required modules

import urllib

# Where to save data

username = ''
direc = 'C:/Users/' + username + '/Documents/Data/russian_fox/raw_tweets/'

# Specifying the url base for data harvesting

base = 'https://raw.githubusercontent.com/alexlitel/congresstweets/master/data/2022-'

# Date range to scrape (\pm six days of TC siding with Russia == 2022-01-24)

dates = ['01-' + str(i) for i in range(16,29)]

# Getting the raw data for each date and saving to file

for d in dates:
    
    url = base + d + '.json'
    page = urllib.request.Request(url, headers = {'User-Agent': 'Mozilla/5.0'})
    response = urllib.request.urlopen(page)
    tweets = response.read()
    
    with open(direc + d.replace('-', '_') + '.txt.', 'w') as f:
        
        f.write(str(tweets)[3:-2])
        f.close()
        
