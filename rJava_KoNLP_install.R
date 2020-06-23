install.packages("ISOcodes")

install.packages("tidytext")
library(tidytext)

# $R CMD javareconf

install.packages("rJava")
library(rJava)

install.packages(c('rJava', 'hash', 'tau', 'Sejong', 'RSQLite'))
install.packages("https://cran.r-project.org/src/contrib/Archive/KoNLP/KoNLP_0.80.2.tar.gz", repos=NULL, type="source")

library(KoNLP)

Sys.getLocale()

sessionInfo()
Sys.getlocale()
