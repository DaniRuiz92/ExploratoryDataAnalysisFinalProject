## 1 - Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from all 
## sources for each of the years 1999, 2002, 2005, and 2008.

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

totalPM25 <- with(NEI, tapply(Emissions, year, sum, na.rm = T))

png("plot1.png", width = 480, height = 480, units = "px")
barplot(totalPM25, xlab = "Year", ylab = "Total PM 2.5", main = "Total PM2.5 emissions per year")
dev.off()
