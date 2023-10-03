# From here: https://www.pewresearch.org/journalism/fact-sheet/social-media-and-news-fact-sheet/

library(tidyverse)
library(haven)

atp <- read_sav("/Users/lawrence/Downloads/W112_Jul22/ATP W112.sav")

table(atp$SOCIALNEWS2_a_W112)

prop.table(table(atp$MISINFG_W112))
prop.table(table(atp$MISINFT_W112))

table(atp$MISINFT_W112)

table(atp$F_AGECAT)
table(atp$F_IDEO)

round(prop.table(table(atp$F_AGECAT, atp$F_IDEO),1),3)

# Facebook
prop.table(table(atp$F_GENDER, atp$SMUSE_a_W112),1)
prop.table(table(atp$F_GENDER, atp$SMUSE_a_W112),2)

# Reddit
prop.table(table(atp$SMUSE_j_W112))
prop.table(table(atp$SOCIALNEWS2_j_W112))

table(atp$SMUSE_j_W112, atp$SOCIALNEWS2_j_W112)

prop.table(table(atp$F_GENDER, atp$SOCIALNEWS2_j_W112),1)
prop.table(table(atp$F_GENDER, atp$SOCIALNEWS2_j_W112),2)
