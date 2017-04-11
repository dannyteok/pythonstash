# Requirements
Required apts: mysql-client, python-pymysql, python3-mysql, pip, python3-mysqldb, python3-mysql.connector, python-mysqldb
Get aws cli: $ pip install --upgrade --user awscli
Configure aws cli - this can be done by running through the wizard with `aws configure`
Check path to aws cli: which aws
Set aws cli path to $PATH: echo "export PATH=~/.local/bin:$PATH" >> $HOME/.profile
python mysqlclient library installed

#Configuration

1. Set database credentials in main_dbdump.py
2. Toggle column names in main_dbdump.py (outputColumnNames variable)
3. Set S3 bucket and region in process_extraction_main.sh
