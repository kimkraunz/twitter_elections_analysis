
library("devtools")
library("twitteR")
library("rjson")
library("bit64")
library("httr")
library("ggplot2")

api_key <- "t7EraVUUaJa2Z462BNHu4frWe"
api_secret <- "Qjt7QP4eHsQ3uD6x2RDDxSYvUL6aJbgbO5UPCHQigSBEUQg0x8"
access_token <- "2165066318-PVpl6l1fLcdopmLblHmnPSGmpe6FUqdzomJf4bw"
access_token_secret <- "XJHZcmsaSIQjYzK15Q3wVKFVCnUtHCu3YcUfuOReZZdls"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

Bush = searchTwitter("#jebbush", n = 10000, since = "2015-10-28", until = "2015-10-29")
Carson = searchTwitter("#bencarson OR #bc2dc16", n = 50000, since = "2015-10-28", until = "2015-10-29")
Christie = searchTwitter("#Christie2016", n=10000, since = "2015-10-28", until = "2015-10-29")
Clinton = searchTwitter("#Hillary2016", n = 50000, since = "2015-10-28", until = "2015-10-29")
Cruz = searchTwitter("#CruzCrew", n = 50000, since = "2015-10-28", until = "2015-10-29")
Fiorina = searchTwitter("#CarlyFiorina", n = 10000, since = "2015-10-28", until = "2015-10-29")
Graham = searchTwitter("#LindseyGrahamSC", n = 10000, since = "2015-10-28", until = "2015-10-29")
Huckabee = searchTwitter("#Huckabee", n = 10000, since = "2015-10-28", until = "2015-10-29")
Jindal = searchTwitter("#bobbyjindal", n = 10000, since = "2015-10-28", until = "2015-10-29")
Kasich = searchTwitter("#kasich", n = 10000, since = "2015-10-28", until = "2015-10-29")
Pataki = searchTwitter("#Pataki", n = 10000, since = "2015-10-28", until = "2015-10-29")
Paul = searchTwitter("#standwithrand", n = 30000, since = "2015-10-28", until = "2015-10-29")
Rubio = searchTwitter("#MarcoRubio", n = 30000, since = "2015-10-28", until = "2015-10-29")
Sanders = searchTwitter("#FeeltheBern", n = 50000, since = "2015-10-28", until = "2015-10-29")
Santorum = searchTwitter("#RickSantorum", n = 10000, since = "2015-10-28", until = "2015-10-29")
Trump = searchTwitter("#Trump2016", n = 50000, since = "2015-10-28", until = "2015-10-29")

Bush_nr = strip_retweets(Bush)
Carson_nr = strip_retweets(Carson)
Christie_nr = strip_retweets(Christie)
Clinton_nr = strip_retweets(Clinton)
Cruz_nr = strip_retweets(Cruz)
Fiorina_nr = strip_retweets(Fiorina)
Graham_nr = strip_retweets(Graham)
Huckabee_nr = strip_retweets(Huckabee)
Jindal_nr = strip_retweets(Jindal)
Kasich_nr = strip_retweets(Kasich)
Pataki_nr = strip_retweets(Pataki)
Paul_nr = strip_retweets(Paul)
Rubio_nr = strip_retweets(Rubio)
Sanders_nr = strip_retweets(Sanders)
Santorum_nr = strip_retweets(Santorum)
Trump_nr = strip_retweets(Trump)


Bush.df <- twListToDF(Bush_nr)
Carson.df <- twListToDF(Carson_nr)
Christie.df <- twListToDF(Christie_nr)
Clinton.df <- twListToDF(Clinton_nr)
Cruz.df <- twListToDF(Cruz_nr)
Fiorina.df <- twListToDF(Fiorina_nr)
Graham.df <- twListToDF(Graham_nr)
Huckabee.df <- twListToDF(Huckabee_nr)
Jindal.df <- twListToDF(Jindal_nr)
Kasich.df <- twListToDF(Kasich_nr)
Paul.df <- twListToDF(Paul_nr)
Pataki.df <- twListToDF(Pataki_nr)
Rubio.df <- twListToDF(Rubio_nr)
Sanders.df <- twListToDF(Sanders_nr)
Santorum.df <- twListToDF(Santorum_nr)
Trump.df <- twListToDF(Trump_nr)

