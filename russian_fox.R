# This script performs the econometrics for the fox or sheep paper

# Loading libraries

library(lmtest)
library(ggplot2)

# Setting username + directory

username <- ''
direc <- paste('C:/Users/', username, '/Documents/Data/russian_fox/', sep = '')

# Read in the data

data <- read.csv(paste(direc, 'clean_tweets/classified_data.csv', sep = ''))

# Remove the non-definitive observations (class == 0)

data <- data[which(data$class != 0),]

# Create outcome variable (Y == 1 -> pro-russia)

data$y <- (data$class + 2) %% 3

# Create post X treated variable

data$x <- data$post * data$treated

# Create annual treatment vars

data$T15 <- as.numeric(data$date == 15) * data$treated
data$T17 <- as.numeric(data$date == 17) * data$treated
data$T18 <- as.numeric(data$date == 18) * data$treated
data$T19 <- as.numeric(data$date == 19) * data$treated
data$T20 <- as.numeric(data$date == 20) * data$treated
data$T22 <- as.numeric(data$date == 22) * data$treated
data$T23 <- as.numeric(data$date == 23) * data$treated
data$T24 <- as.numeric(data$date == 24) * data$treated
data$T25 <- as.numeric(data$date == 25) * data$treated
data$T26 <- as.numeric(data$date == 26) * data$treated
data$T27 <- as.numeric(data$date == 27) * data$treated
data$T28 <- as.numeric(data$date == 28) * data$treated

data$XXX <- (data$date - 21)*data$treated

data$X15 <- as.numeric(data$date == 15) * data$XXX
data$X17 <- as.numeric(data$date == 17) * data$XXX
data$X18 <- as.numeric(data$date == 18) * data$XXX
data$X19 <- as.numeric(data$date == 19) * data$XXX
data$X20 <- as.numeric(data$date == 20) * data$XXX
data$X22 <- as.numeric(data$date == 22) * data$XXX
data$X23 <- as.numeric(data$date == 23) * data$XXX
data$X24 <- as.numeric(data$date == 24) * data$XXX
data$X25 <- as.numeric(data$date == 25) * data$XXX
data$X26 <- as.numeric(data$date == 26) * data$XXX
data$X27 <- as.numeric(data$date == 27) * data$XXX
data$X28 <- as.numeric(data$date == 28) * data$XXX

# Specify the DID model

mod0 <- lm(y ~ x + post + treated, data = data)

mod1 <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
           + age + factor(source) + factor(rt) + factor(qt), data = data)

mod2 <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
            + age + factor(source) + factor(rt) + factor(qt) + factor(date), data = data)

mod3 <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
           + age + factor(source) + factor(rt) + factor(qt) + factor(screen_name), data = data)

mod4 <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
           + age + factor(source) + factor(rt) + factor(qt) + factor(screen_name) + factor(date), data = data)

mod5 <- lm(y ~ X15 + X17 + X18 + X19 + X20 + X22 + X23 + X24 + X25 + X26 + X27 + X28
             + factor(type) + factor(state) + factor(gender) + age + factor(source)
             + factor(rt) + factor(qt) + factor(screen_name) + factor(date), data = data)

m0 <- coeftest(mod0, vcov = vcovCL, cluster = ~treated)
m1 <- coeftest(mod1, vcov = vcovCL, cluster = ~treated)
m2 <- coeftest(mod2, vcov = vcovCL, cluster = ~treated)
m3 <- coeftest(mod3, vcov = vcovCL, cluster = ~treated)
m4 <- coeftest(mod4, vcov = vcovCL, cluster = ~treated)
m5 <- coeftest(mod5, vcov = vcovCL, cluster = ~treated)

m0
m1
m2
m3
m4
m5

# Save results

write.csv(m0, paste(direc, 'results/m0.txt', sep = ''))
write.csv(m1, paste(direc, 'results/m1.txt', sep = ''))
write.csv(m2, paste(direc, 'results/m2.txt', sep = ''))
write.csv(m3, paste(direc, 'results/m3.txt', sep = ''))
write.csv(m4, paste(direc, 'results/m4.txt', sep = ''))
write.csv(m5, paste(direc, 'results/m5.txt', sep = ''))

