# Author: Danny Teok
# Desc  : Coursera Assignment 4.6 - Functions


# Function to calculate gross pay
def computepay(h, r):
    if h <= 40.0:
        return h * r
    elif h > 40.0:
        return (40 * r) + ((h - 40) * (r * 1.5))

hrs = float(raw_input("Enter hours worked = "))
rate = float(raw_input("Enter rates per hour = "))

p = computepay(hrs, rate)
print "Pay", unichr(163), p