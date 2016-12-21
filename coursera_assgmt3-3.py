'''
Write a program to prompt for a score between 0.0 and 1.0. If the score is out of range, print an error. If the score is between 0.0 and 1.0, print a grade using the following table:
Score Grade
>= 0.9 A
>= 0.8 B
>= 0.7 C
>= 0.6 D
< 0.6 F
If the user enters a value out of range, print a suitable error message and exit. For the test, enter a score of 0.85
'''

def grades(score):
    if 0.9 <= score <= 1.0:
        return "A"
    elif 0.8 <= score <= 0.9:
        return "B"
    elif 0.7 <= score <= 0.8:
        return "C"
    elif 0.6 <= score <= 0.7:
        return "D"
    elif score < 0.6:
        return "F"
    else:
        return "Error! Exiting"

try:
    score = float(raw_input("Enter score between 0.0 and 1.0: "))
    while 0.0 <= score <= 1.0:
        print grades(score)
        break
    else:
        print "Error! Enter a number between 0.0 and 1.0 only."
except:
    print "You entered an invalid score. Try again using between 0.0 and 1.0."


