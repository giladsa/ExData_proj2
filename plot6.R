setwd("D:/docs/studying/Coursera/ExData_proj2")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="proj2.zip")
unzip("proj2.zip",list=FALSE)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

motors <- SCC[regexpr("motor",SCC$Short.Name,ignore.case=TRUE)!=-1,]
motors <- motors[grepl("Mobile",motors$SCC.Level.One),]
motors_SCC <- motors$SCC

NEI_motors <- NEI[NEI$SCC %in% motors_SCC,]
NEI_motors_Baltimore   <- NEI_motors[NEI_motors$fips=="24510",]
NEI_motors_LosAngeles  <- NEI_motors[NEI_motors$fips=="06037",]

yearly_emissions_Baltimore <- tapply(NEI_motors_Baltimore$Emissions,NEI_motors_Baltimore$year,sum)
yearly_emissions_Baltimore <-  as.data.frame(yearly_emissions_Baltimore)

yearly_emissions_LosAngeles <- tapply(NEI_motors_LosAngeles$Emissions,NEI_motors_LosAngeles$year,sum)
yearly_emissions_LosAngeles <-  as.data.frame(yearly_emissions_LosAngeles)

years <-c("1999","2002","2005","2008")

yearly_emissions_Baltimore <- cbind(years,yearly_emissions_Baltimore)
names(yearly_emissions_Baltimore)[] <- c("Year","Baltimore")
names(yearly_emissions_LosAngeles)[] <- c("LosAngeles")

yearly_emissions_Baltimore$Year <- as.numeric(as.character(yearly_emissions_Baltimore$Year))
yearly_emissions_join <- cbind(yearly_emissions_Baltimore,yearly_emissions_LosAngeles)


library(ggplot2)
library(reshape)

yearly_emissions_join_yearbased <- melt(yearly_emissions_join,id="Year")
names(yearly_emissions_join_yearbased)[2] <- "City"

png(filename = "plot6.png")
qplot(Year,value,data=yearly_emissions_join_yearbased,color=City,geom=c("point","line"))+ 
  ylab("Total emissions from PM2.5")  +
  ggtitle("Emissions from motor vehicle sources 1999-2008 in Baltimore VS Los Angeles")
dev.off()
