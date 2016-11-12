#!/usr/bin/python3

import time

## This is one way of doing this. Another way is to using function
'''
print("Hello World!")
name = input("What is your name? ")
print("It is good to meet you, " + name + "!")
# Request for user's age
age = input("Tell me, " + name + ", how old are you this year? ")
print("Ah! You're " + age + " years old!? Just like me!")

print("Wanna know your age in year 2074? It's the year when I become the most celebrated AI system.")
decision = input()

if decision == "yes":
    print("Sweet! You will be 38 years old")
elif decision == "no":
    print("That's okay! See you!")
'''

def hello(name):
    now = time.strftime("%c")
    print("Hello World!")
    print("Hello " + name + "! It is " + now + " now. Have a great day!")

inputname = input("What is your name? ")
hello(inputname)
