## Assignment

## The overall goal of this assignment is to explore the National Emissions Inventory database 
## and see what it say about fine particulate matter pollution in the United states over the 10
## - year period 1999 –2008. You may use any R package you want to support your analysis.

## Questions

## You must address the following questions and tasks in your exploratory analysis. For each 
## question / task you will need to make a single plot. Unless specified, you can use any 
## plotting system in R to make your plot.

## 1 - Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from all 
## sources for each of the years 1999, 2002, 2005, and 2008.

## 2 - Have total emissions from PM2.5 decreased in the Baltimore City, Maryland(fips == "24510")
## from 1999 to 2008 ? Use the base plotting system to make a plot answering this question.

## 3 - Of the four types of sources indicated by the type(point, nonpoint, onroad, nonroad) variable,
## which of these four sources have seen decreases in emissions from 1999 –2008 for Baltimore City? 
## Which have seen increases in emissions from 1999 –2008? Use the ggplot2 plotting system to make 
## a plot answer this question.

## 4 - Across the United States, how have emissions from coal combustion - related sources changed 
## from 1999 –2008?

## 5 - How have emissions from motor vehicle sources changed from 1999 – 2008 in Baltimore City?

## 6 - Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
## vehicle sources in Los Angeles County, California(fips == "06037"). Which city has seen greater 
## changes over time in motor vehicle emissions?


setwd("D:/Dropbox/DataScience/Exploratory Data Analysis/Project")


## Creates data directory it it doesn't exists
if (!file.exists("./data")) { 
    dir.create("./data")
}
## Download data
if (!file.exists("./data/dataset.zip")) {
fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip' ## Data url
download.file(fileUrl, destfile = "./data/dataset.zip") ## Downloading the data set
}

unzip("./data/dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = "./data", unzip = "internal",
      setTimes = FALSE) ## Unzip the data set

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

## Exploring size and names of the data
dim(NEI)
names(NEI)

dim(SCC)
names(SCC)

## Part 1
dates <- NEI$year
str(dates)
uniqueDates<-unique(NEI$year)
totalPM25 <- with(NEI, tapply(Emissions, year, sum, na.rm = T))

png("plot1.png", width = 480, height = 480, units = "px")
barplot(totalPM25, xlab = "Year", ylab = "Total PM 2.5", main="Total PM2.5 emissions per year")
dev.off()

## Part 2
dates <- NEI$year
str(dates)
uniqueDates <- unique(NEI$year)
baltimoreData <- NEI[NEI$fips == "24510",] # Only Baltimore
baltimoreTotalPM25 <- with(baltimoreData, tapply(Emissions, year, sum, na.rm = T)) # Sum by year

png("plot2.png", width = 480, height = 480, units = "px")
barplot(baltimoreTotalPM25, xlab = "Year", ylab = "Total PM 2.5", main = "Total PM2.5 emissions in Baltimore per year")
dev.off()
     
## Part 3
dates <- NEI$year
str(dates)
uniqueDates <- unique(NEI$year)
baltimoreData <- NEI[NEI$fips == "24510",] # Only Baltimore
baltimoreData <- transform(baltimoreData, type = factor(type)) # Factorize

baltimoreDataType <- aggregate(Emissions ~ year, baltimoreData, sum) # Aggregate data by years, adding.

library(ggplot2)

png("plot3.png",width=480,height=480,units="px")
ggplot(baltimoreData, aes(factor(year), Emissions, fill = type)) + # Factor: year
geom_bar(stat = "identity") +
facet_grid(. ~ type) + # Split by type
labs(x = "Year", y = expression("Total PM 2.5 Emission (Tons)")) +
labs(title = expression("PM2.5 Emissions in Baltimore City"))
dev.off()

## Part 4


combustion <- grepl("comb", SCC$SCC.Level.One, ignore.case = TRUE) # Find "comb" in level one
coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case = TRUE) # Find "coal" in level four
coalAndCombustion <- (combustion & coal) # If both comb and coal are 1 then 1, otherwise 0
combustionSCC <- SCC[coalAndCombustion,]$SCC # Select codes
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,] # Select data from the codes selected before

png("plot4.png", width = 480, height = 480, units = "px")
ggplot(combustionNEI, aes(factor(year), Emissions)) +
geom_bar(stat = "identity") +
labs(x = "Year", y = expression("Total PM 2.5 Emission (Tons)")) +
labs(title = expression("PM2.5 Coal Combustion Source Emissions"))
dev.off()

## Part 5

vehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE) # Find "vehicle" in level one
vehicleDataSCC <- SCC[vehicle,]$SCC # Select codes
vehicleDataNEI <- NEI[NEI$SCC %in% vehicleDataSCC,] # Select data from the codes selected before
vehicleBaltimoreData <- vehicleDataNEI[vehicleDataNEI$fips == "24510",] # Only Baltimore

png("plot5.png", width = 480, height = 480, units = "px")
ggplot(vehicleBaltimoreData, aes(factor(year), Emissions)) +
geom_bar(stat = "identity") +
labs(x = "Year", y = expression("Total PM 2.5 Emission (Tons)")) +
labs(title = expression("PM2.5 Vehicle Combustion Source Emissions"))
dev.off()

## Part 6

vehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE) # Find "vehicle" in level one
vehicleDataSCC <- SCC[vehicle,]$SCC # Select codes
vehicleDataNEI <- NEI[NEI$SCC %in% vehicleDataSCC,] # Select data from the codes selected before
vehicleBaltimoreData <- vehicleDataNEI[vehicleDataNEI$fips == "24510",] # Only Baltimore
vehicleAngelesData <- vehicleDataNEI[vehicleDataNEI$fips == "06037",] # Only LA
vehicleBothData <- rbind(vehicleBaltimoreData,vehicleAngelesData)

png("plot6.png", width = 480, height = 480, units = "px")
ggplot(vehicleBothData, aes(factor(year), Emissions, fill=fips)) +
geom_bar(stat = "identity") +
facet_grid(scales = "free", space = "free", . ~ fips) +
labs(x = "Year", y = expression("Total PM 2.5 Emission (Tons)")) +
labs(title = expression("PM2.5 Vehicle Combustion Source Emissions; Baltimore and LA comparison"))
dev.off()
