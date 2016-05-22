## 2 - Have total emissions from PM2.5 decreased in the Baltimore City, Maryland(fips == "24510")
## from 1999 to 2008 ? Use the base plotting system to make a plot answering this question.

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

baltimoreData <- NEI[NEI$fips == "24510",] # Only Baltimore
baltimoreTotalPM25 <- with(baltimoreData, tapply(Emissions, year, sum, na.rm = T)) # Sum by year

png("plot2.png", width = 480, height = 480, units = "px")
barplot(baltimoreTotalPM25, xlab = "Year", ylab = "Total PM 2.5", main = "Total PM2.5 emissions in Baltimore per year")
dev.off()