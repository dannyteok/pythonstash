#!/usr/bin/env python
# -*- coding: utf-8 -*-

import ConfigParser
import datetime
import json
import requests
import sys
import thread
import time

from logger import *

class makeRequest:

    #def __init__(self):
        #self.config = ConfigParser.ConfigParser()
        #self.config.read("configuration.cfg")

        #self.environment=self.config.get("settings","environment")
        #self.service=self.config.get("settings","service")
        #self.username=self.config.get(self.environment , "username")
        #self.password=self.config.get(self.environment , "password")
        #self.apiKey=self.config.get(self.environment , "api_key")

    def advisorAPI(self, threadName, delay):
        VARIABLE=99999999999
        url = "http://api-eu1.advisor.smartfocus.com/ips/services/cred/u4616gUM2vph/{randomNumber}/3.0/feed/775".format(randomNumber=VARIABLE)
        headers = {'Content-Type: text/xml'}
        #data = '{"login":"'+self.username+'", "password":"'+self.password+'", "apiKey":"'+self.apiKey+'"}'
        count = 0
        while count < 10:
            log().info("Request "+str(count+1)+"/10")
            ts = time.time()
            timeStamp = datetime.datetime.fromtimestamp(ts).strftime('%H:%M:%S')
            log().info("TimeStamp: {Time}".format(Time=timeStamp))
            try:
                Post = requests.post(url, headers=headers)#, data=data)
                print Post.content
                #jsonPost = json.loads(Post.content)
                #if "status" in jsonPost:
                #    log().error(str(jsonPost["title"]))
                #    log().error("Exiting...")
                #    sys.exit(1)
                #else:
                #    token=jsonPost["token"]
                #    log().info("Recieved Token : {t}".format(t=token))
                #    log().info("TimeStamp: {Time}".format(Time=datetime.datetime.fromtimestamp(ts).strftime('%H:%M:%S')))
            except Exception as error:
                log().error(str(error))
            time.sleep(delay)
            count += 1

    def main(self):
        try:

            intro = "Starting Test of {service} Against {environment}".format(service=self.service, environment=self.environment)
            log().info(intro)

            if self.service == "smartemail":
                thread.start_new_thread( makeRequest().advisorAPI("Thread-01", 1, ) )
                thread.start_new_thread( makeRequest().advisorAPI("Thread-02", 1, ) )
            else:
                log().error("Invalid service Provided")
                log().error("Service was {service}".format(service=self.service))
        except Exception as error:
            log().error(str(error))

if __name__ == "__main__":
    makeRequest().main()