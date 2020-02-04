# 단어 유사도 함수 stringdist
### 출처 https://cran.r-project.org/web/packages/stringdist/stringdist.pdf

`# install.packages("stringdist")`
`library(stringdist)`


# Calculate the similarity using the default method of optimal string alignment

### 단어를 비교 하는데 있어서 순서도 중요한가보다. (자세한건 추후 또 알아보자.)

`stringsim("ac", "abc")`

결과 0.666667

`stringsim("ca", "abc")`

결과 0

Calculate the similarity using the Jaro-Winkler method
The p argument is passed on to stringdist
`stringsim('MARTHA','MATHRA',method='jw', p=0.1)`

결과 0.9333333
