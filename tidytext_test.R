library(tidyverse)
library(tidytext)
library(arules)
library(KoNLP)
text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

paste0(text, collapse = ",")

text <- cleanging_text

text_df <- data_frame(line=1:length(text), text=text)

asdf <- text_df %>%
  unnest_tokens(word, text)

asdf_2 <- map(text, function(x) {
  text_df <- data_frame(line=1:length(x), text=x)
  
  text_df %>%
    unnest_tokens(word, text) %>% 
    top_n(10) %>% 
    select(word) %>% 
    as.character()
})

asdf

asdf %>% 
  group_by(line) %>% 
  summarise(asdfasdf = paste0(word, seq = FALSE))


a <- text_df %>%
  unnest_tokens(word, text) %>% 
  count(word, sort= TRUE)


a

str(nouns)

buyItems <- as(nouns, "transactions")

# 변환된 트랜잭션 확인(11개 항목에 대해 5개 거래 존재)
buyItems
## transactions in sparse format with
##  5 transactions (rows) and
##  11 items (columns)
# 트랜잭션 데이터는 inspect 함수를 통해 내용 확인
inspect(buyItems)


buyItemResult <- apriori(buyItems, parameter = list(support=0.1, confidence=0.3))


# 도출된 연관성 규칙 5개만 확인
buyItemResult[1:5]
## set of 5 rules
# 연관성 규칙 상세 보기
inspect(buyItemResult[1:5])
