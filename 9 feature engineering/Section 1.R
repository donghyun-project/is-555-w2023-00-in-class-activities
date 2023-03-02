library(tidyverse)

df_raw <- read_csv('/Users/dongking/Documents/GitHub/is-555-w2023-00-in-class-activities/HomeController.csv')

df_raw %>% glimpse

# Data Dictionary:
# 
# $ PassengerId  = passenger identifier
# $ Survived     = did the passenger survive?
# $ Pclass       = passenger class (1st, 2nd, 3rd)
# $ Name         = passenger name
# $ Sex          = passenger sex
# $ Age          = passenger age
# $ SibSp        = number of this passenger's siblings or spouses on board
# $ Parch        = number of this passenger's parents or children on board
# $ Ticket       = ticket number
# $ Fare         = ticket cost
# $ Cabin        = cabin number
# $ Embarked     = Port of embarkation (C=Cherbourg, Q=Queenstown, S=Southampton)

df <- df_raw %>% janitor::clean_names()


# Missingness -------------------------------------------------------------------------------------------
# Algorithms don't like missing values. It messes with the math.

# Get a feel for the missingness
df %>% 
  summarize(across(everything(), ~sum(is.na(.x)))) # Column is represented as .x

df %>% 
  summarize(survived = sum(is.na(survived())))




# first check: is the missingness relevant?
# use summarize across
df %>% 
  group_by(is.na(age)) %>% 
  summarize(across(everything(), ~mean(.x, na_rm = T)))

# fill in missing age values, check our work
df <- df %>% 
  mutate(age = if_else(is.na(age), mean(age, na.rm = T), age)) 

# now handle embarked, this time using replace_na()
# Again, check our work
df %>% 
  mutate(embarked = replace_na(embarked, 'O'))


# What about cabin missingness? Random?
# use summarize across again.
# context: private cabins were assigned for some but not all.
df %>% 
  group_by(is.na(cabin)) %>% 
  summarize(across(everything(), ~mean(.x, na_rm = T)))




# Outlier Treatments ------------------------------------------------------------------------------------

outlier_candidates <- c('age', 'sib_sp', 'parch', 'fare')

# Pass the four columns to summary() to check means, maxes
df %>% 
  select(all_of(outlier_candidates)) %>% 
  summary()

# calculate extreme threshold caps based on 99th percentile
age_cap <- quantile(df$age, .99)
sib_sp_cap <- quantile(df$sib_sp, .99)
parch_cap <- quantile(df$parch, .99)
fare_cap <- quantile(df$fare, .99)

# Optional: Create a tibble for easy comparison:

# Now check how many are beyond the percentile caps





# cap age and fare, and check work before saving


# save the result to df




# Transforming Features ---------------------------------------------------------------------------------
# Here's the basic idea behind Box-Cox transformations:
tribble(
  ~value_orig, ~transformation, ~value_tr,
  30,          'y^-3',         30^-3,
  30,          'y^-2',         30^-2,
  30,          'y^-1',         30^-1,
  30,          'y^-(1/2)',     30^-(1/2),
  30,          'log(y)',       log(30),
  30,          'y^(1/2)',      30^(1/2),
  30,          'y^1',          30^1,
  30,          'y^2',          30^2,
  30,          'y^3',          30^3
)


# Examine distributions of age and fare


# Let's transform the fare column
# y^-2
# y^-1
# y^-(1/2)
# log(y)
# y^(1/2)
# y^1
# y^2
# 
# Don't worry. I'll give you the code. :) 
df %>% 
  mutate(
    fare_t2_ = fare^-2,
    fare_t1_ = fare^-1,
    fare_th_ = fare^-(1/2),
    fare_tln = log(fare),
    fare_th  = fare^(1/2),
    fare_t1  = fare^1,
    fare_t2  = fare^2
  ) 

# now let's visualize the effect of the transformations to see 
# which one makes sense.




