import requests
import xml.etree.ElementTree as ET
import csv

# get the xml file
def get_xml(url, xml_file):
    data = requests.get(url)    # send request to url
    with open(xml_file, 'wb') as f: # open file and save xml
        f.write(data.content)

# parse xml file
def parse_xml(xml_file):
    tree = ET.parse(xml_file)   # import xml from
    root = tree.getroot()       # find the root element of xml
    plant_list = []             # list to store the xml
    for item in root.findall('./Station'):    # find all PLANT node
        plant = {}              # dictionary to store content of each PLANT
        for child in item:
            plant[child.tag] = child.text   # add item to dictionary 

        plant_list.append(plant)    # add dictionary to the list

    return plant_list   # return the complete list

# save as csv
def save_to_csv(data, csv_file):
    headers = ['CrsCode','NationalLocationCode','Name','Longitude','Latitude']  # headers for csv
    with open(csv_file,'w') as f:
        writer = csv.DictWriter(f, fieldnames = headers)    # creating a DictWriter object
        writer.writeheader()    # write headers to csv
        writer.writerows(data)  # write each dictionary element of the list row by row


url = "https://stnr-public.s3-eu-west-1.amazonaws.com/Technical+Test/stations.xml"  # url where the xml file is available
xml_file = "station-test.xml"  # file where the xml is saved
csv_file = "rdg-station-output.csv"  # file where data is saved in csv format

get_xml(url,xml_file)
all_data = parse_xml(xml_file)
save_to_csv(all_data,csv_file)
print("XML Parsing Successful")
