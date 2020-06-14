library(XML)

## 서울 열린데이터 광장
# http://data.seoul.go.kr/
 
 
# api키 발급
serviceKey <- "sample_service_key"

# api 호출 형식
api_url <- "http://openapi.seoul.go.kr:8088/(인증키)/xml/(카테고리)/1/5/"

# xml to Datafrme function
xmlToDataFrame(api_url)

