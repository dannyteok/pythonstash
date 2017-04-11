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

# Call python script
python main_dbdump.py

rm -rf /opt/etl-dwh/outgoing/output/*.tsv

# Upload to S3 bucket.
# aws s3 cp --recursive <source> <s3: destination>
# use --recursive if multiple files, otherwise drop it.
aws s3 cp --recursive /opt/etl-dwh/outgoing/output s3://$bucketname/origin/
