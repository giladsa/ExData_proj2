setwd("D:/docs/studying/Coursera/ExData_proj2")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="proj2.zip")
unzip("proj2.zip",list=FALSE)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

motors <- SCC[regexpr("motor",SCC$Short.Name,ignore.case=TRUE)!=-1,]
motors <- motors[grepl("Mobile",motors$SCC.Level.One),]
motors_SCC <- motors$SCC

NEI_motors <- NEI[NEI$SCC %in% motors_SCC,]
NEI_motors_Baltimore <- NEI_motors[NEI_motors$fips=="24510",]
yearly_emissions <- tapply(NEI_motors_Baltimore$Emissions,NEI_motors_Baltimore$year,sum)
yearly_emissions <-  as.data.frame(yearly_emissions)
years <-c("1999","2002","2005","2008")
yearly_emissions <- cbind(years,yearly_emissions)
names(yearly_emissions)[] <- c("Year","total emissions from PM2.5")

yearly_emissions$Year <- as.numeric(as.character(yearly_emissions$Year))

png(filename = "plot5.png")
plot(yearly_emissions,type="p",pch=20,xaxt="n",main="Emissions from motor vehicle sources 1999-2008 in Baltimore")
lines(yearly_emissions)
axis(1,at=yearly_emissions$Year,labels=years)
dev.off()
