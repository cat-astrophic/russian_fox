# Simulations for fox or sheep model

# Importing required modules

import random
import pandas as pd
import numpy as np
import seaborn as sb
from matplotlib import pyplot as plt

# Specifying where to save outputs

username = ''
direc = 'C:/Users/' + username + '/Documents/Data/russian_fox/figures/'

# Parameter / data storage initialization

c = 10000 # number of constituents
a = .01 # alpha
steps = 100 # number of time steps to simulate

# Simple model / median voter theorem analog 

posdf = pd.DataFrame()
newsdf = pd.DataFrame()

pos = [random.uniform(0,1) for i in range(c)] # initial positions - constituents
news = [random.uniform(0,1/2), random.uniform(1/2,1)] # initial positions - networks

posdf = pd.concat([posdf, pd.Series(pos, name = 't0')], axis = 1)
newsdf = pd.concat([newsdf, pd.Series(news, name = 't0')], axis = 1)

# Main loop

for i in range(steps):
    
    median = np.median(pos)
    news = [median, median]
    
    for p in range(len(pos)):
        
        diffs = [abs(pos[p]-news[0]), abs(pos[p]-news[1])]
        nk = news[diffs.index(min(diffs))]
        pos[p] = pos[p] + a*(nk - pos[p])
        
    posdf = pd.concat([posdf, pd.Series(pos, name = 't' + str(i+1))], axis = 1)
    newsdf = pd.concat([newsdf, pd.Series(news, name = 't' + str(i+1))], axis = 1)
    
# Complex model

posdfx = pd.DataFrame()
newsdfx = pd.DataFrame()

pos = [random.uniform(0,1) for i in range(c)] # initial positions - constituents
news = [random.uniform(0,1/2), random.uniform(1/2,1)] # initial positions - networks

posdfx = pd.concat([posdfx, pd.Series(pos, name = 't0')], axis = 1)
newsdfx = pd.concat([newsdfx, pd.Series(news, name = 't0')], axis = 1)

# Main loop

for i in range(steps):
    
    median = np.median(pos)
    val0 = 0
    val1 = 0
    xx0 = 0
    xx1 = 1
    
    # Approximate the optimal position for each network
    
    for j in range(int(np.floor(median*1000))):
        
        x0 = j/1000 # point to consider
        x1 = 1 - j/1000
        a0 = max(0,x0-.15)
        a1 = max(median,x1-.15)
        b0 = min(median,x0+.15)
        b1 = min(1,x1+.15)
        
        v0 = len([p for p in pos if p < b0 and p > a0])
        v1 = len([p for p in pos if p < b1 and p > a1])
        
        if v0 > val0:
            
            val0 = v0
            xx0 = x0
            
        if v1 > val1:
            
            val1 = v1
            xx1 = x1  
    
    news = [xx0,xx1]
    
    for p in range(len(pos)):
        
        diffs = [abs(pos[p]-news[0]), abs(pos[p]-news[1])]
        nk = news[diffs.index(min(diffs))]
        q =  random.uniform(0,.5)
        
        if q > abs(nk - pos[p]): # probabilistic news consumption
            
            pos[p] = pos[p] + a*(nk - pos[p])
            
    posdfx = pd.concat([posdfx, pd.Series(pos, name = 't' + str(i+1))], axis = 1)
    newsdfx = pd.concat([newsdfx, pd.Series(news, name = 't' + str(i+1))], axis = 1)
    
# Visualizing results

# Initial distributions of constituents

fig, ax = plt.subplots()
sb.histplot(posdf.t0, bins = 100, ax = ax)
plt.ylabel('Frequency - Simple Model')
plt.xlabel('Initial Constituent Beliefs')
ax.set_xticks([0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1])
ax.set_xticklabels([0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1])
ax2 = ax.twinx()
sb.histplot(posdfx.t0, bins = 100, ax = ax2, color = 'orange')
plt.ylabel('Frequency - Complex Model')
plt.title('Model Comparison - Initial Conditions')
plt.tight_layout()
plt.savefig(direc + 'simulations_initial.png')
plt.show()

# Final distributions of constituents

fig, ax = plt.subplots()
sb.histplot(posdf.t100, bins = 100, ax = ax)
plt.ylabel('Frequency - Simple Model')
plt.xlabel('Updated Constituent Beliefs')
ax.set_xticks([0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1])
ax.set_xticklabels([0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1])
ax2 = ax.twinx()
sb.histplot(posdfx.t100, bins = 100, ax = ax2, color = 'orange')
plt.ylabel('Frequency - Complex Model')
plt.title('Model Comparison - Updated Conditions')
ax2.set_yticks([0, 40, 80, 120, 160, 200, 240])
ax2.set_yticklabels([0, 40, 80, 120, 160, 200, 240])
plt.tight_layout()
plt.savefig(direc + 'simulations_updated.png')
plt.show()

# Evolution of the news biases

n0 = list(newsdfx.iloc[0])
n1 = list(newsdfx.iloc[1])
n0 = n0[1:]
n1 = n1[1:]

fig, ax = plt.subplots()
plt.plot(n0, color = 'blue')
plt.plot(n1, color = 'red')
plt.ylabel('News Bias')
plt.xlabel('Time Step')
ax2 = ax.twinx()
plt.ylabel('News Bias')
plt.title('Evolution of News Biases')
ax2.set_yticks = ax.set_yticks
ax2.set_yticklabels = ax.set_yticklabels
plt.tight_layout()
plt.savefig(direc + 'simulations_biases.png')
plt.show()

