# Libraries ----
pacman::p_load(tidyverse, plotly, dlookr, 
               tidytext, syuzhet, stopwords,
               FactoMineR, factoextra)

# Options ----
theme_set(theme_bw())

# Data ----
## Hashtag data
hashtag <- read_rds("Data/days.rds")
tweets <- read_rds("Data/tweets.rds")
days <- read_rds("Data/days.rds")

## Tweets
id_days <- 
  days %>% 
  mutate(new_id = 1:nrow(.),
         .before = id) %>% 
  select(new_id, id)

days_tf_idf <- 
  days %>% 
  mutate(new_id = 1:nrow(.),
         .before = id) %>% 
  select(new_id, tweet) %>% 
  mutate(tweet = str_remove_all(tweet, "https?.*$|https?|t.co")) %>% 
  unnest_tokens("words", "tweet", drop = TRUE) %>% 
  filter(!words %in% stopwords("fr", "stopwords-iso"),
         !str_detect(words, "\\_|[0-9]|\\.|\\,")) %>% 
  group_by(new_id) %>% 
  count(words, sort = TRUE) %>% 
  filter(n > 5) %>% 
  ungroup() %>% 
  bind_tf_idf(term = words, document = new_id, n = n)

my_matrix <- 
  days_tf_idf %>% 
  select(new_id, words, val = n) %>% 
  spread(words, val, fill = 0) %>%  
  column_to_rownames("new_id")

my_pca <-
  my_matrix %>% 
  PCA()

# my_pca$ind$coord

my_hcpc <- HCPC(my_pca, nb.clust = 5)

cluster_a <- fviz_cluster(my_hcpc)

ggplotly(cluster_a)

days_tf_idf %>% 
  count(new_id, sort = TRUE)


period_sum <- 
  days %>% 
  mutate(new_id = 1:nrow(.),
         .before = id) %>% 
  select(date, new_id) %>% 
  left_join(days_tf_idf) %>% 
  drop_na() %>% 
  mutate(week = floor_date(date, unit = "weeks"),
         month = floor_date(date, unit = "months"),
         .after = date)


period_sum %>% 
  summarise(n = sum(n),
            .by = week) %>% 
  filter(n < 100) %>% 
  ggplot(aes(n)) +
  geom_histogram()


  period_sum %>% 
  summarise(n = sum(n),
            .by = month) %>% 
  ggplot(aes(n)) +
    geom_histogram()

