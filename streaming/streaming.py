from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, unix_timestamp
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType
from pyspark.ml import PipelineModel
from pyspark.ml.classification import GBTClassificationModel

# Initialize Spark
spark = SparkSession.builder \
    .appName("LogisticsStreamingPrediction") \
    .config("spark.sql.streaming.schemaInference", "true") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

print("📦 Loading models...")
preprocess_pipeline = PipelineModel.load("/home/epsilon/Desktop/folder_0/projects/sprint_2/Smart-Logistics-System/data/preprocessing_model_spark")
model = GBTClassificationModel.load("/home/epsilon/Desktop/folder_0/projects/sprint_2/Smart-Logistics-System/data/gbt_model_spark")
print("✅ Models loaded successfully!\n")

# Define schema matching WebSocket output (without shipping_date_timestamp - we'll create it)
schema = StructType([
    StructField("Type", StringType(), True),
    StructField("Days for shipment (scheduled)", IntegerType(), True),
    StructField("Benefit per order", DoubleType(), True),
    StructField("Sales per customer", DoubleType(), True),
    StructField("Late_delivery_risk", IntegerType(), True),
    StructField("Customer City", StringType(), True),
    StructField("Customer Country", StringType(), True),
    StructField("Latitude", DoubleType(), True),
    StructField("Longitude", DoubleType(), True),
    StructField("Market", StringType(), True),
    StructField("Order City", StringType(), True),
    StructField("Order Country", StringType(), True),
    StructField("Order Region", StringType(), True),
    StructField("Order State", StringType(), True),
    StructField("Department Id", IntegerType(), True),
    StructField("Product Category Id", IntegerType(), True),
    StructField("Product Price", DoubleType(), True),
    StructField("Product Status", IntegerType(), True),
    StructField("Shipping Mode", StringType(), True),
    StructField("shipping date (DateOrders)", StringType(), True),
    StructField("Order Item Quantity", IntegerType(), True),
    StructField("Order Item Discount Rate", DoubleType(), True),
    StructField("Sales", DoubleType(), True),
    StructField("Order Status", StringType(), True),
    StructField("event_time", StringType(), True)
])

print("🌐 Connecting to socket stream at localhost:9999...")

# Read from socket
df_raw = spark.readStream.format("socket") \
    .option("host", "localhost") \
    .option("port", 9999) \
    .load()

# Parse JSON
df = df_raw.select(from_json(col("value"), schema).alias("data")).select("data.*")

# ✅ CRITICAL FIX: Convert date string to timestamp (matching the training pipeline)
df_with_timestamp = df.withColumn(
    "shipping_date_timestamp",
    unix_timestamp("shipping date (DateOrders)", "M/d/yyyy H:mm")
)

print("✅ Stream connected! Waiting for data...\n")

# Apply preprocessing pipeline
df_features = preprocess_pipeline.transform(df_with_timestamp)

# Make predictions
predictions = model.transform(df_features)

# Extract probability for class 1 (late delivery) using a UDF
from pyspark.sql.functions import udf
from pyspark.sql.types import DoubleType

@udf(returnType=DoubleType())
def get_prob(probability):
    """Extract probability of late delivery (class 1)"""
    if probability is not None:
        return float(probability[1])
    return 0.0

# Add risk probability column
predictions_with_prob = predictions.withColumn("risk_probability", get_prob("probability"))

# Output predictions with key information
query = predictions_with_prob.select(
    "Customer City",
    "Order City",
    "Days for shipment (scheduled)",
    "Shipping Mode",
    "Late_delivery_risk",
    "prediction",
    "risk_probability"
).writeStream \
    .format("console") \
    .outputMode("append") \
    .option("truncate", "false") \
    .trigger(processingTime='2 seconds') \
    .start()

print("=" * 80)
print("🚀 STREAMING PREDICTIONS ACTIVE")
print("=" * 80)
print("📊 Showing: City, Shipping Days, Actual Risk, Predicted Risk, Probability")
print("💡 Tip: The model predicts if delivery will be late (1) or on-time (0)")
print("=" * 80)
print()

query.awaitTermination()