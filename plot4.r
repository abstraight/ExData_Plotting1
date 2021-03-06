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
db_url= "mongodb+srv://[username]:[password]@cluster0.xvoxn.mongodb.net/<dbname>?retryWrites=true&w=majority"
db_data = mongo(collection = "Data", db = "ElectricPowerConsumption",url = db_url)

#Checkin the connection we learn that there are 2068000 entities
db_data$count()

#We only need date [1/2/2007;2/2/2007], we create request accordingly and write data into txt file for future use 
data = client$find (limit = 0, skip = 0, '{ "$or": [ { "Date": "1/2/2007" }, { "Date": "2/2/2007" } ] }')
#merging Date & Time variables into object of type Date and POSIXlt to reflect correctly on the screen
data$DateTime <- strptime(paste(data$Date, data$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

#Plot 4
par(mfrow = c(2,2))
par(mar = c(4,4,2,1))

plot (x= data$DateTime, y = data$Global_active_power, ylab = 'Global Active power (kilowatts)', xlab ='  ', type = "l")
plot (x= data$DateTime, y = data$Voltage, ylab = 'Voltage', xlab ='datetime', type = "l")
plot (x= data$DateTime, y = data$Sub_metering_1, ylab = 'Energy sub metering', xlab ='  ',type = "l")
legend("topright" , bty = "n", lty = 1, col = c("black","red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
lines(x= data$DateTime, y = data$Sub_metering_2, col = "red")
lines(x= data$DateTime, y = data$Sub_metering_3, col = "blue")
plot (x= data$DateTime, y = data$Global_reactive_power, ylab = 'Global_reactive_power', xlab ='datetime', ylim = range(0,0.5), type = "l")

png(file="output/plot4.png", width=480, height=480)
par(mfrow = c(2,2))
par(mar = c(4,4,2,1))
plot (x= data$DateTime, y = data$Global_active_power, ylab = 'Global Active power (kilowatts)', xlab ='  ', type = "l")
plot (x= data$DateTime, y = data$Voltage, ylab = 'Voltage', xlab ='datetime', type = "l")
plot (x= data$DateTime, y = data$Sub_metering_1, ylab = 'Energy sub metering', xlab ='  ',type = "l")
legend("topright" , bty = "n", lty = 1, col = c("black","red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
lines(x= data$DateTime, y = data$Sub_metering_2, col = "red")
lines(x= data$DateTime, y = data$Sub_metering_3, col = "blue")
plot (x= data$DateTime, y = data$Global_reactive_power, ylab = 'Global_reactive_power', xlab ='datetime', ylim = range(0,0.5), type = "l")
dev.off()
