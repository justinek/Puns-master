d = read.csv("maxSupport.csv")

d$absoluteDiff = abs(d$maxPm1 - d$maxPm2)
d$funniness = f.ratings.orig$funniness

# plot max size of contexts for m1
d.m1.size <- summarySE(d, measurevar="numWordsM1", groupvars=c("sentenceType"))
ggplot(d.m1.size, aes(sentenceType, numWordsM1, fill=sentenceType)) +
  geom_bar(colour="black", size=.3) + 
  geom_errorbar(aes(ymin=numWordsM1-se, ymax=numWordsM1+se),
                size=.3,    # Thinner lines
                width=.2) +
                  theme_bw()

# plot max size of contexts for m2
d.m2.size <- summarySE(d, measurevar="numWordsM2", groupvars=c("sentenceType"))
ggplot(d.m2.size, aes(sentenceType, numWordsM2, fill=sentenceType)) +
  geom_bar(colour="black", size=.3) + 
  geom_errorbar(aes(ymin=numWordsM2-se, ymax=numWordsM2+se),
                size=.3,    # Thinner lines
                width=.2) +
                  theme_bw()

# plot max support for m1
d.m1.summary <- summarySE(d, measurevar="maxPm1", groupvars="sentenceType")
ggplot(d.m1.summary, aes(x=sentenceType, y=maxPm1, fill=sentenceType)) + 
  geom_bar(colour="black", size=.3) + 
  geom_errorbar(aes(ymin=maxPm1-se, ymax=maxPm1+se),
                size=.3,    # Thinner lines
                width=.2) +
                  theme_bw()

# plot max support for m2
d.m2.summary <- summarySE(d, measurevar="maxPm2", groupvars="sentenceType")
ggplot(d.m2.summary, aes(x=sentenceType, y=maxPm2, fill=sentenceType)) + 
  geom_bar(colour="black", size=.3) + 
  geom_errorbar(aes(ymin=maxPm2-se, ymax=maxPm2+se),
                size=.3,    # Thinner lines
                width=.2) +
                  theme_bw()


# plot absolute difference in max support
d.abDiff.summary <- summarySE(d, measurevar="absoluteDiff", groupvars="sentenceType")
ggplot(d.abDiff.summary, aes(x=sentenceType, y=absoluteDiff, fill=sentenceType)) + 
  geom_bar(colour="black", size=.3) + 
             geom_errorbar(aes(ymin=absoluteDiff-se, ymax=absoluteDiff+se),
                           size=.3,    # Thinner lines
                           width=.2) +
                             theme_bw()

ggplot(d, aes(x=log(absoluteDiff), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

# plot difference in max support
d$diff <- d$maxPm1 - d$maxPm2
d.diff.summary <- summarySE(d, measurevar="diff", groupvars="sentenceType")
ggplot(d.diff.summary, aes(x=sentenceType, y=diff, fill=sentenceType)) +
  geom_bar(color="black", size=0.3) +
  geom_errorbar(aes(ymin=diff-se, ymax=diff+se), size=0.3, width=0.2) +
  theme_bw()


# plot absolute difference normalized by size of context
d$maxPm1Normed <- d$maxPm1 / (d$numWordsM1 + 1)
d$maxPm2Normed <- d$maxPm2 / (d$numWordsM2 + 1)
d$normedAbDiff <- abs(d$maxPm1Normed - d$maxPm2Normed)
d.normedDiff <- summarySE(d, measurevar="normedAbDiff", groupvars=c("sentenceType"))
ggplot(d.normedDiff, aes(x=sentenceType, y=normedAbDiff, fill=sentenceType)) +
  geom_bar(color="black", size=0.3) +
  geom_errorbar(aes(ymin=normedAbDiff-se, ymax=normedAbDiff+se), size=0.3, width=0.2) +
  theme_bw()

# correlate with funniness
with(d, cor.test(log(absoluteDiff), funniness))
summary(with(d, lm(funniness ~ abs(log(maxPm1) - log(maxPm2))^2 + log(maxPm1) + log(maxPm2))))
summary(with(d, lm(funniness ~ log(maxPm1) + log(maxPm2))))

summary(with(d, lm(funniness ~ log(normedAbDiff))))
summary(with(d, lm(funniness ~ log(maxPm1Normed) + log(maxPm2Normed))))

# just puns
d.puns <- subset(d, sentenceType == "pun")
with(d.puns, cor.test(log(absoluteDiff), funniness))
with(d.puns, cor.test(log(normedAbDiff), funniness))
summary(with(d.puns, lm(funniness ~ log(maxPm1) + log(maxPm2))))

