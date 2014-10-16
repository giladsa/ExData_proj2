setwd("D:/docs/studying/Coursera/ExData_proj2")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="proj2.zip")
unzip("proj2.zip",list=FALSE)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

combustion_codes <- SCC[grepl("Combustion",SCC$SCC.Level.One),]
combustion_coal_codes <- combustion_codes[grepl("Coal",combustion_codes$EI.Sector,ignore.case=TRUE),]
combustion_coal_SCC <- combustion_coal_codes$SCC

NEI_combustion_coal <- NEI[NEI$SCC %in% combustion_coal_SCC,]
yearly_emissions <- tapply(NEI_combustion_coal$Emissions,NEI_combustion_coal$year,sum)
yearly_emissions <-  as.data.frame(yearly_emissions)
years <-c("1999","2002","2005","2008")
yearly_emissions <- cbind(years,yearly_emissions)
names(yearly_emissions)[] <- c("Year","total emissions from PM2.5")
yearly_emissions$Year <- as.numeric(as.character(yearly_emissions$Year))

png(filename = "plot4.png")
plot(yearly_emissions,type="p",pch=20,xaxt="n",main="Emissions from coal combustion-related sources 1999-2008")
lines(yearly_emissions)
axis(1,at=yearly_emissions$Year,labels=years)
dev.off()
