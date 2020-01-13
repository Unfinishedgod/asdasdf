library(rvest)
library(tidyverse)
library(ggplot2)

git_url <- "https://github.com/Unfinishedgod"


git_info <- git_url %>%  
  read_html() %>%
  html_nodes(".border.border-gray-dark.py-2.graph-before-activity-overview") %>%
  html_nodes(".js-calendar-graph.mx-3.d-flex.flex-column.flex-items-end.flex-xl-items-center.overflow-hidden.pt-1.is-graph-loading.graph-canvas.calendar-graph.height-full.text-center") %>% 
  html_nodes("g") %>% 
  html_nodes("rect")


commit_date <- git_info %>% 
  html_attr("data-date") %>% 
  as.Date()

commit_count <- git_info %>% 
  html_attr("data-count") %>% 
  as.numeric()

fill <- git_info %>% 
  html_attr("fill") 


commit_info <- data.frame(commit_date,commit_count,fill) %>% 
  mutate(level = case_when(
    fill == unique(fill)[1] ~ "E",
    fill == unique(fill)[2] ~ "D",
    fill == unique(fill)[3] ~ "C",
    fill == unique(fill)[4] ~ "B",
    TRUE ~ "A"
  ))


####

uniform_date <- 100

# ggplot
ggplot(data = tail(commit_info,uniform_date), aes(x=commit_date,y=commit_count,fill=level)) +
  ggtitle(paste0("최근 커밋수: ", uniform_date)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = levels(commit_info$fill)) +
  theme_bw() +
  labs(x="Date", y="Commit count")
