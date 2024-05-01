


### Data Import 
dr <- read_csv("Data/20min_fr.csv",col_types = cols(
  id = col_character(),
  conversation_id = col_double(),
  created_at = col_character(),
  date = col_date(format = ""),
  time = col_time(format = ""),
  timezone = col_double(),
  user_id = col_double(),
  username = col_character(),
  name = col_character(),
  place = col_logical(),
  tweet = col_character(),
  language = col_character(),
  mentions = col_character(),
  urls = col_character(),
  photos = col_character(),
  replies_count = col_double(),
  retweets_count = col_double(),
  likes_count = col_double(),
  hashtags = col_character(),
  cashtags = col_character(),
  link = col_character(),
  retweet = col_logical(),
  quote_url = col_logical(),
  video = col_double(),
  thumbnail = col_character(),
  near = col_logical(),
  geo = col_logical(),
  source = col_logical(),
  user_rt_id = col_logical(),
  user_rt = col_logical(),
  retweet_id = col_logical(),
  reply_to = col_character(),
  retweet_date = col_logical(),
  translate = col_logical(),
  trans_src = col_logical(),
  trans_dest = col_logical()
)
)


df <- dr %>% 
  select(replies_count,
         retweets_count,
         likes_count,
         retweet,
         tweet) %>% 
  mutate( likes_count_score = likes_count/max(likes_count),
          replies_count_score = replies_count/max(replies_count),
          retweets_count_score = retweets_count/max(retweets_count),
          controversial_score  = likes_count_score*.08 + replies_count_score *.8 + retweets_count_score * .09,
          ratio  = likes_count/replies_count ,
          score  = replies_count/(likes_count+retweets_count+1) ) %>% 
  dplyr::filter(!(likes_count  == 0 |replies_count == 0| retweets_count == 0 | controversial_score == 0 | is.nan(ratio) ))
