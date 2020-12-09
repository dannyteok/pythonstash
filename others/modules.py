import random, sys, os, math, numpy

# This function can be applied to creating a dice, where min value is 2, and max is 12.
def fortuneCookie(magicNumber):
    if magicNumber == 1:
        return "Yes, it is certain"
    elif magicNumber == 2:
        return "It has been decided so"
    elif magicNumber == 3:
        return "Yes"
    elif magicNumber ==4:
        return "Reply hazy try again!"
    elif magicNumber == 5:
        return "Ask me again later"
    elif magicNumber == 6:
        return "My reply is a no."
    elif magicNumber == 7:
        return "Concentrate deeper and ask again"
    elif magicNumber == 8:
        return "You will be lucky tonight!"
    elif magicNumber == 9:
        return "Very doubtful"

    eggs = 1243

#for i in range(8):
#    print(random.randint(0, 99))

#mn = random.randint(1, 9)
#fortune = fortuneCookie(mn)
print(fortuneCookie(random.randint(1, 9)))
try:
    print("I'm thinking of the number" + eggs)
except NameError:
    print("ERROR: Invalid variable reference. Did you define a local var but called it from outside?")



'''
while True:
    exit_resp = input("Type 'quit' to exit")
    if exit_resp == 'quit':
        sys.exit()
    print("Quitting application")
'''