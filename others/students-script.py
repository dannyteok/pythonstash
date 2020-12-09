import pandas as pd
from students import students

for col in students.columns:
    print(col)

students = pd.melt(frame=students, id_vars=['full_name',
                                            'gender_age',
                                            'grade'],
                   value_vars=['fractions', 'probability'],
                   var_name='exam',
                   value_name='score')

print(students.head())

print(list(students.columns))

print(students['exam'].value_counts())
