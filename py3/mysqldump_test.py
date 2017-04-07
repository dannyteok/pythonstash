#!/usr/bin/env python3

import os
import sys, getopt

# basepath = os.path.realpath(__file__) - This will get the last element, which is this script's file name.
base = os.path.realpath(__file__).split("/")[-1]

# def dbconfig()

def main(argv):
    # Declare var first as empty
    hostname = ''
    password = ''
    username = ''
    schema = ''

    try:
        opts, args = getopt.getopt(argv, "p:u:s:h:", ["password", "username=", "schema=", "hostname="])

    except getopt.GetoptError:
        print("Usage: " + base + " -u <username> -p <password> -h <hostname> -s <database name>")
        sys.exit(2)

    for opt, arg in opts:
        # Will be nice to enforce - if not in -p -u -s or -h, then prints message and exits.
        if opt == '-h':
            print("Usage: " + base + " -u <username> -p <password> -h <hostname> -s <database name>")
            sys.exit(9)
        # If syntax is correct, then assign the command line argument as inputfile
        elif opt in ("-p", "--password"):
            password = arg
        elif opt in ("-u", "--username"):
            username = arg
        elif opt in ("-s", "--schema"):
            schema = arg
        elif opt in ("-h", "--hostname"):
            hostname = arg

    print("The database hostname is " + hostname)
    print("Database username is " + username)
    print("Secret password is " + password)
    print("Schema/database is " + schema)

if __name__ == "__main__":
    main(sys.argv[1:])

