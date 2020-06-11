# https://github.com/joachim-gassen/tidycovid19
# https://github.com/sbihorel/rclipboard

install.packages("COVID19")

library(tidyverse)
library(tidycovid19)
library(zoo)

install.packages("kable")
library(knitr)


df <- download_merged_data(cached = TRUE, silent = TRUE)

df %>% 
  arrange(desc(date))

df %>%
  filter(iso3c == "ITA") %>%
  mutate(
    new_cases = confirmed - lag(confirmed),
    ave_new_cases = rollmean(new_cases, 7, na.pad=TRUE, align="right")
  ) %>%
  filter(!is.na(new_cases), !is.na(ave_new_cases)) %>%
  ggplot(aes(x = date)) +
  geom_bar(aes(y = new_cases), stat = "identity", fill = "lightblue") +
  geom_line(aes(y = ave_new_cases), color ="red") +
  theme_minimal()



df <- tidycovid19_variable_definitions %>%
  select(var_name, var_def)
kable(df) %>% kableExtra::kable_styling()



merged <- download_merged_data(cached = TRUE, silent = TRUE)

plot_covid19_spread(
  merged, highlight = c("ITA", "ESP", "GBR", "FRA", "DEU", "USA"),
  intervention = "lockdown", edate_cutoff = 60
)




plot_covid19_stripes()


plot_covid19_stripes(
  per_capita = TRUE, 
  population_cutoff = TRUE, 
  sort_countries = "magnitude"
)



plot_covid19_stripes(
  type = "confirmed", 
  countries = c("ITA", "ESP", "FRA", "GBR", "DEU", "USA","KOR"),
  sort_countries = "countries"
)



map_covid19(merged, cumulative = TRUE)


map_covid19(merged, type = "confirmed", region = "Asia") 



map_covid19(merged, type = "confirmed", dates = unique(merged$date))



plot_covid19_spread()



shiny_covid19_spread()
