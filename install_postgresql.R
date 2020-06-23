# https://dejavuqa.tistory.com/363?category=257816
# https://github.com/snowplow/snowplow/wiki/Setting-up-PostgreSQL#ec2
# https://okky.kr/article/629800

library(DBI)
library(odbc)
library(RPostgreSQL)

library(RPostgres)


drv <- dbDriver("PostgreSQL")

con <- dbConnect(dbDriver("PostgreSQL"), dbname="dbname", host="13.209.52.67", port=5432, user="user_name",password="password")

dbListTables(con)

con<-dbConnect(RPostgres::Postgres())
