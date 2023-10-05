# From here: https://www.pewresearch.org/journalism/fact-sheet/social-media-and-news-fact-sheet/

library(tidyverse)
library(haven)

atp <- read_sav("/Users/lawrence/Downloads/W112_Jul22/ATP W112.sav")

# Create ps1 data frame

ps1 <- atp |> 
  select(QKEY, F_GENDER, SMUSE_a_W112, SMUSE_c_W112,
         NEWSPLAT_DIG_b_W112, F_AGECAT, F_EDUCCAT,
         F_RACETHNMOD, GROUP_TRUST_d_W112,
         F_IDEO, MISINFG_W112)

ps1 <- ps1 |> 
  mutate(qkey = as.character(QKEY),
         gender = as.numeric(F_GENDER),
         use_facebook = as.numeric(SMUSE_a_W112),
         use_twitter = as.numeric(SMUSE_c_W112),
         news_social_media = as.numeric(NEWSPLAT_DIG_b_W112),
         age_cat = as.numeric(F_AGECAT),
         educ_cat = as.numeric(F_EDUCCAT),
         racethn = as.numeric(F_RACETHNMOD),
         news_trust = as.numeric(GROUP_TRUST_d_W112),
         ideology = as.numeric(F_IDEO),
         misinformation = as.numeric(MISINFG_W112)) |> 
  select(qkey:misinformation)

ps1 <- ps1 |> 
  mutate(gender = factor(gender, labels = c("Man", "Woman", "Other", "Refused")),
         use_facebook = ifelse(use_facebook==2, 0, use_facebook),
         use_twitter = ifelse(use_twitter==2, 0, use_twitter),
         news_social_media = factor(news_social_media,
                                    labels = c("Never",
                                               "Rarely",
                                               "Sometimes",
                                               "Often",
                                               "Refused")),
         age_cat = factor(age_cat,
                          labels = c("18-29",
                                     "30-49",
                                     "50-64",
                                     "65+",
                                     "Refused")),
         educ_cat = factor(educ_cat,
                           labels = c("College Grad+",
                                      "Some College",
                                      "HS Grad or Less",
                                      "Refused")),
         racethn = factor(racethn,
                          labels = c("White",
                                     "Black",
                                     "Hispanic",
                                     "Other",
                                     "Asian",
                                     "Refused")),
         news_trust = factor(news_trust,
                             labels = c("A lot",
                             "Some",
                             "Not too much",
                             "Not at all",
                             "Refused")),
         ideology = factor(ideology,
                           labels = c("Very Conservative",
                           "Conservative",
                           "Moderate",
                           "Liberal",
                           "Very Liberal",
                           "Refused")))

ps1 <- ps1 |> 
  filter(gender != "Refused",
         news_social_media != "Refused",
         age_cat != "Refused",
         educ_cat != "Refused",
         racethn != "Refused",
         news_trust != "Refused",
         ideology != "Refused",
         misinformation != 99) |> 
  droplevels()

ps1 <- ps1 |> 
  mutate(use_twitter = ifelse(use_twitter == 99, NA, use_twitter),
         use_facebook = ifelse(use_facebook == 99, NA, use_facebook))

mean(ps1$use_facebook)
mean(ps1$use_facebook, na.rm = TRUE)

prop.table(table(ps1$gender, ps1$use_facebook),1)
prop.table(table(ps1$gender, ps1$use_twitter),1)

prop.table(table(ps1$news_social_media))
round(prop.table(table(ps1$age_cat, ps1$news_social_media),1),3)
round(prop.table(table(ps1$educ_cat, ps1$news_social_media),1),3)

round(prop.table(table(ps1$racethn, ps1$news_trust),1),3)

ps1_a <- ps1 |> 
  mutate(ideo_new = ifelse(str_detect(ideology, "Conservative"), "Conservative",
                           ifelse(str_detect(ideology, "Liberal"), "Liberal",
                                  "Moderate")))

table(ps1_a$ideo_new, ps1_a$ideology)

round(prop.table(table(ps1_a$ideo_new, ps1_a$misinformation),1),3)

write.csv(ps1, "data/ps1.csv", row.names = FALSE)


# Create long data

ps1_long <- atp |> 
  select(-SMUSE_h_W112) |> 
  unite(facebook, SMUSE_a_W112, SOCIALNEWS2_a_W112) |> 
  unite(youtube, SMUSE_b_W112, SOCIALNEWS2_b_W112) |> 
  unite(twitter, SMUSE_c_W112, SOCIALNEWS2_c_W112) |> 
  unite(instagram, SMUSE_d_W112, SOCIALNEWS2_d_W112) |> 
  unite(snapchat, SMUSE_e_W112, SOCIALNEWS2_e_W112) |> 
  unite(whatsapp, SMUSE_f_W112, SOCIALNEWS2_f_W112) |> 
  unite(linkedin, SMUSE_g_W112, SOCIALNEWS2_g_W112) |> 
  unite(tiktok, SMUSE_i_W112, SOCIALNEWS2_i_W112) |> 
  unite(reddit, SMUSE_j_W112, SOCIALNEWS2_j_W112) |> 
  unite(twitch, SMUSE_k_W112, SOCIALNEWS2_k_W112) |> 
  unite(nextdoor, SMUSE_l_W112, SOCIALNEWS2_l_W112) |> 
  pivot_longer(names_to = "site", values_to = "use_news", facebook:nextdoor) |> 
  separate(use_news, c("use", "news")) |> 
  filter(use == 1 | use == 2) |> 
  filter(news != 99) |> 
  filter(use != "NA") |> 
  mutate(use = ifelse(use == 2, 0, use)) |> 
  mutate(news = ifelse(news == 2, 0, news)) |> 
  mutate(news = ifelse(news == "NA", 0, news)) |> 
  select(QKEY, site, use, news) |> 
  mutate(qkey = as.character(QKEY),
         use = as.numeric(use),
         news = as.numeric(news)) |> 
  select(-QKEY) |> 
  relocate(qkey)


ps1_long |> 
  group_by(site) |> 
  summarise(prop_use = mean(use)) |> 
  ggplot(aes(x = site, y = prop_use)) + geom_col()

ps1_long |> 
  filter(use == 1) |> 
  group_by(site) |> 
  summarise(prop_news = mean(news)) |> 
  ggplot(aes(x = site, y = prop_news)) + geom_col()

write.csv(ps1_long, "data/ps1_long.csv", row.names = FALSE)

# Test DFs

ps1 <- read_csv("https://raw.githubusercontent.com/mjclawrence/soci385_f23/main/data/ps1.csv")
ps1_long <- read_csv("https://raw.githubusercontent.com/mjclawrence/soci385_f23/main/data/ps1_long.csv")
