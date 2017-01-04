# Author: Danny Teok
# Desc  : Opening and reading a data file
# Notes : Developed in Python 2.7.14


fhand = open('data/mbox.txt')


for line in fhand:
    line = line.rstrip()
    if not line.startswith('From:'):
        continue
    print line

fhand.close()


