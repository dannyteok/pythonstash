#/usr/bin/python

# Open file to read

# Search through all words to compare against a list of predefined profanity words. Return "Profanity Alert" upon match"
# This could serve to be useful to decrypt a data file where values in columns are encrypted. Recall David's
# ad-hoc task for BMW.

import urllib

def read_text():
    quotes = open("/home/dantvli/sandbox/pythonstash/movie_quotes.txt")
    contents = quotes.read()
    print(contents)
    quotes.close()
    check_profanity(contents)

def check_profanity(textinput):
    connection = urllib.urlopen("http://www.wdylike.appspot.com/?q=" + textinput)
    output = connection.read()
    print(output)
    connection.close()

read_text()
