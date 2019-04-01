# Databricks notebook source
# MAGIC %md
# MAGIC 
# MAGIC ## Save History and Determine Changeset 
# MAGIC 
# MAGIC This Notebook saves the Current data to History and compares the Current to the Previous data to determine the Changeset.

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ### Parameters

# COMMAND ----------

#dbutils.widgets.removeAll()

dbutils.widgets.text("Scope", "dev")
dbutils.widgets.text("SourceSystem", "AdventureWorks")
dbutils.widgets.text("Entity", "Product")
dbutils.widgets.text("CurrentDataDate", "20190317")
dbutils.widgets.text("PreviousDataDate", "")
dbutils.widgets.text("PrimaryKeyColumnList", "ProductID")

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ### Set Variables
# MAGIC 
# MAGIC Notes:
# MAGIC 
# MAGIC 1) All files used in this Notebook or saved to Blob Storage by this Notebook are in parquet format <br/>
# MAGIC 2) As we are working in a parallel processing environment, any files saved from here will be represented in Blob storage as a folder containing one or multiple parquet files that represent the data
# MAGIC 
# MAGIC The following convention is assumed:
# MAGIC 
# MAGIC 1) The files and folders pertaining to an Entity all reside within the folder structure Scope/System/Entity e.g. Dev/AdventureWorks/Product<br/>
# MAGIC 2) The parquet file representing the Current data import for an Entity resides in the sub-folder 'Current' and is named the same as the Entity e.g. Dev/AdventureWorks/Product/Current/Product.parquet<br/>
# MAGIC 3) The folder representing the Previous data import for an Entity is the sub-folder 'History' and is named the same as the Entity with a suffix representing the date the data represents e.g. Dev/AdventureWorks/Product/History/Product_20190301<br/>
# MAGIC 5) The folder representing the Changeset for an Entity is the sub-folder 'Changeset' and is named the same as the Entity e.g. Dev/AdventureWorks/Product/Changeset/Product

# COMMAND ----------

storageAccountName = "mickblob"
storageAccountAccessKey = "fYRv0+MWcDIxknZ6KVoPGANDTJ40NAxm9NMIH7FORO41HKvyGAEjGwtuoDza8DG1a02H5NJE0PaD4bitruB69w=="
storageAccountNameFullPath = "fs.azure.account.key." + storageAccountName + ".blob.core.windows.net"

entityFolder = "wasbs://" + dbutils.widgets.get("Scope") + "@" + storageAccountName + ".blob.core.windows.net/" + dbutils.widgets.get("SourceSystem") + "/" + dbutils.widgets.get("Entity") + "/"

currentFileName = entityFolder + "Current" + "/" + dbutils.widgets.get("Entity") + ".parquet"
previousFolderName = entityFolder + "History" + "/" + dbutils.widgets.get("Entity") + "_" + dbutils.widgets.get("PreviousDataDate")
historyFolderName = entityFolder + "History" + "/" + dbutils.widgets.get("Entity") + "_" + dbutils.widgets.get("CurrentDataDate")
changesetFolderName = entityFolder + "Changeset"

#print(entityFolder)
#print(currentFileName)
#print(previousFolderName)
#print(historyFolderName)
#print(changesetFolderName)

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ### Set the data location and type
# MAGIC 
# MAGIC There are two ways to access Azure Blob storage: account keys and shared access signatures (SAS).
# MAGIC 
# MAGIC Here we use account keys.

# COMMAND ----------

spark.conf.set(storageAccountNameFullPath, storageAccountAccessKey)

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ## Simulate a daily process
# MAGIC ### Read the current data and the most recent previous data 
# MAGIC 
# MAGIC We create two DataFrames - one representing the Current data and the second representing 'Yesterdays' data. Notice that we use an *option* to specify that we want to infer the schema from the file. We can also explicitly set this to a particular schema if we have one already.

# COMMAND ----------

from pyspark.sql.functions import lit

dfCurrent = spark.read.format("parquet").option("inferSchema", "true").load(currentFileName)

# Add DataDate (the date this data represents) to the Current data and save this file to History
dfCurrent.withColumn("DataDate", lit(dbutils.widgets.get("CurrentDataDate"))).write.mode("overwrite").parquet(historyFolderName)

# COMMAND ----------

# MAGIC %md 
# MAGIC 
# MAGIC ### Find the Changeset that represents all the Deletes, Updates and Inserts in the most recent dataset
# MAGIC 
# MAGIC Note that we add an extra column to the DataFrame called ChangesetType which will have one of the following values:
# MAGIC 
# MAGIC   <ul>
# MAGIC     <li>'Deleted' - The record no longer exists in the Current data</li>
# MAGIC     <li>'InsertedOrUpdated' - The Current record is either new or has experienced a value change to one or more of its columns</li>
# MAGIC     <li>'Current' - There was no Previous data to compare to so this record is taken to be the current state</li>
# MAGIC   </ul>

# COMMAND ----------

primaryKeyColumnList = dbutils.widgets.get("PrimaryKeyColumnList") 
determineChangeset = (primaryKeyColumnList != "")

# If there is no Previous file or the Previous file is invalid (does not exist or some other error), the Changeset will comprise only the records of the Current file.
if (determineChangeset == True):
  if (dbutils.widgets.get("PreviousDataDate") == ""):
    compareToPreviousToProduceChangeset = False
  else:
    try:
      # Read the Previous data and drop column DataDate in preparation for comparison to Current data
      dfPrevious = spark.read.format("parquet").option("inferSchema", "true").load(previousFolderName).drop('DataDate')
      compareToPreviousToProduceChangeset = True
    except Exception as e:
      compareToPreviousToProduceChangeset = False

  #print(compareToPreviousToProduceChangeset)

# COMMAND ----------

if (determineChangeset == True):
  if (compareToPreviousToProduceChangeset == True):
    keyColumns = [i.strip() for i in primaryKeyColumnList.split(",")]

    dfDeletes = dfPrevious.join(dfCurrent, keyColumns, 'left_anti').withColumn("ChangesetType", lit("Deleted"))
    dfInsertsAndUpdates = dfCurrent.exceptAll(dfPrevious).withColumn("ChangesetType", lit("InsertedOrUpdated"))
    dfChangeset = dfDeletes.union(dfInsertsAndUpdates)

    #display(dfChangeset)
    dfChangeset.write.mode("overwrite").parquet(changesetFolderName)
  else:
    dfCurrent.withColumn("ChangesetType", lit("InsertedOrUpdated")).write.mode("overwrite").parquet(changesetFolderName)