library(tidyverse)
library(gssr)

data(gss_doc)
data(gss_all)

# id, hrs1, class, racehisp, region

gss <- gss_all |> 
  filter(year>=2012) |> 
  select(id, year, hrs1, class, race, hispanic, region) |> 
  drop_na()

gss <- gss |> 
   mutate(class = factor(class, labels = c("Lower", "Working", 
                                           "Middle", "Upper")),
          race = ifelse(hispanic>1, 4, race),
          racehisp = factor(race, labels = c("White", "Black", "Other", "Hispanic")),
          region = ifelse(region == 1, "New England",
                          ifelse(region == 2, "Middle Atlantic",
                               ifelse(region == 5, "South",
                                      ifelse(region >= 8, "West",
                                             "Midwest")))))

gss <- gss |> 
  select(-c(race, hispanic))

write.csv(gss, "data/assignment_02.csv", row.names = FALSE)
