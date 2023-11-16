library(tidyverse)
library(gssr)

# Get data
data(gss_all)

years <- gss_which_years(gss_all, "eqwlth")


ps2 <- gss_all |> 
  filter(year >= 2010) |> 
  select(id, year, age, race, hispanic, degree, eqwlth, conlegis)


ps2 <- read_csv("https://raw.githubusercontent.com/mjclawrence/soci385_f23/main/data/ps2.csv")

# Q1
ps2 |> 
  filter(year %in% c(2010, 2014, 2018, 2021)) |> 
  group_by(year) |> 
  summarize(mean_eqwlth = mean(eqwlth, na.rm = TRUE),
            sd = sd(eqwlth, na.rm = TRUE),
            n = length(eqwlth),
            se = sd / sqrt(n),
            ll = mean_eqwlth - 1.96*se,
            ul = mean_eqwlth + 1.96*se) |> 
  ggplot(aes(x = as.factor(year), y = mean_eqwlth,
             ymin = ll, ymax = ul)) +
  geom_point() + geom_errorbar()

# Q2
ps2 <- ps2 |> 
  mutate(age_cat = ifelse(age %in% c(18:24), "18-24",
                          ifelse(age %in% c(25:39), "25-39",
                                 ifelse(age %in% c(40:54), "40-54",
                                        ifelse(age %in% c(55:64), "55-64",
                                              "65+")))))


table(ps2$age, ps2$age_cat)

t.test(ps2$eqwlth[ps2$age_cat=="18-24" & ps2$year==2018],
       ps2$eqwlth[ps2$age_cat=="18-24" & ps2$year==2021])

t.test(ps2$eqwlth[ps2$age_cat=="25-39" & ps2$year==2018],
       ps2$eqwlth[ps2$age_cat=="25-39" & ps2$year==2021])

t.test(ps2$eqwlth[ps2$age_cat=="40-54" & ps2$year==2018],
       ps2$eqwlth[ps2$age_cat=="40-54" & ps2$year==2021])

t.test(ps2$eqwlth[ps2$age_cat=="55-64" & ps2$year==2018],
       ps2$eqwlth[ps2$age_cat=="55-64" & ps2$year==2021])

t.test(ps2$eqwlth[ps2$age_cat=="65+" & ps2$year==2018],
       ps2$eqwlth[ps2$age_cat=="65+" & ps2$year==2021])

# Q3
ps2 <- ps2 |> 
  mutate(hardly_any = ifelse(conlegis == "Hardly Any", 1, 0))

q3 <- ps2 |> 
  filter(eqwlth == 1 | eqwlth == 7)

mytable <- table(q3$eqwlth, q3$hardly_any)
prop.test(mytable)

# Q4
ps2 <- ps2 |> 
  mutate(racehisp = ifelse(hispanic > 1, "Hispanic", race)) |> 
  mutate(racehisp = factor(racehisp,
                           labels = c("White", "Black", "Other", "Hispanic")))

chisq.test(ps2$racehisp, ps2$eqwlth)


ps2 <- ps2 |> 
  mutate(degree = factor(degree,
                         labels = c("Less Than High School",
                                    "High School",
                                    "Junior College",
                                    "Bachelor",
                                    "Graduate")))

chisq.test(ps2$racehisp[ps2$degree=="Less Than High School"], 
           ps2$eqwlth[ps2$degree=="Less Than High School"])

fisher.test(ps2$racehisp[ps2$degree=="Less Than High School"],
            ps2$eqwlth[ps2$degree=="Less Than High School"],
            simulate.p.value = TRUE)

library(vcdExtra)

q4_table <- table(ps2$age_cat[ps2$year==2021], 
                  ps2$conlegis[ps2$year==2021])
GKgamma(q4_table)
-.199/.013


ps2 <- ps2 |> 
  mutate(conlegis = factor(conlegis,
                           labels = c("A Great Deal",
                                      "Only Some",
                                      "Hardly Any")))

ps2 <- ps2 |> 
  mutate(conlegis = factor(conlegis,
                           levels = c("Hardly Any",
                                      "Only Some",
                                      "A Great Deal")))

ps2 <- ps2 |> 
  select(year, age, racehisp, degree, eqwlth, conlegis) |> 
  filter(year %in% c(2010, 2014, 2018, 2021))

summary(ps2)
