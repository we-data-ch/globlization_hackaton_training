# Libraries ----
pacman::p_load(tidyverse, plotly, dlookr, 
               tidytext,
               FactoMineR, factoextra,
               tictoc, recipes)

# Options ----
theme_set(theme_bw())

# Data ----
## Hashtag data
hashtag <- read_rds("Data/hashtags.rds")
tweets <- read_rds("Data/tweets.rds")
days <- read_rds("Data/days.rds")

the_dates <- 
  days %>% 
  distinct(id, date) %>% 
  pull(date)

(
  df_embed <-
    read_rds("Data/df_embed.rds") %>% 
    mutate(date = the_dates,
           .before = 1) %>% 
    column_to_rownames("date")
  )

# New HCPC ~30sec/~24sec
tic()
my_hcpc <- HCPC(df_embed, nb.clust = -1, 
                graph = FALSE, 
                nb.par = 10)
toc()

fviz_cluster(my_hcpc)

c1 <- my_hcpc$desc.ind$para$`1` %>% names()
c2 <- my_hcpc$desc.ind$para$`2` %>% names()
c3 <- my_hcpc$desc.ind$para$`3` %>% names()

c1
c2
c3

df_clust <- 
  my_hcpc$data.clust %>% 
  # tibble() %>% 
  select(-starts_with("dim")) %>% 
  rownames_to_column("date") %>% 
  tibble() %>% 
  mutate(date = as_date(date))
  
tweets_clust <- 
  tweets %>%
  left_join(df_clust)

write_rds(tweets_clust, file = "Data/tweets_clust.rds")

# CLuster description
words_clust <- 
  tweets_clust %>% 
  select(clust, tweet) %>% 
  unnest_tokens("words", "tweet") %>% 
  anti_join(tibble(words = stopwords::data_stopwords_stopwordsiso$fr)) %>% 
  filter(!str_detect(words, "\\d+|\\.|\\,|https?|\\_|aa"))
  
words_clust %>% 
  mutate(words = str_remove(words, "\\w(’|')")) %>% 
  group_by(clust) %>% 
  count(words, sort = TRUE) %>% 
  filter(n > 5) %>% 
  bind_tf_idf(words, clust, n) %>% 
  top_n(tf_idf, n = 10) %>% 
  ungroup() %>% 
  ggplot(aes(reorder_within(words, tf_idf, clust), tf_idf, fill = clust)) +
  geom_col() +
  scale_x_reordered() +
  facet_wrap(~clust, scales = "free") +
  coord_flip() +
  labs(title = "TF-IDF des termes par cluster journalier",
       x = NULL, y = NULL)

# Topic 1: Champs lexical de la culture
# Topic 2: ???
# Topic 3: CHamps lexical de l'économie
