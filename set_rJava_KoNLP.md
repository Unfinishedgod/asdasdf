
## rJava 설치 안될때

 자바 경로 설정 (터미널) <br>

`$ R RMD javareconf`

r 종료 후 다시 키기

`# install.packages("rJava")` <br>
`library(rJava)`


## KoNLP 설치 (KoNLP가 업데이트 되면서 Cran에 올라가지 않아서 생기는 문제)

- 2020 02 11 기준

의존성 패키지 설치

`install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")`

github 버전 설치

```install.packages("remotes")``` <br>
```remotes::install_github('haven-jeon/KoNLP')```

```library(KoNLP)```




2020 02 26 기준

### 의존성 패키지 설치
```nstall.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")```

### github 버전 설치
```install.packages("remotes")```
### 64bit 에서만 동작합니다.
```remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))```
