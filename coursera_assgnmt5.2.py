# Author: Danny Teok
# Desc: Write a program that repeatedly prompts a user for integer numbers until the user enters 'done'. Once 'done' \
#       is entered, print out the largest and smallest of the numbers. If the user enters anything other than a valid \
#       number catch it with a try/except and put out an appropriate message and ignore the number. Enter the numbers \
#       from the book for problem 5.1 and Match the desired output as shown
# Create date: 3 Janunary 2017
# Change log:


largest = None
smallest = None

print("Type \"done\" to quit.")

while True:

    num = raw_input("Enter a number: ")
    if num == "done": break

    try:
        var = float(num)

    except:
        print "Invalid input!"
        continue

    if var > largest or largest is None:
        largest = var

    if var < smallest or smallest is None:
        smallest = var

    print var

print "Maximum", largest
print "Smallest", smallest
