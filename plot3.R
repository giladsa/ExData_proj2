setwd("D:/docs/studying/Coursera/ExData_proj2")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="proj2.zip")
unzip("proj2.zip",list=FALSE)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI_Baltimore <- NEI[NEI$fips=="24510",]

library(plyr)
yearly_emissions<-ddply(NEI_Baltimore,.(year,type),colwise(mean,"Emissions"))
library(ggplot2)
png(filename = "plot3.png")
qplot(year,Emissions,data=yearly_emissions,facets=type~.,geom=c("point","line"))
dev.off()
