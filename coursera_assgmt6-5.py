# Author: Danny Teok
# Desc  : Assignment 6.5
'''
Write code using find() and string slicing (see section 6.10) to extract the number at the end of the line below.
Convert the extracted value to a floating point number and print it out.

Desired output: 0.8475
'''

text = "X-DSPAM-Confidence:    0.8475    ";
x = text.find(':')
y = text[x:]
z = y.split()                   # split() is a string function that removes whitespaces, tabs, or newlines.

print(x)
print(y)
print(z)
print(float(z[1]))