#----------------------------------------------------------------------------------
# Obtaining Facebook data using Rfacebook and SocialMediaLab
#
# Charles Lanfear - clanfear@uw.edu
# University of Washington, Department of Sociology
#----------------------------------------------------------------------------------

#----------------------------------------------------------------------------------
# 1) R Setup
#----------------------------------------------------------------------------------

#check the directory where you are  
getwd()
## If you are not in the the folder "Collect_Facebook_Pages", move to that folder
## using
## setwd("YOUR_PATH_TO_THE_FOLDER")


install.packages("SocialMediaLab")
install.packages("Rfacebook")
install.packages("plyr")
install.packages("stringr")
install.packages("dplyr")
install.packages("igraph") 

library(SocialMediaLab)
library(Rfacebook)
library(plyr)
library(stringr)
library(dplyr, pos=99) # dplyr and igraph in high position to avoid masking plyr.
library(igraph, pos=100)

#----------------------------------------------------------------------------------
# 2) Facebook Authentication 
#----------------------------------------------------------------------------------

fb.appid     <- "APPID GOES HERE"
fb.appidsecret <- "APP SECRET GOES HERE"


fb_oauth <- AuthenticateWithFacebookAPI(appID = fb.appid,
                                        appSecret = fb.appidsecret, 
                                        extended_permissions = FALSE, # Public Info
                                        useCachedToken = TRUE)     # Use existing


#----------------------------------------------------------------------------------
# 3) Collecting Data with Rfacebook
#----------------------------------------------------------------------------------

# Collecting Posts from Public Pages

iussp.page.df <- getPage(page="IUSSP",  # Takes page ID or page name
                         token=fb_oauth,   # OAuth token
                         n=25,             # Number of posts to return
                         since=NULL,       # Date of earliest posts returned
                         until=NULL,       # Date of latest posts returned
                         feed=TRUE)        # T/F: Return posts by page non-owners

#write.csv(iussp.page.df,"./Files/data/iussp_FBpage.csv")
#iuss.page.df<- read.csv("./Files/data/iussp_FBpage.csv")

names(iussp.page.df) # Get names of returned columns
head(iussp.page.df) # Take a peek at the data



#----------------------------------------------------------------------------------
# 4) Sentiment Analysis 
#----------------------------------------------------------------------------------

trump.page.df    <- getPage("DonaldTrump", fb_oauth, n=10, feed=TRUE)
clinton.page.df  <- getPage("hillaryclinton", fb_oauth, n=10, feed=TRUE)

#write.csv(trump.page.df,"./Files/data/trump_FBpage.csv")
#write.csv(clinton.page.df,"./Files/data/clinton_FBpage.csv")
#trump.page.df<- read.csv("./Files/data/trump_FBpage.csv")
#clinton.page.df<- read.csv("./Files/data/clinton_FBpage.csv")

source("./Files/sentiment.r") # Script/function for sentiment analysis. Author: Jeffrey Breen

pos <- readLines("./Files/opinion_lexicon/positive_words.txt") # Positive words
neg <- readLines("./Files/opinion_lexicon/negative_words.txt") # Negative words

# Let's see what sort of words are "positive" or "negative".
sample(pos, size=9)
sample(neg, size=9)

clinton.ss <- score.sentiment(sentence  = clinton.page.df$message, # Text to score
                              pos.words = pos,                   # Positive words
                              neg.words = neg)$score             # Negative words

trump.ss   <- score.sentiment(trump.page.df$message, pos, neg)$score

st.err <- function(x){ return( sd(x) / sqrt( length(x) ) ) } # Standard error

data.frame(Mean=c(mean(clinton.ss), mean(trump.ss)),
           SE=c(st.err(clinton.ss), st.err(trump.ss)),
           row.names=c("Clinton", "Trump"))

#----------------------------------------------------------------------------------
# 5) Searching for Pages
#----------------------------------------------------------------------------------

demography.search.df <- searchPages("Demography", fb_oauth, n=20)

#write.csv(demography.search.df,"./Files/data/demography_search_pages.csv")
#demography.search.df <- read.csv("./Files/data/demography_search_pages.csv")


# What sort of values do we get?
names(demography.search.df)

# Let's see what pages we found.
demography.search.df$name

#----------------------------------------------------------------------------------
# 6) Basic Network Data with SocialMediaLab
#----------------------------------------------------------------------------------

trump.network.df <- CollectDataFacebook(pageName="DonaldTrump",
                                        rangeFrom="2016-10-01",
                                        rangeTo="2016-10-03",
                                        writeToFile=FALSE,
                                        verbose=TRUE,
                                        n=5)



#write.csv(trump.network.df,"./Files/data/trump_network.csv")
#trump.network.df <- read.csv("./Files/data/trump_network.csv")

head(trump.network.df)


