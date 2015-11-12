# Using twitter to analyze the popularity of Presidential candidates

I've been scraping fantasy football weekly projection websites with R and gaining regex skills in manipulating the data.  My next step was to take on Twitter and do some exporatory analysis.

It actually took me a while to get tweets using the Twitter API.  For some reason, everytime I tried to login I would get an error that my keys and tokens were not authorized.  After spending too much time on it, I decided to hack my husband's account and create a new development account within his account.  Problem solved!  It is still unknown why I couldn't get my development account to work.

```library("devtools")
library("twitteR")
library("rjson")
library("bit64")
library("httr")
library("ggplot2")

api_key <- "<my api_key>"
api_secret <- "<my api_secret>"
access_token <- "<my access_token>"
access_token_secret <- "<my access_token_secret>"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)```

I used the most popular hashtags that I identified for each Presidential candidate, with the exception of Ben Carson, who seemed to be promoting two hashtags (#bencarson, #BC2DC16).  I grabbed the tweets with the hashtags using the twitteR library in R.

I compared all tweets (including retweets) vs. original tweets (no retweets) for all Presidential candidates.  I wanted to see whether the proportions were different for the different candidates.

![Tweets](https://github.com/kimkraunz/twitter_elections_analysis/blob/master/Tweet_vs_retweet.png)
