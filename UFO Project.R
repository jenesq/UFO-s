## UFO Project 3-8-18

################################################################################################
##NOTE:  through out the code in each section the graphs are displaying the same information but in a different color or view depending on where I was posting the data.
###############################################################################################

#Loading the Data:
library(readxl)
ufo <- read_excel("C:/Users/Jenny Esquibel/Dropbox/Jenny Folder/Data Science Masters/MSDS 692  - Practicum I/ufo.xlsx")
 

#Load Libraries:
install.packages("zoo")
install.packages("maps")
install.packages("mapdata")
install.packages("dplyr")
install.packages("stringr")
install.packages("viridis")
install.packages("lsr")
install.packages("DMwR")

library(zoo)
library(maps)
library(mapdata)
library(ggplot2)
library(devtools)
library(dplyr)
library(stringr)
library(viridis)
library(lsr)
library(caTools)
library(DMwR)

#Examining the Data:
knitr::kable(head(ufo))
str(ufo)
ufo$ampm=as.factor(ufo$ampm)
ufo$Region=as.factor(ufo$Region)
ufo$Hoax=as.factor(ufo$Hoax)
ufo$Shape=as.factor(ufo$Shape)
ufo$State=as.factor(ufo$State)

head(ufo)
summary(ufo)

##############################################
#Amount of UFO Sightings by Region:
countregion <-summary(ufo$Region)
plot(ufo$Region, main="UFO Sightings by Region", ylab="Total Sightings", xlab="Region",col="light blue")
plot(ufo$Region, main="UFO Sightings by Region", ylab="Total Sightings", xlab="Region",col="green")

countregion <- as.table(countregion)
countregion <- as.data.frame(countregion)
colnames(countregion) <- c("region", "count")
str(countregion)
head(countregion)

regionplot1 <- ggplot(countregion, aes(x = region, y = count)) +
  geom_bar(stat = "identity",colour="Green") +labs(title="UFO Sightings by Region", y="Total Sightings", x="Region")
regionplot1
regionplot2 <- ggplot(countregion, aes(x = reorder(region, -count), y = count)) +
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by Region", y="Total Sightings", x="Region")
regionplot2

################################################

#UFO Sightings by state
countstate <-summary(ufo$State)
plot(ufo$State, main="UFO Sightings by State", ylab="Total Sightings", xlab="State",col="green")
plot(ufo$State, main="UFO Sightings by State", ylab="Total Sightings", xlab="State",col="light blue")


countstate <- as.table(countstate)
countstate <- as.data.frame(countstate)
colnames(countstate) <- c("state", "count")
str(countstate)
head(countstate)
summary(countstate)

stateplot1 <- ggplot(countstate, aes(x = state, y = count)) +
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by State", y="Total Sightings", x="State")
stateplot1

stateplot2 <- ggplot(countstate, aes(x = reorder(state, -count), y = count)) +
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by State", y="Total Sightings", x="State")
stateplot2 

#############################################

#sightings per state relative to state population:
countstate$statespop <- c("4067175", "746079", "4872725", "2998643", "7044577", "4631000", "39506094",
                          "5632271", "3568174", "691963", "960054", "20979964", "10421344", "1431957", 
                          "3147389", "1713452", "12764031", "6653338", "2907857", "4449337", "4694372",
                          "6839318", "1282000", "6037911", "1333505", "9938885", "5557469", "6109796", 
                          "2988062", "1052967", "753914", "10258390", "759069", "1920467", "528448", 
                          "1339479", "8953517", "2081702", "942926", "211945", "2996358", "19743395",
                          "11623656", "3939708", "13600000", "4162296", "12776550", "146283",
                          "3661538", "8215000", "1057245", "1677000", "5027404", "872989", "1130000", "6707332", 
                          "28295553", "3111802", "8456029", "102951", "623100", "7415710", "5789525", 
                          "1821151", "584447", "35847", "0")
