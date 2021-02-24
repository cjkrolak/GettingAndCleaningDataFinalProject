---
title: "Readme"
author: "Christopher Krolak"
date: "2/24/2021"
output: html_document
---

# GettingAndCleaningData final project

[course web page](https://www.coursera.org/learn/data-cleaning/home/welcome)<br/>
[assignment web page](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project)<br/>

# Automated Script: 'run_analysis.R'
All of this data reduction is automated in the script "run_analysis.R".  To execute, do the following:<br/>
1.  import script: source("run_analysis.R")<br/>
2.  run script: main()<br/>

# Resulting global objects:
**mergedData** = merged and reduced data set of 10299 observations (rows) and 81 variables (columns)<br/>
**tidyData** = summarized data with 40 observations (rows) and 81 variables.  Each row is a group mean by subject and activity.<br/>


# Resulting data file:
**tidyData.txt** is the summarized data file, it will be in your working directory.<br/>