Bush.df$hashtag <- as.factor("#jebbush")
Carson.df$hashtag <- as.factor("#bencarson or #bc2dc16")
Christie.df$hashtag <- as.factor("#Christie2016")
Clinton.df$hashtag <- as.factor("#Hillary2016")
Cruz.df$hashtag <- as.factor("#CruzCrew")
Fiorina.df$hashtag <- as.factor("#CarlyFiorina")
Graham.df$hashtag <- as.factor("#LindseyGrahamSC")
Huckabee.df$hashtag <- as.factor("#Huckabee")
Jindal.df$hashtag <- as.factor("#bobbyjindal")
Kasich.df$hashtag <- as.factor("#Kasich")
Pataki.df$hashtag <- as.factor("#Pataki")
Sanders.df$hashtag <- as.factor("#FeeltheBern")
Santorum.df$hashtag <- as.factor("#RickSantorum")
Paul.df$hashtag <- as.factor("#standwithrand")
Rubio.df$hashtag <- as.factor("#MarcoRubio")
Trump.df$hashtag <- as.factor("#Trump2016")

df <- rbind(Christie.df, Carson.df, Fiorina.df, Clinton.df, Huckabee.df, Kasich.df, Pataki.df, Graham.df, Jindal.df, Santorum.df, Bush.df, Cruz.df, Rubio.df, Paul.df, Trump.df, Sanders.df)

save(df, file = paste(getwd(), "/data_incubator/twitter_no_retweets.RData", sep=""))
write.csv(df, file=paste(getwd(), "/data_incubator/twitter_no_retweets.csv", sep=""), row.names=FALSE)

# Change created to a date variable with timezone matching the debate time zone
df$created <- as.POSIXct(df$created, tz="Europe/London")
df$created <- format(df$created, tz="America/Denver",usetz=TRUE)
df$created <- as.POSIXct(df$created, tz="America/Denver")

# Limit time created to 6 hours before debate and 2 hours after
df <- subset(df_tweets, (created >= as.POSIXct('2015-10-28 12:00')))
df <- subset(df_tweets, (created <= as.POSIXct('2015-10-28 22:00')))

# Create data frame of counts of original tweets and all tweets by candidate and party
df_tweets <- cbind(c("Bush", "Carson", "Christie", "Fiorina", "Graham", "Huckabee", "Jindal", "Kasich", "Pataki", "Santorum", "Trump", "Sanders", "Rubio", "Cruz", "Paul", "Clinton"), c(length(Bush), length(Carson), length(Christie), length(Fiorina), length(Graham), length(Huckabee), length(Jindal), length(Kasich), length(Pataki), length(Santorum), length(Trump), length(Sanders), length(Rubio), length(Cruz), length(Paul), length(Clinton)), c(nrow(Bush.df), nrow(Carson.df), nrow(Christie.df), nrow(Fiorina.df), nrow(Graham.df), nrow(Huckabee.df), nrow(Jindal.df), nrow(Kasich.df), nrow(Pataki.df), nrow(Santorum.df), nrow(Trump.df), nrow(Sanders.df), nrow(Rubio.df), nrow(Cruz.df), nrow(Paul.df), nrow(Clinton.df)), c("Republican", "Republican","Republican","Republican","Republican","Republican","Republican","Republican","Republican","Republican","Republican","Democrat", "Republican","Republican","Republican","Democrat"))

df_tweets <- as.data.frame(df_tweets, stringsAsFactors=FALSE)
colnames(df_tweets) <- c("Candidate", "w_retweets", "wo_retweets", "party")
df_tweets$w_retweets <- as.numeric(df_tweets$w_retweets)
df_tweets$wo_retweets <- as.numeric(df_tweets$wo_retweets)

save(df, file = paste(getwd(), "/data_incubator/twitter_summary.RData", sep=""))
write.csv(df, file=paste(getwd(), "/data_incubator/twitter_summary.csv", sep=""), row.names=FALSE)
