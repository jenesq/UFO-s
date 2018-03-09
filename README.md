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

The UFO data is by far the most badly formatted data I have worked with and I underestimated the amount of time it would take to get this dataset in working order.  The data form used to enter the UFO sightings should contain only dropdown menu options, but unfortunately the dropdown menu option was only used for 2 out of 11 main questions.  This led to very inconsistent data gathering! The shear amount of data made it difficult to format the data into a single format.  The variation of the defining time values was so great that one small change in code led to wide variations in accuracy.  The locations listed in the records just had a county name others distances and locations outside of known locations. Additionally, all the questions in the data entry form are not mandatory and therefore this led to many data records being incomplete.

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

Checking the variables as factors:    

head(ufo)    
summary(ufo)    
   
## Models, Analysis, Tools/Libraries used:

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
       
Amount of UFO Sightings by Region:    
    
countregion <-summary(ufo$Region)    
plot(ufo$Region, main="UFO Sightings by Region", ylab="Total Sightings", xlab="Region",col="green")   
    
![image](https://user-images.githubusercontent.com/36289126/37189951-38ab56ae-2314-11e8-934b-db52a2b205f2.png)    

    


countregion <- as.table(countregion)    
countregion <- as.data.frame(countregion)    
colnames(countregion) <- c("region", "count")    
str(countregion)  
    
    'data.frame':	4 obs. of  2 variables:    
 $ region: Factor w/ 4 levels "Alaska","Canada",..: 1 2 3 4    
 $ count : int  519 4727 8084 99480    
     
     
head(countregion)    
    
         region count    
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
    
    
UFO Sightings by state    
    
countstate <-summary(ufo$State)    
plot(ufo$State)    
    
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
    
sightings per state relative to state population:    
    
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
    

   
   
   
## Analysis results

## Conclusion 


Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/jenesq/UFO-s/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
