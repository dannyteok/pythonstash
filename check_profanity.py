#/usr/bin/python

# Open file to read

# Search through all words to compare against a list of predefined profanity words. Return "Profanity Alert" upon match"

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
