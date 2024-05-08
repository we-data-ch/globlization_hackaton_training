# Libraries ----
pacman::p_load(tidyverse, plotly, dlookr, 
               tidytext,
               FactoMineR, factoextra,
               tictoc)

# Options ----
theme_set(theme_bw())

# Data ----
## Hashtag data
hashtag <- read_rds("Data/hashtags.rds")
tweets <- read_rds("Data/tweets.rds")
days <- read_rds("Data/days.rds")
df_embed <- read_rds("Data/df_embed.rds")

# New PCA ~30sec
tic()
my_pca <- PCA(df_embed)
toc()

# New HCPC ~30sec
tic()
my_hcpc <- HCPC(my_pca, nb.clust = 5)
toc()

fviz_cluster(my_hcpc)
