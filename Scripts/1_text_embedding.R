# NOTE: Take 1 hour to run due to text embedding
  # Specs: GPU: 19.9Go - NVIDIA GeForce RTX 3060

# Libraries ----
library(rollama)

# Data ----
days <- read_rds("Data/days.rds")

# rollama (last model)
  # Here: Llama3
pull_model()

# Embeding
  # Create a tibble (dataframe)
df_embed <- embed_text(days$tweet)

# Save it
write_rds(df_embed, file = "Data/df_embed.rds")