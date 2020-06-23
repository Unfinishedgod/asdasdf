money <- seq(7000, 15000, 1000)

ratio <- seq(0.027, 0.03, 0.001)

maximun <- seq(0.7,0.9, 0.1)

set <- data.frame()
case <- data.frame()

for(maximun_d in maximun) {
  for(ratio_d in ratio) {
    total <- (money * maximun_d * ratio_d / 12)
    monthly <- money * (1 - maximun_d) * 5 / 1000
    monthly_money <- (total + monthly) %>% 
      round(2)
    
    set <- rbind(set, monthly_money)
    case <- rbind(case, data.frame("total"= paste0(maximun_d*100, "%"), "monthly"=paste0(ratio_d*100, "%")))
    
    
  }
}

colnames(set) <- paste0(money,"만원")

cbind(case, set)