# Repeat only using those congresspeople who tweeted both pre and post event

pre <- data[which(data$pre == 1),]
post <- data[which(data$pre == 0),]
drops <- c()
keeps <- c()

for (s in unique(data$screen_name)) {
  
  a <- dim(pre[which(pre$screen_name == s),])[1]
  b <- dim(post[which(post$screen_name == s),])[1]
  
  if (a*b == 0) {
    
    drops <- c(drops, s)
    
  } else {
    
    keeps <- c(keeps, s)
    
  }
  
}

datax <- data[which(data$screen_name %in% keeps),]

# Specify the DID model

mod0x <- lm(y ~ x + post + treated, data = datax)

mod1x <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
           + age + factor(source) + factor(rt) + factor(qt), data = datax)

mod2x <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
           + age + factor(source) + factor(rt) + factor(qt) + factor(date), data = datax)

mod3x <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
           + age + factor(source) + factor(rt) + factor(qt) + factor(screen_name), data = datax)

mod4x <- lm(y ~ x + post + treated + factor(type) + factor(state) + factor(gender)
           + age + factor(source) + factor(rt) + factor(qt) + factor(screen_name) + factor(date), data = datax)

mod5x <- lm(y ~ X15 + X17 + X18 + X19 + X20 + X22 + X23 + X24 + X25 + X26 + X27 + X28
           + factor(type) + factor(state) + factor(gender) + age + factor(source)
           + factor(rt) + factor(qt) + factor(screen_name), data = datax)

m0x <- coeftest(mod0x, vcov = vcovCL, cluster = ~treated)
m1x <- coeftest(mod1x, vcov = vcovCL, cluster = ~treated)
m2x <- coeftest(mod2x, vcov = vcovCL, cluster = ~treated)
m3x <- coeftest(mod3x, vcov = vcovCL, cluster = ~treated)
m4x <- coeftest(mod4x, vcov = vcovCL, cluster = ~treated)
m5x <- coeftest(mod5x, vcov = vcovCL, cluster = ~treated)

# Generate some figures

r.data <- data[which(data$party == 'Republican'),]
d.data <- data[which(data$party == 'Democrat'),]

# DID plot

ests <- m5[7:13]
sers <- m5[((dim(m5)[1])+7):((dim(m5)[1])+13)]
sers <- 1.96*sers
base = c(1:7)
dfx <- data.frame(base, ests, sers)

ggplot(dfx, aes(x = base, y = ests)) +
  theme_bw() +
  ggtitle('Treatment Effects') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Effect Size') +
  xlab('Days Since Event') +
  geom_point() +
  geom_errorbar(aes(ymin = ests - sers, ymax = ests + sers), width = .2) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_hline(yintercept = 0)

dev.copy(png, paste(direc, 'figures/did.png', sep = ''))
dev.off()

# Relevant tweets per day - count

r.counts <- c()
d.counts <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp <- r.data[which(r.data$date == d),]
  d.tmp <- d.data[which(d.data$date == d),]
  
  r.counts <- c(r.counts, dim(r.tmp)[1])
  d.counts <- c(d.counts, dim(d.tmp)[1])
  
}

df1 <- data.frame(base, r.counts, d.counts)