countstate
countstate<-countstate[-c(67), ]
countstate
countstate$statespop=as.numeric(countstate$statespop)
countstate$propsight = (countstate$count / countstate$statespop)*100 # prop data series for viz, scaled for style
countstateplot1 <- ggplot(countstate, aes(x = state, y = propsight)) +
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by State by Population", y="Proportion of Sightings", x="State")

countstateplot1

countstateplot2 <- ggplot(countstate, aes(x = reorder(state, -propsight), y = propsight)) +
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by State by Population", y="Proportion of Sightings", x="State")
countstateplot2

##############################################

#Amount of UFO Sightings Per Day of week:
ufo$weekday <- factor(weekdays(ufo$Date, T), levels = rev(c("Mon", "Tue", "Wed", "Thu","Fri", "Sat", "Sun")))
plot(ufo$weekday, xlab="Day of the Week", ylab="Total Sightings", main="UFO Sighting by Day", col = "light blue")
plot(ufo$weekday, xlab="Day of the Week", ylab="Total Sightings", main="UFO Sighting by Day", col = "Green")

summary(ufo$weekday)

#############################################

#Amount of UFO Sightings Per Decade:
ufo$year<-as.numeric(format(ufo$Date, "%Y")) 
summary(ufo$year)

ufo$decade<- ufo$year - (ufo$year %% 10)
ufo$decade
hist(ufo$decade, xlab="Decade", ylab="# of Sightings", main = "UFO Sightings by Decade", col="green")
hist(ufo$decade, xlab="Decade", ylab="# of Sightings", main = "UFO Sightings by Decade", col="light blue")

##############################################
#Amount of UFO Sightings Per Century:
ufo$century<- ufo$year - (ufo$year %% 100)
ufo$century
hist(ufo$century, xlab="Century", ylab="# of Sightings", main = "UFO Sightings by Century", col = "Green")
hist(ufo$century, xlab="Century", ylab="# of Sightings", main = "UFO Sightings by Century", col = "light blue")

###############################################

#Most popular month:
str(ufo$Date)
ufo$month<-as.factor(format(ufo$Date, "%m")) 
summary(ufo$month)
plot(ufo$month,main="UFO Sightings by Month", ylab="Total Sightings",xlab="Month",col="green")
plot(ufo$month,main="UFO Sightings by Month", ylab="Total Sightings",xlab="Month",col="light blue")

ufoDataByMonth <-summary(ufo$month)
ufoDataByMonth <- as.table(ufoDataByMonth)
ufoDataByMonth <- as.data.frame(ufoDataByMonth)
colnames(ufoDataByMonth) <- c("month", "count")
plot(ufoDataByMonth,main="UFO Sightings by Month", ylab="Total Sightings",xlab="Month")

###############################################
#Calculate avg ufo sightings by month:
Totalyears = max(ufo$year)-min(ufo$year)
TotalMonths <-summary(ufo$month)
TotalMonths <-as.table(TotalMonths)
TotalMonths= as.data.frame(TotalMonths)
colnames(TotalMonths) <- c("month", "total")
TotalMonths$AvgPerMonth <-(TotalMonths$total)/Totalyears
TotalMonths
plot(TotalMonths$month,TotalMonths$AvgPerMonth, ylab="Average Sightings",xlab="Month",main="Average UFO Sightings by Month")

###############################################
#UFO Descriptions
countshape <-summary(ufo$Shape)
countshape
plot(ufo$Shape, ylab="# of Sightings",xlab="Shape",main="UFO Descriptions", col="light blue")
plot(ufo$Shape, ylab="# of Sightings",xlab="Shape",main="UFO Descriptions", col="green")

countshape <- as.table(countshape)
countshape <- as.data.frame(countshape)
colnames(countshape) <- c("shape", "count")
str(countshape)
head(countshape)

shapeplot1 <- ggplot(countshape, aes(x = shape, y = count)) +
  geom_bar(stat = "identity",colour="green")
shapeplot1

shapeplot2 <- ggplot(countshape, aes(x = reorder(shape, -count), y = count)) +
  geom_bar(stat = "identity",colour="Green")
