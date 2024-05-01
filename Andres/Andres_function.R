
df <- dr %>% 
  select(replies_count,
         retweets_count,
         likes_count,
         retweet,
         tweet,
         link,
         urls,
         date) %>% 
  mutate( likes_count_score = likes_count/max(likes_count),
          replies_count_score = replies_count/max(replies_count),
          retweets_count_score = retweets_count/max(retweets_count),
          controversial_score  = likes_count_score*.08 + replies_count_score *.8 + retweets_count_score * .09,
          ratio  = likes_count/replies_count ,
          score  = (replies_count/(likes_count+retweets_count+1))) %>% 
  dplyr::filter(!(likes_count  == 0 |replies_count == 0| retweets_count == 0 | controversial_score == 0 | is.nan(ratio) ))


df <- df %>% 
  mutate( tweet_content = str_replace_all(tweet, "https:\\/\\/t.co\\/[a-zA-Z0-9]+", "")) %>% 
  filter( likes_count >= 10) %>% 
  mutate( 
    url = paste0("<a href=",urls,">","link","</a>"),
    url_tweeter =  paste0("<a href=",link,">","link","</a>")
  )  %>% 
  select(date,score,likes_count,replies_count,tweet_content,url_tweeter) %>% 
  dplyr::arrange(desc(score)) 
