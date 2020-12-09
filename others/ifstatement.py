#!/usr/bin/python3

magic_num = [3, 9]
lives = 3

# Range(lives) here is a list [0.1.2]
for attempt in range(lives):
    print("Attempt #{}".format(attempt))
    usrnum = int(input("Enter a number between 0 and 9: "))

    if usrnum in magic_num:
         print("You have got the number right")
    else:
         print("You got it wrong")
		 