setwd("D:/docs/studying/Coursera/ExData_proj2")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="proj2.zip")
unzip("proj2.zip",list=FALSE)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI_Baltimore <- NEI[NEI$fips=="24510",]
yearly_emissions <- tapply(NEI_Baltimore$Emissions,NEI_Baltimore$year,sum)
yearly_emissions <-  as.data.frame(yearly_emissions)
years <-c("1999","2002","2005","2008")
yearly_emissions <- cbind(years,yearly_emissions)
names(yearly_emissions)[] <- c("Year","total emissions from PM2.5")

yearly_emissions$Year <- as.numeric(as.character(yearly_emissions$Year))

png(filename = "plot2.png")
plot(yearly_emissions,type="p",pch=20,xaxt="n")
lines(yearly_emissions)
axis(1,at=yearly_emissions$Year,labels=years)
dev.off()
