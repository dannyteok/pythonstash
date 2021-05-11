# read local parquet file

# pyspark is not working. :(

from pyspark.sql import SparkSession

# Initialise sparkContext
spark = SparkSession.builder \
    .master('local') \
    .appName('myAppName') \
    .config('spark.executor.memory', '5gb') \
    .config("spark.cores.max", "6") \
    .getOrCreate()

sc = spark.sparkContext

# using SQLContext to read parquet file
from pyspark.sql import SQLContext
sqlContext = SQLContext(sc)

# to read parquet file
# pcx_radarcosdata_dlg
# df = sqlContext.read.parquet('data/input/part-00000-0044bf78-0c61-4146-ad13-8b75050eeeca.c000.snappy.parquet')


# bc_basemoneyreceived
df = sqlContext.read.parquet('data/input/part-00000-025c5137-c58c-4ef9-9b8d-53d8a32fef5f.c000.snappy.parquet')
print(df)

# for field in df.schema.fields:
#     print(field.name, field.dataType)