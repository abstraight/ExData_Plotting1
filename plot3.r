#Since we are free to choose what ways of data management to use to complete the assignment, I'm using MongoBD. (mongodb.com)
#To use it with R we need to load additional libraries, such as mongolite and jsonlite.

library (data.table)
library (datasets)
library (jsonlite)
library (mongolite)
library (base)

#First things first, we create a project and relevant project directories, to keep data for the plots (data), script (script) and outputs 
# such as png files
dir.create("output")
dir.create("data")
dir.create("script")

#Prior to this step one needs to create a database in Mongo and import txt file provided during assignment, we create a connection to the named database
db_url= "mongodb+srv://abstraight:quitepretty@cluster0.xvoxn.mongodb.net/<dbname>?retryWrites=true&w=majority"
db_data = mongo(collection = "Data", db = "ElectricPowerConsumption",url = db_url)

#Checkin the connection we learn that there are 2068000 entities
db_data$count()

#We only need date [1/2/2007;2/2/2007], we create request accordingly and write data into txt file for future use 
data = client$find (limit = 0, skip = 0, '{ "$or": [ { "Date": "1/2/2007" }, { "Date": "2/2/2007" } ] }')
#merging Date & Time variables into object of type Date and POSIXlt to reflect correctly on the screen
data$DateTime <- strptime(paste(data$Date, data$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

#Plot 3 (on screen and to png)
plot (data$DateTime, data$Sub_metering_1, ylab = 'Energy sub metering', xlab ='  ',type = "l")
legend("topright" , lty = 1, col = c("black","red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")

png(file="output/plot3.png", width=480, height=480)
plot (data$DateTime, data$Sub_metering_1, ylab = 'Energy sub metering', xlab ='  ',type = "l")
legend("topright" , lty = 1, col = c("black","red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")
dev.off()