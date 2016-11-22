#!/usr/bin/env python

# Date:        17/08/2016
# Author:      Long Chen
# Description: A script to send marathon docker container metrics data by using python zabbix sender
# Requires Python Zabbix Sender: https://github.com/kmomberg/pyZabbixSender/blob/master/pyZabbixSender.py
# cp pyZabbixSender.py /usr/lib/python<version>/site-packages/
# Example Usage: zabbix-marathon.py <marathon server ip address> <marathon app id> <zabbix host name>

from pyZabbixSender import pyZabbixSender
from datetime import datetime
import time
import json
import urllib2
import sys

def getMarathonAppsTasks(server, app_id):
    marathon_server_url = 'http://' + server + ':8080/v2/apps' + app_id + '?embed=app.taskStats'
    try:
        api_request = urllib2.urlopen(marathon_server_url, timeout=10)
        result = json.load(api_request)
        tasks_data = {}
        tasks_data['tasksRunning'] = result['app']['tasksRunning']
        tasks_data['tasksHealthy'] = result['app']['tasksHealthy']
        tasks = result['app']['tasks']
        containers = []
        tasks_data['containers'] = containers
        for task in tasks:
            dict = {}
            state = task['state'] # TASK_RUNNING, TASK_LOST
            if state == 'TASK_RUNNING':
                state = 1
            else:
                state = 0
            host = task['host']
            slaveId = task['slaveId']
            startTime = task['startedAt']
            if 'healthCheckResults' in task:
                # true or false
                alive = task['healthCheckResults'][0]['alive']
                if alive:
                    runningState = 1
                else:
                    runningState = 0
            else:
                runningState = 0
            dict['host'] = host
            dict['slaveId'] = slaveId
            dict['startTime'] = startTime
            dict['state'] = state
            dict['runningState'] = runningState
            containers.append(dict)
        return tasks_data
    except urllib2.HTTPError as e:
        print 'The server couldn\'t fulfill the request.'
        print 'Error code: ', e.code
        sys.exit(1)
    except urllib2.URLError as e:
        print 'Reach the server failing.'
        print 'Reason: ', e.reason
        sys.exit(1)

if __name__ == '__main__':
    # Get marathon server from command line argument
    marathon_server = str(sys.argv[1])
    marathon_app_id = str(sys.argv[2])
    zabbix_host = str(sys.argv[3])
    zabbix_server = '127.0.0.1'
    # Init containers data used for discovery
    lldlist = []
    llddata = {"data": lldlist}
    # Init a list for storing zabbix item keys and values
    zabbix_item_key_value = []
    tasks_data = getMarathonAppsTasks(marathon_server,marathon_app_id)
    if tasks_data:
        zabbix_item = {}
        zabbix_item['zabbix_item_key'] = 'personalizer.tasks.running'
        zabbix_item['zabbix_item_value'] = tasks_data['tasksRunning']
        zabbix_item_key_value.append(zabbix_item)
        zabbix_item = {}
        zabbix_item['zabbix_item_key'] = 'personalizer.tasks.healthy'
        zabbix_item['zabbix_item_value'] = tasks_data['tasksHealthy']
        zabbix_item_key_value.append(zabbix_item)
        for container in tasks_data['containers']:
            dict = {}
            dict["{#HOST}"] = container['host']
            dict["{#SLAVEID}"] = container['slaveId']
            lldlist.append(dict)
            zabbix_item = {}
            zabbix_item['zabbix_item_key'] = 'task_state[' + container['host'] + ',' + container['slaveId'] + ']'
            zabbix_item['zabbix_item_value'] = container['state']
            zabbix_item_key_value.append(zabbix_item)
            zabbix_item = {}
            zabbix_item['zabbix_item_key'] = 'start_time[' + container['host'] + ',' + container['slaveId'] + ']'
            # convert ISO 8601 time to unix time
            zabbix_item['zabbix_item_value'] = time.mktime((datetime.strptime(container['startTime'][:-5], "%Y-%m-%dT%H:%M:%S")).timetuple())
            zabbix_item_key_value.append(zabbix_item)
            zabbix_item = {}
            zabbix_item['zabbix_item_key'] = 'container_state[' + container['host'] + ',' + container['slaveId'] + ']'
            zabbix_item['zabbix_item_value'] =  container['runningState']
            zabbix_item_key_value.append(zabbix_item)
    else:
        print 'No personalization app tasks found.'
        sys.exit(1)

    # Init zabbix sender to connect to zabbix server
    zabbix_sender = pyZabbixSender(server=zabbix_server, port=10051)
    # Covert container discovery data to json string
    llddata = json.dumps(llddata)
    zabbix_sender.addData(zabbix_host,'personalizer.containers.discovery',llddata)
    for zabbix_item in zabbix_item_key_value:
        zabbix_item_key = zabbix_item['zabbix_item_key']
        zabbix_item_value = zabbix_item['zabbix_item_value']
        zabbix_sender.addData(zabbix_host,zabbix_item_key,zabbix_item_value)
    #zabbix_sender.printData()
    result = zabbix_sender.sendData()
    print result[0][0]
