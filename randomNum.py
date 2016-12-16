import random

#magic_numbers = [random.randint(0,49), random.randint(0,49)]
magic_numbers = [random.randint(0,49)]
chances = 3

for attempt in range(chances):
    print("The secret number is: " + str(magic_numbers))
    print("This is attempt {}".format(attempt))
    user_number = int(input("Enter a number between 0 and 49: "))

    if user_number in magic_numbers:
        print("Correct!")
    else:
        print("Wrong!")
