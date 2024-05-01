
library(tidyverse)
library(plotly)
source("Scripts/0_Data_cleaning.R")
source("Andres/Andres_function.R")

p <- df %>% 
  filter( likes_count >= 10) %>% 
  ggplot(aes(likes_count, score, color = score, text = paste("score:",round(score,2),"\n",
                                                             "Likes:",round(likes_count,2),"\n",
                                                             "replies:",round(replies_count,2),"\n",
                                                             tweet )
             )
         ) + 
  geom_point() +
  scale_x_log10() + 
  scale_y_log10() + 
  labs(x = "Number of likes", 
       y = "Controversial Score",
       title  = "title")

ggplotly(p, tooltip ="text")
