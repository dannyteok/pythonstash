import numpy as np
import pandas as pd
import os
from pathlib import Path


# Here, PROJECT_PATH and REPO_PATH is the same, but expressed differently.
# PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
REPO_PATH = Path(os.path.abspath(__file__)).parent.parent.parent
DATA_DIR = f"{REPO_PATH}/data/kaggle/titanic"

if "titanic.csv" in os.listdir(DATA_DIR):
    DATA_PATH = os.path.join(DATA_DIR, "titanic.csv")
    print(DATA_PATH)
else:
    print("file not found")


def print_full(x):
    pd.set_option("display.max_rows", None)
    pd.set_option("display.max_columns", None)
    pd.set_option("display.width", 2000)
    pd.set_option("display.float_format", "{:20,.4f}".format)
    pd.set_option("display.max_colwidth", None)
    print(x)
    pd.reset_option("display.max_rows")
    pd.reset_option("display.max_columns")
    pd.reset_option("display.width")
    pd.reset_option("display.float_format")
    pd.reset_option("display.max_colwidth")


# Load dataset
x = pd.read_csv(DATA_PATH)
print_full(x.head())
# print(x.columns.tolist())

print("-" * 25)
list_numeric_cols = [
    "Survived",
    "Pclass",
    "Age",
    "Siblings/Spouses Aboard",
    "Parents/Children Aboard",
    "Fare",
]
print_full(x[list_numeric_cols].head())

print("-" * 25)
# Checks total number of rows with null or empty Age.
print_full(x["Age"].isnull().sum())
