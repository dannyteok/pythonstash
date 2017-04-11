#!/usr/bin/env python
from subprocess import call
import mysqldumpToCsv
import csv
import MySQLdb

# MySQL Connection Config.
dbName = "abcxyz"
dbHost = "127.0.0.1"
dbUser = "root"
dbPass = "abcxyz"

outputColumnNames = True

## No trailing slash!
outputDirectory="output"

def executeQuery(h,u,p,db,q):
    return ["mysql", "-N", "-h" + h, "-u" + u, "-p" + p, db, "-e", q]

def dbdump(h,u,p,db,t):
    return ["mysqldump", "--single-transaction", "--default-character-set=utf8", "-h" + h, "-u" + u, "-p" + p, db, t]

def fileToDictionary(filePath):
    reader = csv.reader(open(filePath))
    result = {}
    for row in reader:
        result[row[1]] = row[0]
    return result

def getColumnsFromTable(h,u,p,db,t):
    columns = []
    dbCon = MySQLdb.connect(host=h, user=u, passwd=p, db=db)
    cursor = dbCon.cursor()
    cursor.execute("SHOW COLUMNS FROM " + t)
    for record in cursor.fetchall():
        columns.append(record[0])
    return columns

def saveMaxJournalId(h,u,p,db):
    #f = open(outputDirectory + "/latest_journal_entry.dat", "w")
    f = open("/opt/etl-dwh/outgoing/output/latest_journal_entry.dat", "w")
    call(executeQuery(h, u, p, db, "SELECT max(journal_log_id) FROM works_replication_dev.journal_log_entry"), stdout=f)
    f.close

def main():
    tables = fileToDictionary("/opt/umpg_etldwh/dataload/export_tablelist.txt")
    for tableKey in tables.keys():
        tableName = tables[tableKey]

        saveMaxJournalId(dbHost, dbUser, dbPass, dbName)

        # Dump of external database to sql file
        sqlOutputFile = "/opt/etl-dwh/outgoing/import/" + tableKey + ".sql"
        fSql = open(sqlOutputFile, "w")
        call(dbdump(dbHost, dbUser, dbPass, dbName, tableName), stdout=fSql)
        fSql.close()

        # Parse SQL and convert to TSV
        outputFileRelative = tableKey + ".tsv"
        outputFile = outputDirectory + "/" + outputFileRelative

        ## Write column names
        if (outputColumnNames):
            columns = getColumnsFromTable(dbHost, dbUser, dbPass, dbName, tableName)
            tsvColumnNames = "\t".join(columns)
            f = open(outputFile, "w")
            f.write(tsvColumnNames + "\n")
            f.close()

	# Write mysql dump to TSV
        mysqldumpToCsv.convert(sqlOutputFile, outputFile)

        # Compress TSV
        outputFileC = outputDirectory + "/" + outputFileRelative + ".tar.gz"
        fc = open(outputFileC, "w")
        call(["tar", "-zcvf", outputFileC, "-C", outputDirectory, outputFileRelative], stdout=fc)
        fc.close()

if __name__ == "__main__":
        main()
