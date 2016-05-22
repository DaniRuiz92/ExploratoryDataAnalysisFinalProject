## 3 - Of the four types of sources indicated by the type(point, nonpoint, onroad, nonroad) variable,
## which of these four sources have seen decreases in emissions from 1999 –2008 for Baltimore City? 
## Which have seen increases in emissions from 1999 –2008? Use the ggplot2 plotting system to make 
## a plot answer this question.

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
baltimoreData <- transform(baltimoreData, type = factor(type)) # Factorize

baltimoreDataType <- aggregate(Emissions ~ year, baltimoreData, sum) # Aggregate data by years, adding.

library(ggplot2)

png("plot3.png", width = 480, height = 480, units = "px")
ggplot(baltimoreData, aes(factor(year), Emissions, fill = type)) + # Factor: year
geom_bar(stat = "identity") +
facet_grid(. ~ type) + # Split by type
labs(x = "Year", y = expression("Total PM 2.5 Emission (Tons)")) +
labs(title = expression("PM2.5 Emissions in Baltimore City"))
dev.off()
