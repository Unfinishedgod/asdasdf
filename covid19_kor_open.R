library(readr)
library(tidyverse)
library(DT)
library(httr)
library(jsonlite)
library(glue)
library(XML)
library(xml2)


# 마스크 정보 API ------------------------

# service_key <- "mQDsELyceyw94xJmScmquAdBj0eZBatlej7JUUxw3r5M96lNTD2XsCC0dspQCT25RTc4%2BVjA7s5R0Tkj2wUzDg%3D%3D"
service_key <- "RmqU3CjjOV5YWfLalLb%2FQp3Gl%2FQ7l0Kb9j%2F7lWrpHEoTcG4HMGc163R6ZhQALGFoO9u7oAGhHL9PDCYV7iN4MA%3D%3D"
# "RmqU3CjjOV5YWfLalLb%2FQp3Gl%2FQ7l0Kb9j%2F7lWrpHEoTcG4HMGc163R6ZhQALGFoO9u7oAGhHL9PDCYV7iN4MA%3D%3D"

# _1. 좌표(위/경도) 기준 공적 마스크 판매정보 제공 서비스 ----
df_1 <- "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json" %>% 
  fromJSON %>% 
  as_tibble()

df_1
# _2. 주소/좌표 기준 판매처별 공적 마스크 판매정보 제공 서비스 ----
df_2 <- "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/stores/json" %>% 
  fromJSON

df_2 <- df_2$storeInfos %>% 
  as_tibble()
# _3. 주소 기준 동네별 공적 마스크 판매정보 제공 서비스 ----
df_3 <- "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByAddr/json" %>% 
  fromJSON

df_3 <- df_3$stores %>% 
  as_tibble()
# _4. 건강보험심사평가원_코로나19병원정보(국민안심병원 외)서비스 ----
df_4 <- glue("http://apis.data.go.kr/B551182/pubReliefHospService/getpubReliefHospList?ServiceKey={service_key}&pageNo=2&numOfRows=100&spclAdmTyCd=A0")

rootNode  <- xmlTreeParse(df_4, useInternalNodes = TRUE) %>%
  xmlRoot()

items <- rootNode[[2]]

size <- xmlSize(items)

df_4 <-   if(size != 0) {
  map_dfr(1:size,function(y) {
    xmlSApply(items[[1]][[y]],xmlValue) %>%
      t() %>%
      as_tibble()
  })
}

# N_5. 외교부_국가·지역별 최신안전소식(코로나관련) ----
df_5 <- glue("http://apis.data.go.kr/1262000/SafetyNewsList/getCountrySafetyNewsList?serviceKey={service_key}&numOfRows=10&pageNo=1&title1=입국")


rootNode  <- xmlTreeParse(df_5, useInternalNodes = TRUE) %>%
  xmlRoot()

items <- rootNode[[2]]

size <- xmlSize(items)

df_4 <-   if(size != 0) {
  map_dfr(1:size,function(y) {
    xmlSApply(items[[1]][[y]],xmlValue) %>%
      t() %>%
      as_tibble()
  })
}


# _6. 판매처별 공적 마스크 판매처 정보 제공 서비스 ----
df_6 <- "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/sales/json" %>% 
  fromJSON

df_6 <- df_6$sales %>% 
  as_tibble()

# _7. 보건복지부_코로나19 감염_현황 ----
df_7 <- glue("http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson?serviceKey={service_key}&pageNo=1&numOfRows=10&startCreateDt=20200310&endCreateDt=20200315")

rootNode  <- xmlTreeParse(df_7, useInternalNodes = TRUE) %>%
  xmlRoot()

items <- rootNode[[2]]

size <- xmlSize(items)

df_7 <-   if(size != 0) {
  map_dfr(1:size,function(y) {
    xmlSApply(items[[1]][[y]],xmlValue) %>%
      t() %>%
      as_tibble()
  })
}

# _8. 보건복지부_코로나19 연령별·성별감염_현황 ----
df_8 <- glue("http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19GenAgeCaseInfJson?serviceKey={service_key}&pageNo=1&numOfRows=10&startCreateDt=20200310&endCreateDt=20200414")


rootNode  <- xmlTreeParse(df_8, useInternalNodes = TRUE) %>%
  xmlRoot()

items <- rootNode[[2]]

size <- xmlSize(items)

df_8 <-   if(size != 0) {
  map_dfr(1:size,function(y) {
    xmlSApply(items[[1]][[y]],xmlValue) %>%
      t() %>%
      as_tibble()
  })
}
# _9. 보건복지부_코로나19 시·도발생_현황 ----
df_9 <- glue("http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson?serviceKey={service_key}&pageNo=1&numOfRows=10&startCreateDt=20200410&endCreateDt=20200410")

rootNode  <- xmlTreeParse(df_9, useInternalNodes = TRUE) %>%
  xmlRoot()

items <- rootNode[[2]]

size <- xmlSize(items)

df_9 <-   if(size != 0) {
  map_dfr(1:size,function(y) {
    xmlSApply(items[[1]][[y]],xmlValue) %>%
      t() %>%
      as_tibble()
  })
}