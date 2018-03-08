## ANALYZING UFO SIGHTINGS

This dataset contains over 112,000 reports of UFO sightings dating back to 1939.

## Description

This project for my Data Science practicum I. I collected the UFO Sightings data by scraping the datapoints from the NUFORC website (http://www.nuforc.org/).  The reporting center collects data with an online form or through a hotline number.  

My inspiration was to answer the following questions:
  •	Geography - Where do UFO sightings occur the most?
  •	Seasonality - Is there a popular time during the year that UFO sightings happen?
  •	Consistency - Are there frequently used descriptions in the 'shapes' section?
  •	Probability - Statistically, build a model that predicts a hoax correctly
  •	Visually - Build a model that displays UFO sightings on a map

## Observations on the quality of the data

The UFO data is by far the most badly formatted data I have worked with and I underestimated the amount of time it would take to get this dataset in working order.  The data form used to enter the UFO sightings should contain only dropdown menu options, but unfortunately the dropdown menu option was only used for 2 out of 11 main questions.  This led to very inconsistent data gathering! The shear amount of data made it difficult to format the data into a single format.  The variation of the defining time values was so great that one small change in code led to wide variations in accuracy.  The locations listed in the records just had a county name others distances and locations outside of known locations. Additionally, all the questions in the data entry form are not mandatory and therefore this led to many data records being incomplete.

## Exploratory Data Analysis (EDA):

I completed this project using R.  I was struggling with cleaning the data in R because of the inconsistancy in each column.  Therefore, I did a majority of cleaning in Excel.  The data categories are Date, Time, City, State, UFO Description, Comments, Coordinates

## Models, Analysis, Tools/Libraries used:

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
