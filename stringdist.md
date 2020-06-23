# 단어 유사도 함수 stringdist
### 출처 https://cran.r-project.org/web/packages/stringdist/stringdist.pdf

`# install.packages("stringdist")`
`library(stringdist)`


### 단어를 비교 하는데 있어서 순서도 중요한가보다. (자세한건 추후 또 알아보자.)

`stringsim("ac", "abc")`

결과 0.666667

`stringsim("ca", "abc")`

### 순서 상관없이 단어 자체만 보기 위해선 옵션을 넣어 주어야함 (jaccard)

```
rmethods = c("osa", "lv", "dl", "hamming", "lcs", "qgram",
            "cosine", "jaccard", "jw", "soundex")
 for(i in methods) {
+   a <- stringsim("ac", "abc", method = i)
+   b <- stringsim("ca", "abc", method= i)
+   
+   results <- a == b 
+   # results %>% print()
+   # a %>% print()
+   # b %>% print()
+   cat(results,a, b, i, "\n")
+ }

FALSE 0.6666667 0 osa 
FALSE 0.6666667 0 lv 
FALSE 0.6666667 0.3333333 dl 
TRUE 0 0 hamming 
FALSE 0.8 0.4 lcs 
TRUE 0.8 0.8 qgram 
TRUE 0.8164966 0.8164966 cosine 
TRUE 0.6666667 0.6666667 jaccard 
FALSE 0.6111111 0 jw 
TRUE 0 0 soundex
```


결과 0

Calculate the similarity using the Jaro-Winkler method
The p argument is passed on to stringdist
`stringsim('MARTHA','MATHRA',method='jw', p=0.1)`

결과 0.9333333
