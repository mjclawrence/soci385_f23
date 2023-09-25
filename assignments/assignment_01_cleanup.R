library(gssr)
library(tidyverse)

data(gss_doc)

data(gss_all)

table(gss_all$year)

mydf <- filter(gss_all, year>=2012)

mydf <- mydf |> 
  select(id, year, educ, agekdbrn) |> 
  drop_na()

write.csv(mydf, "data/assignment_01.csv", row.names=TRUE)

summary(mydf$agekdbrn)

quantile(mydf$agekdbrn, c(.79))

sort(table(mydf$agekdbrn[mydf$educ<=12]))

prop.table(table(mydf$educ))

mydf2 <- mydf |> 
  select(agekdbrn, educ) |> 
  filter(educ>=14)

mydf2 |> 
  group_by(educ) |> 
  summarise(mean_agekdbrn = mean(agekdbrn))


