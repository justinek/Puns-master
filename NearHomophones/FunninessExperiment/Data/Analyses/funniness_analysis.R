# reads in raw funniness ratings in long form
f <- read.csv("../data_long.csv")

# computes mean and sd for each sentence
f.summary <- summarySE(f, measurevar="zscored", groupvars="uniqueID")

# reads in sentence information
sentences <- read.delim("../../../Materials/sentences_all.txt")

# adds in funniness rating for each sentences
sentences$rating = f.summary$zscored

# checks for weird effects of condition, etc
summary(lm(data=sentences, rating ~ condition))

# summarizes funniness rating for sentence type
sentences.summary <- summarySE(sentences, measurevar="rating", groupvars=c("sentenceType", "version"))

# plot
ggplot(sentences.summary, aes(x=sentenceType, y=rating, fill=version)) +
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  geom_errorbar(position=position_dodge(0.9), aes(ymin=rating-ci, ymax=rating+ci),
                width=.2) +
                  theme_bw()


# randomly splits funniness long form data in half

n <- nrow(f)
sample.1 <- sort(sample(1:n, n/2)) 
sample.2 <- (1:n)[-sample.1]
data.1 <- f[sample.1,]
data.2 <- f[sample.2,]

# summarizes ratings for two halves
funniness_summary.1 = summarySE(data.1, measurevar="funniness", groupvars = c("uniqueID"))
funniness_summary.2 = summarySE(data.2, measurevar="funniness", groupvars = c("uniqueID"))

# combines sentences data with the ratings from the split halves
sentences.rating.1 <- sentences
sentences.rating.1$funniness = funniness_summary.1$funniness

sentences.rating.2 <- sentences
sentences.rating.2$funniness = funniness_summary.2$funniness

# creates dataframe containing sample 1 and sample 2
splithalf = sentences
splithalf$funniness1 = sentences.rating.1$funniness
splithalf$funniness2 = sentences.rating.2$funniness

# correlation between the full split samples
cor.test(splithalf$funniness1, splithalf$funniness2)

# correlation between only the puns
splithalf.puns <- subset(splithalf, sentenceType=="pun")
with(splithalf.puns, cor.test(funniness1, funniness2))

# correlation between only the original puns
splithalf.puns.a <- subset(splithalf, sentenceType=="pun" & version=="a")
with(splithalf.puns.a, cor.test(funniness1, funniness2))

# correlation between only the nonpuns
splithalf.nonpuns <- subset(splithalf, sentenceType=="nonpun")
with(splithalf.nonpuns, cor.test(funniness1, funniness2))

## plot and visualize the split half correlations for funniness for all sentences
ggplot(splithalf, aes(x=funniness1, y=funniness2, color=sentenceType, shape=version)) +
  geom_point() +
  theme_bw() +
  opts(title="Split half correlation of funniness for all sentences")


letterDist <- read.delim("../../../Materials/nearPuns_letterDist.txt")
sentences$letterDist <- letterDist$letterDist

with(sentences, cor.test(rating, letterDist))


phoneDist <- read.delim("../../../Materials/nearPuns_phoneDist.txt")
sentences$phoneDist <- phoneDist$phoneDist
sentences$phoneDist_norm <- phoneDist$normalizedDist

with(sentences, cor.test(rating, phoneDist))
with(sentences, cor.test(rating, phoneDist_norm))

