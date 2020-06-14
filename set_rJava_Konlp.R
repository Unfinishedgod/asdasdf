# R RMD javareconf

# r 종료 후 다시 키기

# install.packages("rJava")
library(rJava)
 

# 의존성 패키지 설치
install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")

# github 버전 설치
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP')

library(KoNLP)