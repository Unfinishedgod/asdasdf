library(stringi)
library(kormaps2014)
library(tidyverse)
library(googledrive)
library(mapproj)
library(ggiraphExtra)
library(data.table)
library(readxl)



## 전체 인구
population <- read_xls("population_x.xls")

population <- population[,c(1,8)]

colnames(population) <- c("행정구역별_읍면동", "총인구수")

population <- population[-c(1:2),]

korpop2020 <- korpop1 %>% 
  left_join(population) %>% 
  rename(pop2020 = 총인구수) %>% 
  select(C행정구역별_읍면동, name, 시점, C행정구역별, code, pop2020)

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



drive_auth()


item_list <- drive_find()

item_list[3,1]

drive_download(item_list$name[3],type = "csv")

asfd <- read_csv("corona19-kr.csv")

drive_download(item_list$name[1], overwrite = TRUE)

asfd <- read_csv("corona19-kr.csv")


drive_download(item_list$name[8],type = "csv")

