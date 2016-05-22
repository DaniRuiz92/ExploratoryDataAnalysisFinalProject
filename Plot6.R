## 6 - Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
## vehicle sources in Los Angeles County, California(fips == "06037"). Which city has seen greater 
## changes over time in motor vehicle emissions?


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


vehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE) # Find "vehicle" in level one
vehicleDataSCC <- SCC[vehicle,]$SCC # Select codes
vehicleDataNEI <- NEI[NEI$SCC %in% vehicleDataSCC,] # Select data from the codes selected before
vehicleBaltimoreData <- vehicleDataNEI[vehicleDataNEI$fips == "24510",] # Only Baltimore
vehicleAngelesData <- vehicleDataNEI[vehicleDataNEI$fips == "06037",] # Only LA
vehicleBothData <- rbind(vehicleBaltimoreData, vehicleAngelesData)

library(ggplot2)
png("plot6.png", width = 480, height = 480, units = "px")
ggplot(vehicleBothData, aes(factor(year), Emissions, fill = fips)) +
geom_bar(stat = "identity") +
theme(plot.margin = unit(c(1, 0, 0, 0), "cm"))+
facet_grid(scales = "free", space = "free", . ~ fips) +
labs(x = "Year", y = expression("Total PM 2.5 Emission (Tons)")) +
labs(title = expression("PM2.5 Vehicle Combustion Source Emissions;\nBaltimore (fips=24510) and LA comparison (fips=06037)"))
dev.off()
