import pandas as pd

students = pd.read_csv("../data/students.csv")
students = students[['full_name', 'gender_age', 'fractions', 'probability', 'grade']]

