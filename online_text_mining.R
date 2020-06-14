library(wordcloud2)
library(KoNLP)
library(rvest)
library(tidyverse)
library(arules)
library(glue)
library(arulesViz)

keyword <- "공팔리터"
page_num <- seq(1,100,10)

news_url_list <- map(page_num, function(x) {
  news_url <- glue("https://search.naver.com/search.naver?&where=news&query={keyword}&sm=tab_pge&sort=0&photo=0&field=0&reporter_article=&pd=0&ds=&de=&docid=&nso=so:r,p:all,a:all&mynews=0&cluster_rank=22&start={x}&refresh_start=0")
  
  news_html <- read_html(news_url) 
  
  news_urls <- news_html %>% 
    html_nodes(".news.mynews.section._prs_nws") %>% 
    html_nodes("._sp_each_url") %>% 
    html_attr("href")
  
  news_urls[news_urls %>% str_detect("https://news.naver")]
}) %>% 
  unlist() %>% 
  unique()

news_text <- map_chr(news_url_list, function(news_page) {
  text_set <- news_page %>% 
    read_html() %>% 
    html_nodes("#articleBodyContents._article_body_contents") %>% 
    html_text()
  if(length(text_set) == 0) {
    text_set <- "내용 없음"
  }
  text_set
})

cleanging_text <- news_text %>% 
  str_remove_all("flash 오류를 우회하기 위한 함수 추가") %>% 
  str_remove_all("function _flash_removeCallback") %>% 
  str_remove_all("[a-zA-Z]") %>% 
  str_remove_all("\\d") %>% 
  str_remove_all("무단 전재 및 재배포 금지") %>% 
  str_remove_all("내용 없음") %>% 
  str_replace_all("\\W"," ") 



# cleanging_text <- paste0(cleanging_text, collapse = "")
nouns <- map(cleanging_text, function(x) {
  cleanging_data <- KoNLP::extractNoun(x) %>% 
    str_remove_all("은") %>% 
    str_remove_all("는") %>% 
    str_remove_all("가") %>%
    str_remove_all("을") %>%
    str_remove_all("를") %>% 
    str_remove_all("일보")
  
  cleanging_data %>% 
    subset(nchar(cleanging_data) >= 2)
})


# table 형태로 변환
wordcount <- table(unlist(nouns))

df.word  <- as.data.frame(wordcount, stringsAsFactors = FALSE)
df.word <- rename(df.word, word = Var1, freq = Freq)

word.freq  <- df.word %>% 
  filter(nchar(word) >=2 & freq >= 2) %>% 
  arrange(desc(freq))

# 상위 5개 데이터 파악
test_df <- word.freq %>% 
  top_n(20) %>% 
  select(word) %>% 
  t() %>% 
  as.character()



# 장바구니 알고리즘 적용 
# 상위 10개 데이터 사용

item_list <- map(1:length(nouns), function(x) {
  nouns[[x]] %>% 
    subset(nouns[[x]] %in% test_df) %>% 
    unique() %>% 
    head(10)
})



items <- as(item_list, "transactions")

# inspect(items)

result_items <- apriori(items, parameter = list(support=0.2, confidence=0.8))

inspect(result_items)

# str(result_items)

as(head(sort(result_items, by = c("lift")), n=20), "data.frame")

### 시각화
set.seed(200)
plot(result_items[1:50], method = "graph")


wordcloud2(word.freq,
           fontFamily="Malgun Gothic",
           size = 0.5,
           minRotation=0,
           maxRotation=0,
)


ggplot(head(word.freq,30), aes(x=reorder(word,freq),y=freq,fill=word),colour=gradient) +
  geom_col() +
  theme_bw() + 
  labs(x="",y="단어 빈도",title = "데이터 3법 네이버 뉴스 단어 빈도") + 
  coord_flip() + 
  theme(legend.position = "none") +
  theme(text = element_text(size=20),
        axis.text.x = element_text(angle=90, hjust=1)) 