ggplot(df1, aes(x = Bin, y = fit.all)) +
  theme_bw() +
  ggtitle('Tweets per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Tweets') +
  xlab('Date') +
  geom_line(data = df1, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_line(data = df1, aes(x = base, y = d.counts, color = 'Democrat')) +
  geom_point(data = df1, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_point(data = df1, aes(x = base, y = d.counts, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/tweet_counts.png', sep = ''))
dev.off()

# Pro-Russia tweets per day - count

r.counts <- c()
d.counts <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp <- r.data[which(r.data$date == d),]
  r.tmp <- r.tmp[which(r.tmp$class == -1),]
  d.tmp <- d.data[which(d.data$date == d),]
  d.tmp <- d.tmp[which(d.tmp$class == -1),]
  
  r.counts <- c(r.counts, dim(r.tmp)[1])
  d.counts <- c(d.counts, dim(d.tmp)[1])
  
}

df2 <- data.frame(base, r.counts, d.counts)

ggplot(df2, aes(x = Bin, y = fit.all)) +
  theme_bw() +
  ggtitle('Anti-Ukraine tweets per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Tweets') +
  xlab('Date') +
  geom_line(data = df2, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_line(data = df2, aes(x = base, y = d.counts, color = 'Democrat')) +
  geom_point(data = df2, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_point(data = df2, aes(x = base, y = d.counts, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/russia_counts.png', sep = ''))
dev.off()


# Pro-Russia tweets per day - proportion

r.pcts <- c()
d.pcts <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp1 <- r.data[which(r.data$date == d),]
  r.tmp2 <- r.tmp1[which(r.tmp1$class == -1),]
  d.tmp1 <- d.data[which(d.data$date == d),]
  d.tmp2 <- d.tmp1[which(d.tmp1$class == -1),]
  
  if (d == 16) {
    
    r.pcts <- c(r.pcts, 0)
    d.pcts <- c(d.pcts, 0)
    
  } else {
      
    r.pcts <- c(r.pcts, 100 * dim(r.tmp2)[1] / dim(r.tmp1)[1])
    d.pcts <- c(d.pcts, 100 * dim(d.tmp2)[1] / dim(d.tmp1)[1])
    
  }
  
}

df2 <- data.frame(base, r.pcts, d.pcts)

ggplot(df2, aes(x = Bin, y = fit.all)) +
  theme_bw() +
  ggtitle('Anti-Ukraine proportion of tweets per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Percentage') +
  xlab('Date') +
  geom_line(data = df2, aes(x = base, y = r.pcts, color = 'Republican')) +
  geom_line(data = df2, aes(x = base, y = d.pcts, color = 'Democrat')) +
  geom_point(data = df2, aes(x = base, y = r.pcts, color = 'Republican')) +
  geom_point(data = df2, aes(x = base, y = d.pcts, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/russia_pcts.png', sep = ''))
dev.off()

# Fox tweets - percent

r.fox <- c()
d.fox <- c()
r.fox2 <- c()
d.fox2 <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp1 <- r.data[which(r.data$date == d),]
  r.tmp2 <- r.tmp1[which(r.tmp1$fox == 1),]
  d.tmp1 <- d.data[which(d.data$date == d),]
  d.tmp2 <- d.tmp1[which(d.tmp1$fox == 1),]
  
  if (d == 16) {
    
    r.fox <- c(r.fox, 0)
    d.fox <- c(d.fox, 0)
    r.fox2 <- c(r.fox2, 0)
    d.fox2 <- c(d.fox2, 0)
    
  } else {
    
    r.fox <- c(r.fox, 100 * dim(r.tmp2)[1] / dim(r.tmp1)[1])
    d.fox <- c(d.fox, 100 * dim(d.tmp2)[1] / dim(d.tmp1)[1])
    r.fox2 <- c(r.fox2, dim(r.tmp2)[1])
    d.fox2 <- c(d.fox2, dim(d.tmp2)[1])
    
  }
  
}

df4 <- data.frame(base, r.fox, d.fox, r.fox2, d.fox2)

ggplot(df4, aes()) +
  theme_bw() +
  ggtitle('Tweets mentioning FOX per day by party - proportion') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Percentage') +
  xlab('Date') +
  geom_line(data = df4, aes(x = base, y = r.fox, color = 'Republican')) +
  geom_line(data = df4, aes(x = base, y = d.fox, color = 'Democrat')) +
  geom_point(data = df4, aes(x = base, y = r.fox, color = 'Republican')) +
  geom_point(data = df4, aes(x = base, y = d.fox, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/fox_pcts.png', sep = ''))
dev.off()

# FOX tweets - count

ggplot(df4, aes()) +
  theme_bw() +
  ggtitle('Tweets mentioning FOX per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Percentage') +
  xlab('Date') +
  geom_line(data = df4, aes(x = base, y = r.fox2, color = 'Republican')) +
  geom_line(data = df4, aes(x = base, y = d.fox2, color = 'Democrat')) +
  geom_point(data = df4, aes(x = base, y = r.fox2, color = 'Republican')) +
  geom_point(data = df4, aes(x = base, y = d.fox2, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/fox.png', sep = ''))
dev.off()

# Generate some figures with subsetted data

r.data <- datax[which(datax$party == 'Republican'),]
d.data <- datax[which(datax$party == 'Democrat'),]

# DID plot

ests <- m5x[7:13]
sers <- m5x[((dim(m5x)[1])+7):((dim(m5x)[1])+13)]
sers <- 1.96*sers
base = c(1:7)
dfx <- data.frame(base, ests, sers)

ggplot(dfx, aes(x = base, y = ests)) +
  theme_bw() +
  ggtitle('Treatment Effects') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Effect Size') +
  xlab('Days Since Event') +
  geom_point() +
  geom_errorbar(aes(ymin = ests - sers, ymax = ests + sers), width = .2) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_hline(yintercept = 0)

dev.copy(png, paste(direc, 'figures/did_x.png', sep = ''))
dev.off()

# DID plot - joint

ests2 <- m5[7:13]
sers2 <- m5[((dim(m5)[1])+7):((dim(m5)[1])+13)]
sers2 <- 1.96*sers2
base = c(1:7)
dfxx <- data.frame(base, ests, sers, ests2, sers2)

ggplot(dfxx, aes(x = base, y = ests)) +
  theme_bw() +
  ggtitle('Treatment Effects') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Effect Size') +
  xlab('Days Since Event') +
  geom_point(data = dfxx, aes(x = base, y = ests2, color = 'All Users')) +
  geom_point(data = dfxx, aes(x = base, y = ests, color = 'Subsetted Users')) +
  geom_errorbar(aes(ymin = ests - sers, ymax = ests + sers), width = .2) +
  geom_errorbar(aes(ymin = ests2 - sers2, ymax = ests2 + sers2), width = .2) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_hline(yintercept = 0) +
  scale_color_manual(name = 'User Types', breaks = c('All Users', 'Subsetted Users'),
                   values = c('All Users' = 'blue', 'Subsetted Users' = 'red'))

dev.copy(png, paste(direc, 'figures/did_all.png', sep = ''))
dev.off()

# Relevant tweets per day - count

r.counts <- c()
d.counts <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp <- r.data[which(r.data$date == d),]
  d.tmp <- d.data[which(d.data$date == d),]
  
  r.counts <- c(r.counts, dim(r.tmp)[1])
  d.counts <- c(d.counts, dim(d.tmp)[1])
  
}

df1 <- data.frame(base, r.counts, d.counts)

ggplot(df1, aes(x = Bin, y = fit.all)) +
  theme_bw() +
  ggtitle('Tweets per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Tweets') +
  xlab('Date') +
  geom_line(data = df1, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_line(data = df1, aes(x = base, y = d.counts, color = 'Democrat')) +
  geom_point(data = df1, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_point(data = df1, aes(x = base, y = d.counts, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/tweet_counts_x.png', sep = ''))
dev.off()

# Pro-Russia tweets per day - count

r.counts <- c()
d.counts <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp <- r.data[which(r.data$date == d),]
  r.tmp <- r.tmp[which(r.tmp$class == -1),]
  d.tmp <- d.data[which(d.data$date == d),]
  d.tmp <- d.tmp[which(d.tmp$class == -1),]
  
  r.counts <- c(r.counts, dim(r.tmp)[1])
  d.counts <- c(d.counts, dim(d.tmp)[1])
  
}

df2 <- data.frame(base, r.counts, d.counts)

ggplot(df2, aes(x = Bin, y = fit.all)) +
  theme_bw() +
  ggtitle('Anti-Ukraine tweets per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Tweets') +
  xlab('Date') +
  geom_line(data = df2, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_line(data = df2, aes(x = base, y = d.counts, color = 'Democrat')) +
  geom_point(data = df2, aes(x = base, y = r.counts, color = 'Republican')) +
  geom_point(data = df2, aes(x = base, y = d.counts, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/russia_counts_x.png', sep = ''))
dev.off()


# Pro-Russia tweets per day - proportion

r.pcts <- c()
d.pcts <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp1 <- r.data[which(r.data$date == d),]
  r.tmp2 <- r.tmp1[which(r.tmp1$class == -1),]
  d.tmp1 <- d.data[which(d.data$date == d),]
  d.tmp2 <- d.tmp1[which(d.tmp1$class == -1),]
  
  if (d == 16) {
    
    r.pcts <- c(r.pcts, 0)
    d.pcts <- c(d.pcts, 0)
    
  } else {
    
    r.pcts <- c(r.pcts, 100 * dim(r.tmp2)[1] / dim(r.tmp1)[1])
    d.pcts <- c(d.pcts, 100 * dim(d.tmp2)[1] / dim(d.tmp1)[1])
    
  }
  
}

df2 <- data.frame(base, r.pcts, d.pcts)

ggplot(df2, aes(x = Bin, y = fit.all)) +
  theme_bw() +
  ggtitle('Anti-Ukraine proportion of tweets per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Percentage') +
  xlab('Date') +
  geom_line(data = df2, aes(x = base, y = r.pcts, color = 'Republican')) +
  geom_line(data = df2, aes(x = base, y = d.pcts, color = 'Democrat')) +
  geom_point(data = df2, aes(x = base, y = r.pcts, color = 'Republican')) +
  geom_point(data = df2, aes(x = base, y = d.pcts, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/russia_pcts_x.png', sep = ''))
dev.off()

# Fox tweets - percent

r.fox <- c()
d.fox <- c()
r.fox2 <- c()
d.fox2 <- c()
base <- c()

for (d in min(unique(data$date)):max(unique(data$date))) {
  
  base <- c(base, d)
  
  r.tmp1 <- r.data[which(r.data$date == d),]
  r.tmp2 <- r.tmp1[which(r.tmp1$fox == 1),]
  d.tmp1 <- d.data[which(d.data$date == d),]
  d.tmp2 <- d.tmp1[which(d.tmp1$fox == 1),]
  
  if (d == 16) {
    
    r.fox <- c(r.fox, 0)
    d.fox <- c(d.fox, 0)
    r.fox2 <- c(r.fox2, 0)
    d.fox2 <- c(d.fox2, 0)
    
  } else {
    
    r.fox <- c(r.fox, 100 * dim(r.tmp2)[1] / dim(r.tmp1)[1])
    d.fox <- c(d.fox, 100 * dim(d.tmp2)[1] / dim(d.tmp1)[1])
    r.fox2 <- c(r.fox2, dim(r.tmp2)[1])
    d.fox2 <- c(d.fox2, dim(d.tmp2)[1])
    
  }
  
}

df4 <- data.frame(base, r.fox, d.fox, r.fox2, d.fox2)

ggplot(df4, aes()) +
  theme_bw() +
  ggtitle('Tweets mentioning FOX per day by party - proportion') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Percentage') +
  xlab('Date') +
  geom_line(data = df4, aes(x = base, y = r.fox, color = 'Republican')) +
  geom_line(data = df4, aes(x = base, y = d.fox, color = 'Democrat')) +
  geom_point(data = df4, aes(x = base, y = r.fox, color = 'Republican')) +
  geom_point(data = df4, aes(x = base, y = d.fox, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/fox_pcts_x.png', sep = ''))
dev.off()

# FOX tweets - count

ggplot(df4, aes()) +
  theme_bw() +
  ggtitle('Tweets mentioning FOX per day by party') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Percentage') +
  xlab('Date') +
  geom_line(data = df4, aes(x = base, y = r.fox2, color = 'Republican')) +
  geom_line(data = df4, aes(x = base, y = d.fox2, color = 'Democrat')) +
  geom_point(data = df4, aes(x = base, y = r.fox2, color = 'Republican')) +
  geom_point(data = df4, aes(x = base, y = d.fox2, color = 'Democrat')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = length(base))) +
  geom_vline(xintercept = 21) +
  scale_color_manual(name = 'Party', breaks = c('Democrat', 'Republican'),
                     values = c('Democrat' = 'blue', 'Republican' = 'red'))

dev.copy(png, paste(direc, 'figures/fox_x.png', sep = ''))
dev.off()

