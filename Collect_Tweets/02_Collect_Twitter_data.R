### Brazilian and Latin American Population Conference
### Workshop on Web and Social Media for Demographic Research  
### October 17, 2016
### Emilio Zagheni
### Collect and Analyze Tweets
### Part 2 Collect Tweets using the streaming API and get descriptive statistics
### This part relies on packages and some functions written by Pablo Barbera

#check the directory where you are  
getwd()
## If you are not in the the folder "Collect_Tweets", move to that folder
## using
## setwd("YOUR_PATH_TO_THE_FOLDER")

##Install the packages below and their dependecies (if you have not installed them yet)
## e.g. 
##install.packages(streamR, dependencies=TRUE) 
library(streamR)
library(ROAuth)
source('functions_by_pablobarbera.R')


load("twitCred.Rdata")


####
## COLLECTING A RANDOM SAMPLE OF TWEETS 
####

sampleStream("data/tweets_random.json", timeout = 20, 
             oauth = twitCred)


tweets <- parseTweets("data/tweets_random.json", verbose = FALSE)

names(tweets)
head(tweets)

##language of tweets
table(tweets$lang)


##Which of these tweets has received more retweets?
tweets$retweet_count
max(tweets$retweet_count)

## "which" would give us the index for the tweet that satisfies our request
which(tweets$retweet_count == max(tweets$retweet_count))

##tweet with the highest number of retweets
tweets$text[which(tweets$retweet_count == max(tweets$retweet_count))]

##name of the user who posted the tweet
tweets$screen_name[which(tweets$retweet_count == max(tweets$retweet_count))]
## when the tweet was posted
tweets$created_at[which(tweets$retweet_count == max(tweets$retweet_count))]


##Which of these tweets was sent by the person with more followers?
max(tweets$followers_count)

which(tweets$followers_count == max(tweets$followers_count))

tweets$text[which(tweets$followers_count == max(tweets$followers_count))]


## find the most common hashtags 
getCommonHashtags(tweets$text, n=50)


#####
## COLLECTING A RECENT SET OF TWEETS FROM A USER
#####

getTimeline(file.name="data/tweets_UW.json", screen_name="UW", n=1000, oauth=twitCred)

tweets_UW <- parseTweets("data/tweets_UW.json")

names(tweets_UW)
head(tweets_UW)













