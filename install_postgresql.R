# install.packages("DBI")
# 
# > install.packages("odbc")
# 
# > install.packages("RPostgreSQL")
# 
# # 설치
# > require("RPostgreSQL")
# 
# >con<-dbConnect(dbDriver("PostgreSQL"), dbname="dbname", host="localhost", port=5432, user="user_name",password="password")
# 
# > dbListTables(con)
# 

library(DBI)
library(odbc)
library(RPostgreSQL)

library(RPostgres)


drv <- dbDriver("PostgreSQL")

con <- dbConnect(dbDriver("PostgreSQL"), dbname="dbname", host="13.209.52.67", port=5432, user="user_name",password="password")

dbListTables(con)

con<-dbConnect(RPostgres::Postgres())
