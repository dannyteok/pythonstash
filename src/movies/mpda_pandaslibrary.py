
# coding: utf-8

# In[2]:

#get_ipython().magic('matplotlib inline')
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


# In[8]:

cols = ['user_id', 'item id', 'rating', 'timestamp']
ratings = pd.read_csv('/home/dantvli/projects/data/MovieTweetings/latest/ratings.dat', sep='::',
                     index_col=False, names=cols, engine='python',
                     encoding="UTF-8")


# In[10]:

#ratings[:100]


# In[17]:

rating_counts = ratings['rating'].value_counts().sort_index()
rating_counts


# In[18]:

rating_counts.plot(kind='bar', color='SteelBlue')
plt.title('Movie ratings')
plt.xlabel('Rating')
plt.ylabel('Count')


# In[20]:

#To find out if the ratings for a particular movie genre, e.g. Crime Drama, is similar to the overall distribution
# we need to cross-ref ratings info with movie informatoin in movies.dat.

cols = ['movie id', 'movie title', 'genre']
movies = pd.read_csv('../../../data/MovieTweetings/latest/movies.dat', sep='::',
                     index_col=False, names=cols, engine='python',
                     encoding="UTF-8")

movies[:50]


# In[ ]:



