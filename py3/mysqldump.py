#!/usr/bin/python3

#
# This python script is used for MySQL full dump using mysqldump utility
#

import os
import time
import datetime

DBHOST = 'rdsjavaworksdev.ccctouzcrhfl.us-east-1.rds.amazonaws.com'
DBUSER = 'replication'
DBPSWD = '5RTMHqS23wAWLvNy'
DBNAME = '/opt/umpg_etldwh/dataload/export_tablelist.txt'
#DUMP_PATH = '/opt/umpg_etldwh/dataload/outgoing/'
DUMP_PATH = '/opt/etl-dwh/outgoing/'

# Getting current datetime to create seprate backup folder like "12012013-071334".
DATETIME = time.strftime('%Y-%m-%d_%H%M')

TODAYSDUMPPATH = DUMP_PATH + DATETIME

# Checking if backup folder already exists or not. If not exists will create it.
print("Create dump folder")
if not os.path.exists(TODAYSDUMPPATH):
    os.makedirs(TODAYSDUMPPATH)

# Code for checking if you want to take single database backup or assinged multiple backups in DB_NAME.
print("Checking for databases names file.")
if os.path.exists(DBNAME):
    file1 = open(DBNAME)
    multi = 1
    print("Databases file found...")
    print("Starting backup of all dbs listed in file " + DBNAME)
else:
    print("Databases file not found...")
    print("Starting backup of database " + DBNAME)
    multi = 0

# Starting actual database backup process.
if multi:
   in_file = open(DBNAME,"r")
   flength = len(in_file.readlines())
   in_file.close()
   p = 1
   dbfile = open(DBNAME,"r")

   while p <= flength:
       db = dbfile.readline()   # reading database name from file
       db = db[:-1]         # deletes extra line
       dumpcmd = "mysqldump -u " + DBUSER + " -p" + DBPSWD + " --single-transaction --routines --triggers --compatible=mssql" + " -h" + DBHOST + " works_qa " + db + " > " + TODAYSDUMPPATH + "/" + db + ".sql"
       os.system(dumpcmd)
       p = p + 1
   dbfile.close()
else:
   db = DBNAME
   dumpcmd = "mysqldump -u " + DBUSER + " -p" + DBPSWD + " --single-transaction --routines --triggers --compatible=mssql" + " -h" + DBHOST + " works_qa " + db + " > " + TODAYSDUMPPATH + "/" + db + ".sql"
   os.system(dumpcmd)

print("Dumping table completed")
#print("Your backups has been created in '" + TODAYSDUMPPATH + "' directory")
