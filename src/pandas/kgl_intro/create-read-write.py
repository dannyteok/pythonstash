# Ref       - https://www.kaggle.com/residentmario/creating-reading-and-writing
# Exercise  - https://www.kaggle.com/dannyteok/exercise-creating-reading-and-writing/edit

import pandas as pd
import numpy as np

"""
The basic form of a DataFrame is that
    columns (field names) are defined as dictionary keys, and
    rows (values) are lists
"""

fruit_sales = pd.DataFrame({'Apple': [35, 4], 'Bananas': [32, 34]},
                           index=['2017 Sales', '2018 Sales'])

print(fruit_sales)

"""
As such, similarly, you could define the same in the following way, 
which may offer more flexibility when adding/removing entries. 
Decoupling everything and constructing the df last.
"""
# Specify values in list
apple = [35, 4, 23, 34, 23, 64, 238, 1252]
banana = [32, 34, 156, 12, 645, 87, 159, 1326]
fruit_idx = ['2017 Sales', '2018 Sales', '2019 Sales',
             '2020 Sales', '2021 Sales', '2022 Projection',
             '2023 Projection', 'Beyond 2024 ']

# Build the dictionary of lists
fruit_dict = {'Apple': apple, 'Bananas': banana}
# And, finally the dataframe
fruit_sales_df = pd.DataFrame(fruit_dict, index=fruit_idx)

print(fruit_sales_df)