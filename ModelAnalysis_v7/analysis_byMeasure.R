##### 
# compare ambiguity measure with free paramters
f.ratings = read.csv("../sentences_funniness_correctness.csv")
f.ratings <- subset(f.ratings, isOrig=="0")
## read in balance measures
balance = read.csv("Measures/Trigram/balance_A1_R12.9.csv")
f.ratings$entropy = balance$entropy
with(f.ratings, cor.test(funniness, entropy))

# filter out de-punned
f.ratings.puns.nonpuns <- subset(f.ratings, sentenceType != "depunned")
with(f.ratings.puns.nonpuns, cor.test(funniness, entropy))

ggplot(f.ratings.puns.nonpuns, aes(x=entropy, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

## read in focus measures
focus = read.csv("Measures/Trigram/focus_A1_R12.9.csv")
f.ratings$KL = focus$KL
f.ratings$minKL = focus$minKL
with(f.ratings, cor.test(funniness, KL))
with(f.ratings, cor.test(funniness, minKL))

# filter out de-punned
f.ratings.puns.nonpuns <- subset(f.ratings, sentenceType != "depunned")
with(f.ratings.puns.nonpuns, cor.test(funniness, KL))
with(f.ratings.puns.nonpuns, cor.test(funniness, minKL))

ggplot(f.ratings.puns.nonpuns, aes(x=KL, y=funniness, color=sentenceType)) + 
  geom_point() +
  theme_bw()

ggplot(f.ratings.puns.nonpuns, aes(x=minKL, y=funniness, color=sentenceType)) + 
  geom_point() +
  theme_bw()

# just looking at puns
f.ratings.puns <- subset(f.ratings, sentenceType == "pun")
with(f.ratings.puns, cor.test(funniness, KL))
with(f.ratings.puns, cor.test(funniness, minKL))

# just looking at nonpuns
f.ratings.nonpuns <- subset(f.ratings, sentenceType == "nonpun")
with(f.ratings.nonpuns, cor.test(funniness, KL))

## both balance and focus
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ entropy * minKL))
summary(lm(data=f.ratings.puns, funniness ~ minKL))


## read in support measures
support = read.csv("Measures/Trigram/support_A80_R20.csv")
f.ratings$maxPm1 <- support$maxPm1
f.ratings$maxPm2 <- support$maxPm2
f.ratings$absDiff <- abs(support$maxPm1 - support$maxPm2)
f.ratings$sumPm1Pm2 <- support$maxPm1 + support$maxPm2
f.ratings$minSupportedProb <- ifelse(support$maxPm1 < support$maxPm2, support$maxPm1, support$maxPm2)

f.ratings$numWordsM1 <- support$numWordsM1
f.ratings$numWordsM2 <- support$numWordsM2
f.ratings$numWords <- support$numWords
# normalize by length of sentence
f.ratings$maxPm1_normed <- f.ratings$maxPm1 / f.ratings$numWords
f.ratings$maxPm2_normed <- f.ratings$maxPm2 / f.ratings$numWords

# filter out de-punned
f.ratings.puns.nonpuns <- subset(f.ratings, sentenceType != "depunned")

with(f.ratings.puns.nonpuns, cor.test(funniness, log(maxPm1)))
with(f.ratings.puns.nonpuns, cor.test(funniness, log(maxPm2)))

with(f.ratings.puns.nonpuns, cor.test(funniness, log(maxPm1_normed)))
with(f.ratings.puns.nonpuns, cor.test(funniness, log(maxPm2_normed)))
with(f.ratings.puns.nonpuns, cor.test(log(maxPm1_normed), log(maxPm2_normed)))

summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(maxPm1) + log(maxPm2)))
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(maxPm1) * log(maxPm2)))
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(absDiff)))
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(maxPm1) + log(maxPm2) + log(absDiff)))
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(sumPm1Pm2)))
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(sumPm1Pm2) + 
  log(maxPm1) + log(maxPm2)))
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(sumPm1Pm2) + 
  log(maxPm1) + log(maxPm2) + log(absDiff)))
summary(lm(data=f.ratings.puns.nonpuns, funniness ~ log(minSupportedProb)))



ggplot(data=f.ratings.puns.nonpuns, aes(x=log(maxPm1), y=funniness, color=sentenceType)) +
  geom_point() + 
  theme_bw()

ggplot(data=f.ratings.puns.nonpuns, aes(x=log(maxPm2), y=funniness, color=sentenceType)) +
  geom_point() + 
  theme_bw()

ggplot(data=f.ratings.puns.nonpuns, aes(x=log(absDiff), y=funniness, color=sentenceType)) +
  geom_point() + 
  theme_bw()

ggplot(data=f.ratings.puns.nonpuns, aes(x=log(sumPm1Pm2), y=funniness, color=sentenceType)) +
  geom_point() + 
  theme_bw()

ggplot(data=f.ratings.puns.nonpuns, aes(x=log(minSupportedProb), y=funniness, color=sentenceType)) +
  geom_point() + 
  theme_bw()


