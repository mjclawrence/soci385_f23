library(tidyverse)
gss <- read_csv("/Users/lawrence/desktop/gss.csv")

gss <- gss |> 
  filter(year == 2021) 

gss_subset <- gss |> 
  filter(born>0) |> 
  mutate(age = ifelse(age<0, NA, age),
         ophrdwrk = ifelse(ophrdwrk<0, NA, ophrdwrk),
         opwlth = ifelse(opwlth<0, NA, opwlth),
         oppared = ifelse(oppared<0, NA, oppared),
         opeduc = ifelse(opeduc<0, NA, opeduc),
         opknow = ifelse(opknow<0, NA, opknow),
         opclout = ifelse(opclout<0, NA, opclout),
         oprace = ifelse(oprace<0, NA, oprace),
         oprelig = ifelse(oprelig<0, NA, oprelig),
         opsex = ifelse(opsex<0, NA, opsex),
         yearsusa = ifelse(yearsusa<0, NA, yearsusa)) |> 
  select(-ballot)

summary(gss_subset)




gss_test <- gss_subset |> 
  mutate(ophrdwrk_essential = ifelse(ophrdwrk==1, 1, 0),
         opknow_essential = ifelse(opknow==1, 1, 0))

gss_test <- gss_test |> 
  mutate(born = ifelse(born == 2, "Immigrant", "Native"))

oplabels <- c("Essential", "Very Important", "Fairly Important", "Not Very Important",
              "Not Important At All")

gss_test <- gss_test |> 
  mutate(opwlth = factor(opwlth,
                         labels = oplabels),
         oppared = factor(oppared, labels = oplabels),
         opeduc = factor(opeduc, labels = oplabels),
         opclout = factor(opclout, labels = oplabels),
         oprace = factor(oprace, labels = oplabels),
         oprelig = factor(oprelig, labels = oplabels),
         opsex = factor(opsex, labels = oplabels)) |> 
  select(-c(ophrdwrk, opknow))


write.csv(gss_test, "data/assignment_05.csv", row.names = FALSE)

gss_test <- read_csv("https://raw.githubusercontent.com/mjclawrence/soci385_f23/main/data/assignment_05.csv")


# Difference in proportion of immigrants vs non immigrants 
# who say hard work is essential

mytable <- table(gss_test$born, gss_test$ophrdwrk_essential)
mytable
prop.table(mytable,1)
prop.test(mytable)

# Difference in average age between immigrants and non immigrants

t.test(gss_test$age[gss_test$born==1], gss_test$age[gss_test$born==2])

# Difference in average years in us 
# between immigrants who say hard work is essential and 
# immigrants who do not say hard work is essential

t.test(gss_test$yearsusa[gss_test$born==2 & gss_test$ophrdwrk_essential==1],
       gss_test$yearsusa[gss_test$born==2 & gss_test$ophrdwrk_essential==0])

### Other Variables

# Difference in proportion of immigrants vs non immigrants 
# who say wealth is essential (opwlth)

gss_test <- gss_test |> 
  mutate(opwlth_essential = ifelse(opwlth %in% c("Essential", "Very Important"), 1, 0))

opwlth_table <- table(gss_test$born, gss_test$opwlth_essential)
prop.test(opwlth_table, conf.level = .99)

# Difference in proportion of immigrants vs non immigrants 
# who say parent's education is essential (oppared)

gss_test <- gss_test |> 
  mutate(oppared_essential = ifelse(oppared %in% c("Essential", "Very Important"), 1, 0))

oppared_table <- table(gss_test$born, gss_test$oppared_essential)
prop.test(oppared_table, conf.level = .99)

# Difference in proportion of immigrants vs non immigrants 
# who say education is essential (opeduc)

gss_test <- gss_test |> 
  mutate(opeduc_essential = ifelse(opeduc %in% c("Essential", "Very Important"), 1, 0))

opeduc_table <- table(gss_test$born, gss_test$opeduc_essential)
prop.test(opeduc_table, conf.level = .99)

# Difference in proportion of immigrants vs non immigrants 
# who say political connections is essential (opclout)

gss_test <- gss_test |> 
  mutate(opclout_essential = ifelse(opclout %in% c("Essential", "Very Important"), 1, 0))

opclout_table <- table(gss_test$born, gss_test$opclout_essential)
prop.test(opclout_table, conf.level = .99)

# Difference in proportion of immigrants vs non immigrants 
# who say being the right race is essential (oprace)

gss_test <- gss_test |> 
  mutate(oprace_essential = ifelse(oprace %in% c("Essential", "Very Important"), 1, 0))

oprace_table <- table(gss_test$born, gss_test$oprace_essential)
prop.test(oprace_table, conf.level = .99)

# Difference in proportion of immigrants vs non immigrants 
# who say being the right religion is essential (oprelig)

gss_test <- gss_test |> 
  mutate(oprelig_essential = ifelse(oprelig %in% c("Essential", "Very Important"), 1, 0))

oprelig_table <- table(gss_test$born, gss_test$oprelig_essential)
prop.test(oprelig_table, conf.level = .99)

# Difference in proportion of immigrants vs non immigrants 
# who say being the right sex is essential (opsex)

gss_test <- gss_test |> 
  mutate(opsex_essential = ifelse(opsex %in% c("Essential", "Very Important"), 1, 0))

opsex_table <- table(gss_test$born, gss_test$opsex_essential)
prop.test(opsex_table, conf.level = .99)



# Difference in proportion of immigrants vs non immigrants 
# who say knowing right people is essential (opknow)

gss_test <- gss_test |> 
  mutate(opknow_essential = ifelse(opknow<=2, 1, 0))

opknow_table <- table(gss_test$born, gss_test$opknow_essential)
prop.test(opknow_table, conf.level = .99)


## Cleanup



gss_test_imm <- gss_test |> 
  filter(born == "Immigrant") |> 
  mutate(imm_years = ifelse(yearsusa<15, 0, 1))

mytable <- table(gss_test_imm$imm_years, gss_test_imm$opknow_essential)
mytable
prop.table(mytable,1)
prop.test(mytable)




