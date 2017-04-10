set -x
set -e

bucketname="abcxyzchristest"
region="eu-central-1"

# Clear any potential old data
rm -rf import 
rm -rf output

mkdir import
mkdir output

./init.py

rm -rf output/*.tsv
aws s3 cp --recursive --region $region s3://$bucketname/ output/
