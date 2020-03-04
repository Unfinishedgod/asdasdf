library(stringi)
library(kormaps2014)
library(tidyverse)
library(googledrive)
library(mapproj)
library(ggiraphExtra)
library(data.table)
library(readxl)
library(patchwork)
library(gridExtra)
library(maps)
library(ggthemes)
library(gganimate)
library(httr)
library(jsonlite)
library(glue)

theme_set(theme_bw())

## 전체 인구
population <- read_xls("population_x.xls")

population <- population[,c(1,8)]

colnames(population) <- c("행정구역별_읍면동", "총인구수")

population <- population[-c(1:2),]

korpop2020 <- korpop1 %>% 
  left_join(population) %>% 
  select(C행정구역별_읍면동, 행정구역별_읍면동, 시점, C행정구역별, code, 총인구수) %>% 
  rename(pop2020 = 총인구수, name = 행정구역별_읍면동)

korpop2020$시점 <- 2020
korpop2020$pop2020 <- as.numeric(korpop2020$pop2020)

ggChoropleth(data = korpop2020,      # 지도에 표현할 데이터
             aes(fill = pop2020,      # 색깔로 표현할 변수
                 map_id = code,   # 지역 기준 변수
                 tooltip = name), # 지도 위에 표시할 지역명
             map = kormap1,       # 지도 데이터
             interactive = T)


## 코로나 확진자
corona_0301 <- read_xlsx("corona19_kr_20200301.xlsx")

corona_0301 <- corona_0301 %>% 
  select(구분, `확진환자 (명)`) %>% 
  filter(!구분 %in% c(NA,"합계", "검역"))


colnames(tbc)[1] <- "구분"

tbc_unique <- tbc %>% 
  select(구분, name) %>% 
  unique() 

corona_0301 <- corona_0301 %>% 
  left_join(tbc_unique) %>% 
  select(name, `확진환자 (명)`)



kor_pop_corona <- korpop2020 %>% 
  left_join(corona_0301) %>% 
  rename(pop_corona = `확진환자 (명)`)

kor_pop_corona$pop_corona <- as.numeric(kor_pop_corona$pop_corona)


ggChoropleth(data = kor_pop_corona,      # 지도에 표현할 데이터
             aes(fill = pop_corona,      # 색깔로 표현할 변수
                 map_id = code,   # 지역 기준 변수
                 tooltip = name), # 지도 위에 표시할 지역명
             map = kormap1,       # 지도 데이터
             interactive = T)



kor_pop_corona_2 <- kor_pop_corona %>% 
  gather(key = "case", value = "pops", `pop2020`,`pop_corona`)



ggplot(data = kor_pop_corona_2) +
  geom_col(aes(x = name, y = pops, fill = pops))

ggplot(data = kor_pop_corona_2) +
  geom_col(aes(x = name, y = pops, fill = pops, 
               group = case)) +
  facet_wrap(~case)



### 
corona_flow <- read_xlsx("corona19-kr.xlsx")

corona_flow_2 <- corona_flow %>% 
  filter(location != "검역" & state1 == "확진") %>%
  rename(Day = "datetime(kst)") %>% 
  group_by(Day, location, state1) %>% 
  summarise(count = sum(count)) 

p <- corona_flow_2 %>% 
  ggplot(aes(Day, count, group = location, color = factor(location))) +
  geom_line() +
  scale_color_viridis_d() +
  labs(x = "날짜", y = "확진자 수(26일 이후)") +
  theme(legend.position = "top")


p + geom_point() + 
  geom_text( aes(y = count+1,label=paste0(location, " (",count,"명)")), size=3, vjust=-1) +
  transition_reveal(Day)



####
library(readr)
library(dplyr)

url_csv <- 'https://raw.githubusercontent.com/d4tagirl/R-Ladies-growth-maps/master/rladies.csv'
rladies <- read_csv(url(url_csv)) %>% 
  select(-1)

library(DT)

datatable(rladies, rownames = FALSE,
          options = list(pageLength = 5))

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

map <- world +
  geom_point(aes(x = lon, y = lat, size = followers),
             data = rladies, 
             colour = 'purple', alpha = .5) +
  scale_size_continuous(range = c(1, 8), 
                        breaks = c(250, 500, 750, 1000)) +
  labs(size = 'Followers')



korea <- map_data("world", region = c("South Korea"))


data(world.cities)

Lat_lon_fun <- function(addr) {
  data_list <-
    GET(url = 'https://dapi.kakao.com/v2/local/search/address.json',
        query = list(query = addr),
        add_headers(Authorization = paste0("KakaoAK ", "2ecacbafd523802f293b245103346b06"))) %>% 
    content(as = 'text') %>% 
    fromJSON()
  
  
  lon_lat_df <- data.frame(location = addr, long = data_list$documents$x, lat = data_list$documents$y)
  
  return(lon_lat_df)
}




location_list <- corona_0301$name

location_long_lat <- map_dfr(location_list, function(x) {
  Lat_lon_fun(x)
})

asdf <- cbind(corona_0301, location_long_lat[,-1]) %>% 
  rename(pop = `확진환자 (명)`)

asdf$pop <- as.numeric(asdf$pop)
asdf$long <- as.numeric(asdf$long)
asdf$lat <- as.numeric(asdf$lat)

# ggplot() + 
#   geom_polygon(data=korea, aes(x=long, y=lat, group=group, fill=region)) +
#   geom_point(data=korea.pop, aes(x=long, y=lat, size = pop), shape = 16, color = "green", alpha = 0.4) +
#   scale_size_area(max_size=10)


ggplot() + 
  geom_polygon(data=korea, aes(x=long, y=lat, group=group, fill=region)) +
  geom_point(data=asdf, aes(x=long, y=lat, size = pop), shape = 16, color = "green", alpha = 0.4) +
  scale_size_area(max_size=30) +
  geom_text(data=asdf, aes(x=long+0.2, y=lat+0.2, label=name))




# 
# map_less_frames <- world +
#   geom_point(aes(x = lon, y = lat, size = est_followers, 
#                  frame = date),
#              data = rladies_less_frames, colour = 'purple', alpha = .5) +
#   geom_point(aes(x = lon, y = lat, size = est_followers, 
#                  frame = date),
#              data = ghost_points_ini, alpha = 0) +
#   geom_point(aes(x = lon, y = lat, size = est_followers, 
#                  frame = date),
#              data = ghost_points_fin, colour = 'purple', alpha = .5) +
#   # scale_size_continuous(range = c(1, 8), breaks = c(250, 500, 750, 1000)) +
#   labs(size = 'Followers')
# 
# ani.options(interval = .15)
# gganimate(map_less_frames)
# 
# 
# # write.csv(location_long_lat,file="location_long_lat.csv")
# world <- ggplot() +
#   borders("world", colour = "gray85", fill = "gray80") +
#   theme_map() 
# 
# map <- world +
#   geom_point(aes(x = lon, y = lat, size = followers),
#              data = rladies, 
#              colour = 'purple', alpha = .5) +
#   scale_size_continuous(range = c(1, 8), 
#                         breaks = c(250, 500, 750, 1000)) +
#   labs(size = 'Followers')
