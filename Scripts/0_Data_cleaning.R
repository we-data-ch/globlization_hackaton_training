# Libraries ----
pacman::p_load(tidyverse)

# Data ----
# Tweet dataset
read_csv("Data/20min_fr.csv") %>% 
  write_rds("Data/tweets.rds")

# days dataset
read_csv("Data/20min_fr.csv") %>% 
  select(id, date, time, tweet, 
         replies_count, retweets_count, 
         likes_count, hashtags, retweet) %>%
  mutate(tweets_count =  1) %>% 
  summarise(
    id = str_c(id, collapse = newline),
    time = str_c(time, collapse = newline),
    tweet = str_c(tweet, collapse = newline),
    replies_count = sum(replies_count),
    retweets_count = sum(retweets_count),
    likes_count = sum(likes_count),
    hashtags = str_c(hashtags, collapse = newline),
    retweet = sum(retweet),
    tweets_count = sum(tweets_count),
    .by = date
  ) %>% 
  mutate(retweet_proportion = round(retweet/tweets_count, 2)) %>% 
  write_rds("Data/days.rds")

# hashtags dataset
read_csv("Data/20min_fr.csv") %>% 
  select(id, date, hashtags) %>% 
  filter(hashtags != "[]") %>% 
  mutate(hashtags = str_remove_all(hashtags, "\\[|\\]|\\,|\\'")) %>% 
  separate_rows(hashtags, sep = "\\s") %>% 
  filter(hashtags != "") %>% 
  write_rds("Data/hashtags.rds")
