library(tidyverse)
library(DT)

chetty <- read_csv("https://opportunityinsights.org/wp-content/uploads/2023/07/CollegeAdmissions_Data.csv")
colleges <- read_csv("https://opportunityinsights.org/wp-content/uploads/2018/04/mrc_table3.csv")

colleges <- colleges |> 
  filter(cohort == 1991) |> 
  select(super_opeid, par_q1, par_q2, par_q3, par_q4, par_q5, par_top1pc, par_median)

chetty <- left_join(chetty, colleges)

summary(chetty$par_top1pc)

hist(chetty$par_median)

summary(chetty$par_top1pc[chetty$name=="Middlebury College"])

quantile(chetty$par_top1pc, c(0.98), na.rm = TRUE)

table(chetty$par_income_lab[chetty$name=="Middlebury College"],
      chetty$rel_attend[chetty$name=="Middlebury College"])

chetty |> 
  filter(name == "Middlebury College" & par_income_lab == "Top 1") |> 
  select(name, par_income_lab, rel_attend, rel_attend_unwgt, par_top1pc)

summary(chetty$rel_attend)

chetty |> 
  ggplot(aes(x = rel_attend)) + geom_density()

chetty |> 
  select(name, par_income_lab, rel_attend) |> 
  filter(par_income_lab == "Top 1") |> 
  slice_max(order_by = rel_attend,
            n = 30) |> 
  datatable()

summary(chetty$rel_attend)

table(chetty$name[chetty$rel_attend>10])

middlebury <- chetty |> 
  select(name, test_band_tier, par_income_bin, par_income_lab, rel_attend_unwgt, rel_apply_unwgt, rel_attend, rel_attend_sat) |> 
  #filter(test_band_tier == "NESCAC") |> 
  filter(str_detect(name, "Middlebury|Dartmouth")) |> 
  filter(!par_income_lab %in% c("99-99.9", "Top 0.1")) |> 
  mutate(new_var = log(rel_attend_unwgt)) |> 
  ggplot(aes(x = par_income_bin, y = rel_attend, text = paste("Name: ", name, "\n",
                                                              "Parent Income: ", par_income_lab, "\n",
                                                              "Relative Rate: ", round(rel_attend,1)))) +
  geom_point() + geom_line(aes(group = name, color = name)) +
  geom_hline(yintercept = 1)

library(plotly)

ggplotly(middlebury, tooltip = c("text"))


middlebury |> 
  #pivot_wider(names_from = par_income_lab, values_from = rel_attend) |> 
  filter(name == "Middlebury College")



  select(-c("99-99.9", "Top 0.1")) |> 
  pivot_longer(names_to = "par_income_lab", values_to = "rel_attend", 2:13) |> 
  filter(name == "Middlebury College")
  
# Start with just the top 1 percent
  
top1 <- chetty |> 
  filter(par_income_lab == "Top 1") |> 
  select(name, public, tier, test_band_tier, par_income_lab, rel_attend, rel_attend_unwgt, par_top1pc, par_q1, par_q2, par_q3, par_q4, par_q5, par_median) |> 
  rename(rel_attend_sat = rel_attend,
         rel_attend = rel_attend_unwgt)

top1

## How many public and private colleges are there?

table(top1$public)

## What is the distribution of the rel_attend variable?

summary(top1$rel_attend)

## What is that value for Middlebury College?

summary(top1$rel_attend[top1$name=="Middlebury College"])

## Where is Middlebury in the distribution?

plot(density(top1$par_top1pc, na.rm = TRUE))

## What are the colleges with higher rel_attend values than Middlebury?

table(top1$name[top1$rel_attend > top1$rel_attend[top1$name=="Middlebury College"]])


## For simple things, indexing works. But we can start to see the limits here. Some tidyverse functions will make this easier.

## The tidyverser function that is the equivalent of indexing is filter(). It chooses the rows you want.

## In this example, we only want the rows where the value of the name variable is equal to "Middlebury College"

filter(top1, name == "Middlebury College")

## The select() function chooses the columns you want

select(top1, name, rel_attend_sat)

## We can combine them with a chain and only have to use the dataframe name once.

top1 |>
  filter(name == "Middlebury College") |> 
  select(name, rel_attend, rel_attend_sat)


## The datatable package we saw last class works well with chains as well

top1 |> 
  #filter(name == "Middlebury College") |> 
  select(name, rel_attend, rel_attend_sat) |> 
  datatable()

top1 |> 
  filter(test_band_tier == "NESCAC") |> 
  select(name, rel_attend, rel_attend_sat) |> 
  #arrange(order_by = rel_attend) |> 
  datatable()


top1 |> 
  filter(str_detect(name, "Technology")) |> 
  filter(public == "Private") |> 
  select(name, rel_attend, rel_attend_sat, tier)





top1 |> 
  select(name, rel_attend, rel_attend_sat) |> 
  datatable()


top1 |> 
  filter(name == "Middlebury College") |> 
  select(name, rel_attend, rel_attend_sat)

top1 |> 
  filter(name == "Middlebury College") |> 
  select(name, rel_attend, rel_attend_sat)



chetty_all <- chetty |> 
  select(name, par_income_bin, par_income_lab,
         rel_attend, rel_attend_unwgt, 
         tier_name, test_band_tier) |> 
  filter(!par_income_lab %in% c("99-99.9", "Top 0.1")) |> 
  rename(rel_attend_sat = rel_attend,
         rel_attend = rel_attend_unwgt)

table(chetty_all$par_income_lab)

myplot <- chetty_all |> 
  filter(name == "Middlebury College") |> 
  ggplot(aes(x = par_income_bin, y = rel_attend,
             text = paste(par_income_lab, ":", 
                          round(rel_attend,2)))) +
  geom_point() + geom_line(group = "name")

ggplotly(myplot, tooltip = "text")

library(plotly)
