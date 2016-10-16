### Brazilian and Latin American Population Conference
### Workshop on Web and Social Media for Demographic Research  
### October 17, 2016
### Emilio Zagheni
### Collect and Analyze Tweets
### Part 3: Extract the URL for the profile picture of Twitter users

#check the directory where you are  
getwd()
## If you are not in the the folder "Collect_Tweets", move to that folder
## using
## setwd("YOUR_PATH_TO_THE_FOLDER")

library(rjson)
library(RCurl)

## Read in some Twitter data that you (or someone else) have collected.
## The data would be in json format
## each line is one tweet

data <- readLines("data/tweets_random.json") 

nof_lines <- length(data)
nof_lines

## Apply the function "fromJSON" to each line, one at a time
## to read in the json file and store it as a list
data.list<-lapply(data,function(x) fromJSON(x))


data.list[[1]]

data.list[[1]]$user$profile_image_url

data.list[[10]]$user$profile_image_url


