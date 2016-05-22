## 4 - Across the United States, how have emissions from coal combustion - related sources changed 
## from 1999 –2008?

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


combustion <- grepl("comb", SCC$SCC.Level.One, ignore.case = TRUE) # Find "comb" in level one
coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case = TRUE) # Find "coal" in level four
coalAndCombustion <- (combustion & coal) # If both comb and coal are 1 then 1, otherwise 0
combustionSCC <- SCC[coalAndCombustion,]$SCC # Select codes
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,] # Select data from the codes selected before

library(ggplot2)
png("plot4.png", width = 480, height = 480, units = "px")
ggplot(combustionNEI, aes(factor(year), Emissions)) +
geom_bar(stat = "identity") +
labs(x = "Year", y = expression("Total PM 2.5 Emission (Tons)")) +
labs(title = expression("PM2.5 Coal Combustion Source Emissions"))
dev.off()