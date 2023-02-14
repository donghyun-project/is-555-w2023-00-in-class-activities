library(tidyverse)

df1 <- read_csv('https://www.dropbox.com/s/df2w04r0c09kw3f/df_1.csv?dl=1')
df2 <- read_csv('https://www.dropbox.com/s/xfp1qzxvo19ym0x/df_2.csv?dl=1')
df3 <- read_csv('https://www.dropbox.com/s/uzusr9723ffn546/df_3.csv?dl=1')
df4 <- read_csv('https://www.dropbox.com/s/js8tehtsk7btpeq/df_4.csv?dl=1')

df1 %>% summarize_all(list(mean=mean, sd=sd))
df2 %>% summarize_all(list(mean=mean, sd=sd))
df3 %>% summarize_all(list(mean=mean, sd=sd))
df4 %>% summarize_all(list(mean=mean, sd=sd))



df1 %>% summarize_all(list(mean=mean, sd=sd))
df1 %>% cor()
lm(y ~ x, data = df1) %>% coefficients()

df1 %>% 
  ggplot(aes(x=x, y=y)) +
  geom_point()

bind_rows(df1, df2, df3, df4, .id = 'df') %>% 
  ggplot (aes (x = x, fill = df)) +
  geom_density()

bind_rows(df1, df2, df3, df4, .id = 'df') %>% 
  ggplot (aes (x = x, y = y, color = df)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  facet_wrap(~df)
