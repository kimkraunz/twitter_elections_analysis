library(ggplot2)
library(chron)
library(dplyr)
library(sm)
library(gridExtra)

df_tweets <- read.csv(paste(getwd(), "/data_incubator/twitter_summary.csv", sep = ""), header = TRUE, stringsAsFactors = FALSE)

# Plots All tweets vs Original tweets
p1 <- ggplot(df_tweets, aes(x = w_retweets, y = wo_retweets, color=factor(party))) + geom_point() + geom_text(aes(label=Candidate), hjust = 1.0, vjust = 1.5) + ggtitle("All tweets vs. original tweets by Presidential\ncandidates on 10/28 (Republican debate)") + scale_x_continuous("Tweets (including retweets)")  +  scale_y_continuous("Original tweets")  + stat_smooth(method = 'lm', aes(colour = 'linear'), se = TRUE) + scale_color_manual(values=c("blue", "black", "firebrick")) + theme(plot.title = element_text(size = 20, lineheight=.8, face="bold"))
p1

# Remove Hillary and Bernie
tweets.republ.df <- subset(df_tweets, subset = Candidate != "Clinton" & Candidate != "Sanders")

p2 <- ggplot(tweets.republ.df, aes(x = w_retweets, y = wo_retweets)) + geom_point() + geom_text(aes(label=Candidate), hjust = 1.0, vjust = 1.5, colour = "firebrick") + ggtitle("All tweets vs. original tweets by Republican\ncandidates on 10/28 (Republican debate)") + scale_x_continuous("Tweets (including retweets)") + scale_y_continuous("Original tweets")  + stat_smooth(method = 'lm',  se = TRUE, colour = "black") + theme(plot.title = element_text(size = 20, lineheight=.8, face="bold"))
p2




df_tweets <- read.csv(paste(getwd(), "/data_incubator/twitter_no_retweets.csv", sep = ""), header = TRUE, stringsAsFactors = FALSE)

# Change hashtag to a factor
df_tweets$hashtag <- as.factor(df_tweets$hashtag)

# Change created to a date variable with timezone matching the debate time zone
df_tweets$created <- as.POSIXct(df_tweets$created, tz="Europe/London")
df_tweets$created <- format(df_tweets$created, tz="America/Denver",usetz=TRUE)
df_tweets$created <- as.POSIXct(df_tweets$created, tz="America/Denver")

# Limit time created to 6 hours before debate and 2 hours after
df_tweets <- subset(df_tweets, (created >= as.POSIXct('2015-10-28 12:00')))
df_tweets <- subset(df_tweets, (created <= as.POSIXct('2015-10-28 22:00')))

# Get frequency counts of original tweets by hashtag
tweets = table(df_tweets$hashtag)
as.data.frame(tweets)

# Limit dataset to Carson (rising), Christie (stalling), Cruz (good performance ratings), Hillary (for Democratic comparison), Bush (stalling), Rubio (rising?), Paul (high # of tweets), Trump (reported winner)
limited.tweets.df <- subset(df_tweets , subset = hashtag == "#Trump2016" | hashtag == "#CruzCrew" |  hashtag == "#standwithrand" | hashtag == "#BC2DC16" | hashtag == "#MarcoRubio" | hashtag == "#CarlyFiorona"| hashtag == "#Hillary2016"| hashtag == "#Christie2016" | hashtag == "#jebbush")

# Create plot histogram line graph of tweet count by hour
p2 <- ggplot(data=limited.tweets.df, aes(x=created)) 
p2 + geom_line(aes(group = hashtag, colour = hashtag), stat="bin", binwidth=3600) + scale_x_datetime("Time") + scale_y_continuous("Tweets") + ggtitle("Original tweets with candidate hashtags\nduring Republican debate (10/28)") + theme(plot.title = element_text(size = 20, lineheight=.8, face="bold"))
