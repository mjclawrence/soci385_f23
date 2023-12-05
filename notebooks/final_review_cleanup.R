# Load packages

library(tidyverse)
library(weights)
library(DT)
library(pollster)


library(shiny)


library(shinythemes)

# Load the data

## For the final app we will want local data files
## For now we can use the web versions

#tiger <- read_csv("https://raw.githubusercontent.com/mjclawrence/soci485_f22/master/data/tiger_w74_92.csv")
#write.csv(tiger, "data/final_review.csv", row.names = FALSE)

final <- read_csv("https://raw.githubusercontent.com/mjclawrence/soci385_f23/main/data/final_review.csv")

final <- final |> 
  mutate(accountable = ifelse(cancul1 == "Accountable", 1, 0)) |> 
  mutate(crimsent = factor(crimsent,
                           levels = c("Too little time",
                                      "About the right amount",
                                      "Too much time"))) |> 
  mutate(race = factor(race,
                       levels = c("White", "Asian", "Black", "Hispanic",
                                  "Other", "Refused"))) |> 
  drop_na()

#write.csv(final, "data/final_review.csv", row.names = FALSE)

final |> 
  group_by(crimsent) |> 
  summarise(accountable = mean(accountable, na.rm = TRUE))

model1 <- lm(accountable ~ crimsent, data = final, weights = weight_w92)
summary(model1)

model2 <- lm(accountable ~ crimsent + ideology, data = final, weights = weight_w92)
summary(model2)

model3 <- lm(accountable ~ crimsent * ideology, data = final, weights = weight_w92)
summary(model3)

final <- final |> 
  mutate(pred = model3$fitted.values)

final |> 
  group_by(ideology, crimsent) |> 
  summarise(mean_pred = mean(pred)) |> 
  ggplot(aes(x = crimsent, y = mean_pred, fill = crimsent)) + geom_col() +
  facet_grid(.~ideology) +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, vjust = .5))

|> 
  pivot_wider(names_from = "crimsent", values_from = "mean_pred")
