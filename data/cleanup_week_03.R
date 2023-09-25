library(gssr)
library(tidyverse)

data(gss_doc)

data(gss_all)

table(gss_all$year)

mydf <- filter(gss_all, year>=2012)

mydf <- mydf |> 
  select(id, year, educ, agekdbrn, race, hispanic) |> 
  drop_na()


table(mydf$hispanic)

table(mydf$race)

mydf <- mydf |> 
  mutate(racehisp = ifelse(hispanic>1, "hispanic", race)) |> 
  mutate(racehisp = ifelse(racehisp==1, "white",
                           ifelse(racehisp==2, "black",
                                  ifelse(racehisp==3, "other", "hispanic"))))
table(mydf$racehisp)

mydf <- mydf |> 
  select(-c(race, hispanic))

write.csv(mydf, "data/gss_week3.csv", row.names = FALSE)

colleges <- read_csv("https://opportunityinsights.org/wp-content/uploads/2018/03/mrc_table1.csv")

colleges <- colleges |> 
  select(name, par_median)

write.csv(colleges, "data/college_mobility.csv", row.names = FALSE)

plot(density(colleges$par_median))
