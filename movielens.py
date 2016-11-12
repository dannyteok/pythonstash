#!/usr/bin/python3

import pandas as pd
from StringIO import StringIO

print("Hello!")

rnames = ['user_id', 'movie_id', 'rating', 'timestamp']
ratings = pd.read_table('/home/dantvli/data/ml-latest/ratings.csv', sep=',', header=None, names=rnames, dtype={"user_id": int, "movie_id": int, "rating": int})



