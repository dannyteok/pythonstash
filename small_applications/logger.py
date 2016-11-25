#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class log:
    def __init__(self):
        logging.basicConfig(
            filename="/home/dteok/etl_dwh/dataload/scripts/logs/api.log",
            filemode='a',
            foormat='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
            datefmt='%H:%M:%S',
            level=logging.INFO
            )

        logging.info("Running Sync Script")
        self.logger = logging.getLogger('BMWSync')

    def main(self):
        print "Import Module Should NOT be run manually"

    def ok(self, message):
        print " [+] " + bcolors.OKGREEN + message + bcolors.ENDC
        self.logger.info(message)

    def info(self, message):
        print " [+] " + bcolors.OKGREEN + message + bcolors.ENDC
        self.logger.info(message)

    def warning(self, message):
        print " [+] " + bcolors.WARNING + message + bcolors.ENDC
        self.logger.warning(message)

    def error(self, message):
        print " [!] " + bcolors.FAIL + message + bcolors.ENDC
        self.logger.error(message)

if __name__ == "__main__":
    log().main()