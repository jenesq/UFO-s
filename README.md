## ANALYZING UFO SIGHTINGS

This dataset contains over 112,000 reports of UFO sightings dating back to 1939.

## Description

This project for my Data Science practicum I. I collected the UFO Sightings data by scraping the datapoints from the NUFORC website (http://www.nuforc.org/).  The reporting center collects data with an online form or through a hotline number.  

My inspiration was to answer the following questions:
- Geography - Where do UFO sightings occur the most?
- Seasonality - Is there a popular time during the year that UFO sightings happen?
- Consistency - Are there frequently used descriptions in the 'shapes' section?
- Probability - Statistically, build a model that predicts a hoax correctly
- Visual - Build a model that displays UFO sightings on a map

## Observations on the quality of the data

The UFO data is by far the most badly formatted data I have worked with and I underestimated the amount of time it would take to get this dataset in working order.  The data form used to enter the UFO sightings from the NUFORC site should contain only dropdown menu options, but unfortunately the dropdown menu option was only used for 2 out of 11 main questions.  This led to very inconsistent data gathering! The shear amount of data made it difficult to format the data into a single format.  The variation of the defining time values was so different that one small change in code led to wide variations in accuracy.  The locations listed in the records just had a county name others distances and locations outside of known locations. Additionally, not all the questions in the data entry form from the NUFORC site are not mandatory and therefore this led to many data records being incomplete.

## Exploratory Data Analysis (EDA):

I completed this project using R.  I was struggling with cleaning the data in R because of the inconsistancy in each column.  Therefore, I did a majority of cleaning in Excel.  The data columns are Date, Time, City, State, UFO Description, Comments, and Coordinates.    
    
After cleaning the data I reviewed my hard work with the following commands:    
    
knitr::kable(head(ufo))    
str(ufo)    
    
I noticed my values needed to be converted to factors:    
    
ufo$ampm=as.factor(ufo$ampm)    
ufo$Region=as.factor(ufo$Region)    
ufo$Hoax=as.factor(ufo$Hoax)    
ufo$Shape=as.factor(ufo$Shape)     
ufo$State=as.factor(ufo$State)    
    
Checking the variables as factors to ensure the conversion was done properly:    
    
head(ufo)    
summary(ufo)    
   
### Building the Models:    

I needed the following libraries to run my models:    
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
       
### Amount of UFO Sightings by Region:    
    
countregion <-summary(ufo$Region)    
plot(ufo$Region, main="UFO Sightings by Region", ylab="Total Sightings", xlab="Region",col="green")   
    
![image](https://user-images.githubusercontent.com/36289126/37189951-38ab56ae-2314-11e8-934b-db52a2b205f2.png)    

    


countregion <- as.table(countregion)    
countregion <- as.data.frame(countregion)    
colnames(countregion) <- c("region", "count")    
str(countregion)  
    
  'data.frame':4 obs. of  2 variables:    
 $ region: Factor w/ 4 levels "Alaska","Canada",..: 1 2 3 4    
 $ count : int  519 4727 8084 99480    
     
     
head(countregion)    
    
       region   count    
1        Alaska   519    
2        Canada  4727    
3 International  8084    
4        States 99480    
    
regionplot1 <- ggplot(countregion, aes(x = region, y = count)) +    
  geom_bar(stat = "identity",colour="Green") +labs(title="UFO Sightings by Region", y="Total Sightings", x="Region")    
regionplot1    
    
regionplot2 <- ggplot(countregion, aes(x = reorder(region, -count), y = count)) +    
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by Region", y="Total Sightings", x="Region")        
regionplot2   
    
![image](https://user-images.githubusercontent.com/36289126/37190283-42b581b8-2316-11e8-8fcd-b1947917832a.png)  
    
    
### UFO Sightings by State:    
    
countstate <-summary(ufo$State)    
plot(ufo$State, main="UFO Sightings by State", ylab="Total Sightings", xlab="State",col="green")        
    
![image](https://user-images.githubusercontent.com/36289126/37190839-6988439a-2319-11e8-9408-d7989cf70a6e.png)    
    
    
countstate <- as.table(countstate)    
countstate <- as.data.frame(countstate)    
colnames(countstate) <- c("state", "count")    
str(countstate)    
head(countstate)    
summary(countstate)    
    
![image](https://user-images.githubusercontent.com/36289126/37238293-47a4aee0-23e0-11e8-92a1-6aebe183ac91.png)    
    
stateplot1 <- ggplot(countstate, aes(x = state, y = count)) +    
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by State", y="Total Sightings", x="State")    
stateplot1    
    
![image](https://user-images.githubusercontent.com/36289126/37191101-df79c816-231a-11e8-823f-32928dc8c3ae.png)    
    
stateplot2 <- ggplot(countstate, aes(x = reorder(state, -count), y = count)) +    
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by State", y="Total Sightings", x="State")    
stateplot2   
    
![image](https://user-images.githubusercontent.com/36289126/37191287-d886d3f4-231b-11e8-8f15-03ff3d69a023.png)    
    
        
### Sightings per State Relative to State Population:  

I wanted to "normalize" the data relative to state to put some perspective on the number of UFO sightings per state.    
    
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
    
![image](https://user-images.githubusercontent.com/36289126/37191526-74a5014c-231d-11e8-97a5-b4735bb8fa6e.png)    
     
    
countstateplot2 <- ggplot(countstate, aes(x = reorder(state, -propsight), y = propsight)) +    
  geom_bar(stat = "identity",colour="Green")+labs(title="UFO Sightings by State by Population", y="Proportion of Sightings", x="State")  
countstateplot2    
    
![image](https://user-images.githubusercontent.com/36289126/37191616-018a2e02-231e-11e8-8daf-ef81981e2294.png)    
    
### Amount of UFO Sightings Per Day of week:    
ufo$weekday <- factor(weekdays(ufo$Date, T), levels = rev(c("Mon", "Tue", "Wed", "Thu","Fri", "Sat", "Sun")))       
plot(ufo$weekday, xlab="Day of the Week", ylab="Total Sightings", main="UFO Sighting by Day", col = "Green")    
   
![image](https://user-images.githubusercontent.com/36289126/37191769-e7f3f44a-231e-11e8-8721-45cd315b734d.png)   
    
     
### Amount of UFO Sightings Per Decade:    
ufo$year<-as.numeric(format(ufo$Date, "%Y"))    
summary(ufo$year)       
    
![image](https://user-images.githubusercontent.com/36289126/37238320-cd9d2a68-23e0-11e8-98a6-0b8fb4f483df.png)          
   
ufo$decade<- ufo$year - (ufo$year %% 10)    
ufo$decade    
hist(ufo$decade, xlab="Decade", ylab="# of Sightings", main = "UFO Sightings by Decade", col="green")    

![image](https://user-images.githubusercontent.com/36289126/37191852-66baf5da-231f-11e8-8435-c7710c199ee2.png)    
        
ufo$century<- ufo$year - (ufo$year %% 100)    
ufo$century     
hist(ufo$century, xlab="Century", ylab="# of Sightings", main = "UFO Sightings by Century", col = "Green")    
       
![image](https://user-images.githubusercontent.com/36289126/37192012-36da25a6-2320-11e8-8d0a-fe424828cfdd.png)    

### Most Popular Month:
str(ufo$Date)    
ufo$month<-as.factor(format(ufo$Date, "%m"))     
summary(ufo$month)    
    
plot(ufo$month,main="UFO Sightings by Month", ylab="Total Sightings",xlab="Month",col="green")    
       
![image](https://user-images.githubusercontent.com/36289126/37192149-1410c1c8-2321-11e8-8f97-bf0b7e27d9e1.png)    
    
    
ufoDataByMonth <-summary(ufo$month)    
ufoDataByMonth <- as.table(ufoDataByMonth)    
ufoDataByMonth <- as.data.frame(ufoDataByMonth)    
colnames(ufoDataByMonth) <- c("month", "count")    
    
plot(ufoDataByMonth,main="UFO Sightings by Month", ylab="Total Sightings",xlab="Month")    
    
![image](https://user-images.githubusercontent.com/36289126/37192155-1f4473fa-2321-11e8-9162-111c37d9566d.png)    
    

### Calculate avg ufo sightings by month:    
Totalyears = max(ufo$year)-min(ufo$year)    
TotalMonths <-summary(ufo$month)    
TotalMonths <-as.table(TotalMonths)    
TotalMonths= as.data.frame(TotalMonths)    
colnames(TotalMonths) <- c("month", "total")    
TotalMonths$AvgPerMonth <-(TotalMonths$total)/Totalyears    
TotalMonths  
    
![image](https://user-images.githubusercontent.com/36289126/37238198-b7d15648-23de-11e8-9ad1-ecf18cb9f637.png)    
    
        
        
plot(TotalMonths$month,TotalMonths$AvgPerMonth, ylab="Average Sightings",xlab="Month",main="Average UFO Sightings by Month")    
    
![image](https://user-images.githubusercontent.com/36289126/37192477-de39a4e6-2322-11e8-90c0-679b92779234.png)    
    
    
### UFO Descriptions:

countshape <-summary(ufo$Shape)    
countshape    
plot(ufo$Shape)    
    
![image](https://user-images.githubusercontent.com/36289126/37194214-6a8ca464-232a-11e8-811f-cd8428264b1a.png)    
    
countshape <- as.table(countshape)    
countshape <- as.data.frame(countshape)    
colnames(countshape) <- c("shape", "count")    
str(countshape)    
head(countshape)    
shapeplot1 <- ggplot(countshape, aes(x = shape, y = count)) +    
  geom_bar(stat = "identity",colour="Green")    
shapeplot1    
    
![image](https://user-images.githubusercontent.com/36289126/37194585-275dd742-232c-11e8-94e1-ed94c69b91a1.png)    

    
shapeplot2 <- ggplot(countshape, aes(x = reorder(shape, -count), y = count)) +    
  geom_bar(stat = "identity",colour="Green")    
shapeplot2    
    
![image](https://user-images.githubusercontent.com/36289126/37194589-2dce2c30-232c-11e8-8e3f-159b33cbaf28.png)    


### Correlations Matrix:    
(Function borrowed from https://gist.github.com/talegari/b514dbbc651c25e2075d88f31d48057b):
df=ufo[,c(10,5,6,15,3,11,19,16,13,14)]    
    
cor2 = function(df){    
      
  stopifnot(inherits(df, "data.frame"))    
  stopifnot(sapply(df, class) %in% c("integer"    
                                     , "numeric"    
                                     , "factor"    
                                     , "character"))    
      
  cor_fun <- function(pos_1, pos_2){    
        
Both are numeric    
    if(class(df[[pos_1]]) %in% c("integer", "numeric") &&    
       class(df[[pos_2]]) %in% c("integer", "numeric")){    
      r <- stats::cor(df[[pos_1]]    
                      , df[[pos_2]]    
                      , use = "pairwise.complete.obs"    
      )    
    }    
        
One is numeric and other is a factor/character    
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
        
 Both are factor/character    
    if(class(df[[pos_1]]) %in% c("factor", "character") &&    
       class(df[[pos_2]]) %in% c("factor", "character")){    
      r <- lsr::cramersV(df[[pos_1]], df[[pos_2]], simulate.p.value = TRUE)    
    }    
        
    return(r)    
  }     
      
  cor_fun <- Vectorize(cor_fun)    
      
 - Starting to compute corr matrix    
  corrmat <- outer(1:ncol(df)    
                   , 1:ncol(df)    
                   , function(x, y) cor_fun(x, y)    
  )     
      
  rownames(corrmat) <- colnames(df)    
  colnames(corrmat) <- colnames(df)    
      
  return(corrmat)    
}    
cor2(df)    
    
![image](https://user-images.githubusercontent.com/36289126/37194851-6f96ca40-232d-11e8-8851-6276c2716d67.png)    

### Probability - Is it a hoax??  Can I build a model that predicts hoax?   
The dataset came with sightings marked as Hoax.  THe Hoax data was significantly lower when compared to the entire dataset.    
With the large spread I decided to use SMOTE to balance the data.    
    
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
    
The dimension was determiened to be 42000 decided by takking 100/(269Hoax/112652NoHoax) in dataset= ~42000    
    
trainset$Hoax = as.numeric(trainset$Hoax)    
model <- glm(Hoax ~ ., data=trainset)    
summary(model)    
    
pred<-predict.glm(model,testset)   
pred2<- ifelse(c(pred) > 1.37,1,0)    
predict3=as.vector(pred2)    
table(testset$Hoax, predict3)    
Accuracy <-(225276+4400)/(225276+4400+7051+3204)    
Accuracy    
    
[1] 0.9572585    

The model predicted a hoax correctly 95% of the time.    

### World Map Displaying the UFO Sightings:    
    
I borrowed the code from https://www.kaggle.com/mrisdal/animating-ufo-sightings.  I tried using other options by using different packages and I kept getting an error for the version of R I am using.    
    
map <- borders("world", colour = "green", fill="gray66")    
ufo_map <- ggplot(ufo, aes(frame = year)) + map +    
  geom_point(aes(x=Longitude, y=Latitude, color=Shape)) +    
  scale_color_viridis(discrete = TRUE, alpha = 0.75) +     
  theme(legend.position = "none")    
ufo_map    
    
![image](https://user-images.githubusercontent.com/36289126/37238150-6f64e2b8-23dd-11e8-8a44-51ba1f00abea.png)    


## Analysis results

In order to determine where the most reported UFO sightings occur?  I analyzed the UFO sightings by Region and by state.  
The data revealed the following amount of UFO sightings:
- Alaska = 519    
- Canada = 4,727    
- International = 8,084    
- States = 99,480    
    
From the models above it is clear to me that the most reported UFO sightings occur in the United States.  But, this may be due to other regions not being aware of the NUROC site?  Within the United States the most reported UFO sightings is in California (13,024 sightings), but that may be due to the sheer size of the state.  So, I adjusted the model to account for the different population sizes of each state.  This adjustment revealed that Washington is the new leader and has the largest reported UFO sightings.    

Next, I discovered the most popular time of the year that UFO sightings were reported is in July on a Saturday at night.  July has an average of 136 sightings versus February that only has an average of 66 reported sightings.  Additionally, not surprisingly, the reported UFO sightings increased in each decade with an exception in 1980.   
    
The data also revealed the top three most frequently sighted UFO shapes to be:
- Light (24,356)    
- Circle (11,687)    
- Triangle (10,628)    
    
Were you expecting flying saucer?  Well, nope!  if you think about it the data makes sense.  Since the most reported UFO sightings are reported at night it is in line that the most popular shape reported is a light formation.  As we know it is dark at night, and the darkness can explain that pepole are seeing the lights but not having a clear view of the shape.    

Additionally, I wanted to test the correlations between variables and see if any of them impacted one another.  The strongest correlations were between longitude and year and latitude and longitude.  This is information did not excite me.  So moving on, the dataset had clear notes of potential hoax claims flagged by the NUFORC organization.  I wanted to dig a little further into this and build a model for hoax prediction.   Only .002% of the dataset had any sightings flagged as a hoax.  In order to handle this imbalance in the dataset I used the SMOTE method.  The final model I created predicted a hoax correctly 95% of the time.  What I also found interesting about this model is almost every variable was significant in the model.  
   
Lastly, I wanted to place the reported UFO sightings on a map for all the visual learners out there.  From the map a few patterns were notable.  First, in Russia there is a clear straight line of reported sightings making me wonder if that is a major highway.  I also found it interesting that with one of the largest populations in the world, China, did not have more reported sightings.  Either the United States is under high survelliance or we like reporting anything we see in the skies as a UFO.  

Thank you!    
