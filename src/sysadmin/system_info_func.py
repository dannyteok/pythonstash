#!/usr/bin/env python
# A System Information Gathering Script

import subprocess as sp

def uname_fn():

    uname = "uname"
    uname_arg = "-a"
    print("Gathering system information with " + uname + " command:\n")
    sp.call([uname, uname_arg])

def disk_fn():
    diskspace = "df"
    diskspace_arg = "-h"
    print("Gathering disk information with " + diskspace + " command:\n")
    sp.call([diskspace, diskspace_arg])

def diskusage_fn():
    diskusage = "df"
    diskusage_arg = "-h"
    print("Gathering disk usage information with " + diskusage + " command:\n")
    sp.call([diskusage, diskusage_arg])

# Main function that calls other functions
def main():
    uname_fn()
    disk_fn()
    diskusage_fn()

if __name__ == "__main__":
    main()
