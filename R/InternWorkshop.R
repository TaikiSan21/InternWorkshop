# This should report 0.12.8 as of 6-7-2021

packageVersion('PAMpal')
# Load the package
library(PAMpal)

# Point to our folders
db <- './Data/Database/InternWorkshop.sqlite3'
binaries <- './Data/Binaries/'
settings  <- './Data/Other/InternWorkshop.xml'

# Create our PAMpalSettings object and process our data
pps <- PAMpalSettings(db=db, binaries = binaries)
pps <- addSettings(pps, settings)
# also has mode='recording' and mode='time'
data <- processPgDetections(pps, mode='db', id='InternTutorial')
View(data)

clickData <- getClickData(data)
cepstrumData <- getCepstrumData(data)

View(clickData)

# Lets make some plots by species type
# First we assign the species
data <- setSpecies(data, method='pamguard')
species(data)
data %>% 
  filter(grepl('Pulse', species)) %>% 
  calculateAverageSpectra(evNum=1:4, wl=1024)

data %>% 
  filter(grepl('Click', species)) %>% 
  calculateAverageSpectra(evNum=1:10)

data %>% 
  filter(grepl('Click', species)) %>% 
  calculateAverageSpectra(evNum=3, sort=T)

# wigner plot of a click

plotWigner(data, clickData$UID[1], length=2000)

# Creating some spectrogram plots with our detections
recordings <- './Data/Recordings/'
data <- addRecordings(data, recordings, log=FALSE)
plotGram(data, evNum=11, wl=4096)

plotGram(data, evNum=10, wl=2048)

# Lets download some environmental data from ERDDAP
# First we need to add GPS data to our detections
gpsFile <- './Data/Other/WorkshopGps.csv'
gps <- read.csv(gpsFile)
data <- addGps(data, gps)
data <- matchEnvData(data)

View(data$InternWorkshop.OE8)
