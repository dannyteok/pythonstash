#!/bin/bash


set -x
set -e

bucketname="abcxyzchristest"
region="eu-central-1"

# Clear any potential old data
rm -rf /opt/etl-dwh/outgoing/import
rm -rf /opt/etl-dwh/outgoing/output

mkdir -p /opt/etl-dwh/outgoing/import
mkdir -p /opt/etl-dwh/outgoing/output

python main_dbdump.py

rm -rf output/*.tsv
aws s3 cp --recursive --region $region s3://$bucketname/ output/