shapeplot2 

###############################################
#Correlations Matrix (Function borrowed from https://gist.github.com/talegari/b514dbbc651c25e2075d88f31d48057b):
df=ufo[,c(10,5,6,15,3,11,19,16,13,14)]
cor2 = function(df){
  
  stopifnot(inherits(df, "data.frame"))
  stopifnot(sapply(df, class) %in% c("integer"
                                     , "numeric"
                                     , "factor"
                                     , "character"))
  
  cor_fun <- function(pos_1, pos_2){
    
# both are numeric
    if(class(df[[pos_1]]) %in% c("integer", "numeric") &&
       class(df[[pos_2]]) %in% c("integer", "numeric")){
      r <- stats::cor(df[[pos_1]]
                      , df[[pos_2]]
                      , use = "pairwise.complete.obs"
      )
    }
    
# one is numeric and other is a factor/character
    if(class(df[[pos_1]]) %in% c("integer", "numeric") &&
       class(df[[pos_2]]) %in% c("factor", "character")){
      r <- sqrt(
        summary(
          stats::lm(df[[pos_1]] ~ as.factor(df[[pos_2]])))[["r.squared"]])
    }
    
    if(class(df[[pos_2]]) %in% c("integer", "numeric") &&
       class(df[[pos_1]]) %in% c("factor", "character")){
      r <- sqrt(
        summary(
          stats::lm(df[[pos_2]] ~ as.factor(df[[pos_1]])))[["r.squared"]])
    }
    
# both are factor/character
    if(class(df[[pos_1]]) %in% c("factor", "character") &&
       class(df[[pos_2]]) %in% c("factor", "character")){
      r <- lsr::cramersV(df[[pos_1]], df[[pos_2]], simulate.p.value = TRUE)
    }
    
    return(r)
  } 
  
  cor_fun <- Vectorize(cor_fun)
  
# now compute corr matrix
  corrmat <- outer(1:ncol(df)
                   , 1:ncol(df)
                   , function(x, y) cor_fun(x, y)
  )
  
  rownames(corrmat) <- colnames(df)
  colnames(corrmat) <- colnames(df)
  
  return(corrmat)
}
cor2(df)

###############################################

#Probability - Is it a hoax??
#Use SMOTE to Balance the dataset
ufo$Hoax = as.character(ufo$Hoax)
ufo$Hoax[ufo$Hoax == "NoHoax"] = "0"
ufo$Hoax[ufo$Hoax == "YesHoax"] = "1"
ufo$Hoax = as.factor(ufo$Hoax)
modeldata=ufo[,c(10,5,6,15,3,11,19,16,13,14)]
modeldata=na.omit(modeldata)
ModelSM <- SMOTE(Hoax ~ ., as.data.frame(modeldata), perc.over = 42000, perc.under = 2000)
set.seed(111)
split = sample.split(ModelSM$Hoax, SplitRatio = 0.8)
trainset = subset(ModelSM, split == TRUE)
testset = subset(ModelSM, split == FALSE)
##42000 decided from the 100/(269Hoax/112652NoHoax) in dataset= ~42000 
trainset$Hoax = as.numeric(trainset$Hoax)
model <- glm(Hoax ~ ., data=trainset)
summary(model)

pred<-predict.glm(model,testset)
pred2<- ifelse(c(pred) > 1.37,1,0)
predict3=as.vector(pred2)
table(testset$Hoax, predict3)
Accuracy <-(225276+4400)/(225276+4400+7051+3204)
Accuracy

################################################
#World Map - https://www.kaggle.com/mrisdal/animating-ufo-sightings

map <- borders("world", colour = "green", fill="gray66")
ufo_map <- ggplot(ufo, aes(frame = year)) + map +
  geom_point(aes(x=Longitude, y=Latitude, color=Shape)) +
  scale_color_viridis(discrete = TRUE, alpha = 0.75) + 
  theme(legend.position = "none")
ufo_map





