##### 
# compare ambiguity measure with trigrams vs not

## read in balance measures generated using trigram probs of content words
balance_3gram = read.csv("balance_v5.csv")
balance_3gram_summary = summarySE(balance_3gram, measurevar="entropy", groupvars=c("sentenceType"))

ggplot(balance_3gram_summary, aes(x=sentenceType, y=entropy, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=entropy-se, ymax=entropy+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))

balance_1gram = read.csv("../ModelAnalysis_v4/Measures/ambiguityMeasures_orig_withHomPrior2.csv")
balance_1gram_summary = summarySE(balance_1gram, measurevar="entropy", groupvars=c("sentenceType"))

ggplot(balance_1gram_summary, aes(x=sentenceType, y=entropy, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=entropy-se, ymax=entropy+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))


summary(lm(data=balance_1gram, entropy ~ sentenceType))
summary(lm(data=balance_3gram, entropy ~ sentenceType))

f.ratings = read.csv("../sentences_funniness_correctness.csv")
f.ratings$entropy_1gram = balance_1gram$entropy
f.ratings$entropy_3gram = balance_3gram$entropy
f.ratings$entropy_1gram_z = scale(f.ratings$entropy_1gram)
f.ratings$entropy_3gram_z = scale(f.ratings$entropy_3gram)

## compare correlations with unigrams and trigrams

with(f.ratings, cor.test(funniness, entropy_1gram))
with(f.ratings, cor.test(funniness, entropy_3gram))

ggplot(data=f.ratings, aes(x=entropy_1gram_z, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(data=f.ratings, aes(x=entropy_3gram_z, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

## examines puns that improved with trigrams

f.improved <- subset(f.ratings, (entropy_1gram_z < entropy_3gram_z) & (sentenceType == "pun"))
f.regressed <- subset(f.ratings, (entropy_1gram_z > entropy_3gram_z) & (sentenceType == "pun"))


##### 
# compare distinctiveness measure with trigrams vs not

## read in distinctiveness measures generated using trigram probs of content words
distinct_3gram = read.csv("distinctiveness_v5.csv")
distinct_3gram_summary = summarySE(distinct_3gram, measurevar="KL", groupvars=c("sentenceType"))
ggplot(distinct_3gram_summary, aes(x=sentenceType, y=KL, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=KL-se, ymax=KL+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))

## read in distinctiveness measures generated using trigram probs of content words -> ASSYMETRC, MINKL!
distinct_min_3gram = read.csv("distinctiveness_v5.csv")
distinct_min_3gram_summary = summarySE(distinct_min_3gram, measurevar="minKL", groupvars=c("sentenceType"))
ggplot(distinct_min_3gram_summary, aes(x=sentenceType, y=minKL, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=minKL-se, ymax=minKL+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))



## read in distinctiveness measures generated using unigram probs of content words

distinct_1gram = read.csv("../ModelAnalysis_v4/Measures/focusMeasures_orig2.csv")
distinct_1gram_summary = summarySE(distinct_1gram, measurevar="KL", groupvars=c("sentenceType"))

ggplot(distinct_1gram_summary, aes(x=sentenceType, y=KL, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=KL-se, ymax=KL+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))

summary(lm(data=distinct_1gram, KL ~ sentenceType))
summary(lm(data=distinct_3gram, KL ~ sentenceType))

f.ratings$KL_1gram = distinct_1gram$KL
f.ratings$KL_3gram = distinct_3gram$KL
f.ratings$KL_1gram_z = scale(f.ratings$KL_1gram)
f.ratings$KL_3gram_z = scale(f.ratings$KL_3gram)
f.ratings$minKL_3gram = distinct_min_3gram$minKL

## compare correlations with unigrams and trigrams

with(f.ratings, cor.test(funniness, KL_1gram_z))
with(f.ratings, cor.test(funniness, KL_3gram_z))

# compare both ambiguity and distinctiveness measures

summary(lm(data=f.ratings, funniness ~ entropy_1gram + KL_1gram))
summary(lm(data=f.ratings, funniness ~ entropy_3gram + KL_3gram))

## read in distinctiveness measures (by word) generated using trigram probs of content words
distinct_byWord_3gram = read.csv("distinctiveness_byWords_v5.csv")
distinct_byWord_3gram_summary = summarySE(distinct_byWord_3gram, measurevar="KL", groupvars=c("sentenceType"))
ggplot(distinct_byWord_3gram_summary, aes(x=sentenceType, y=KL, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=KL-se, ymax=KL+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))

f.ratings$KL_byWord_3gram = distinct_byWord_3gram$KL
f.ratings$minKL_byWord_3gram = distinct_byWord_3gram$minKL

## examines only original sentneces

f.ratings.orig <- subset(f.ratings, isOrig=="0")
f.ratings.orig.puns <- subset(f.ratings.orig, sentenceType=="pun")
with(f.ratings.orig, cor.test(funniness, entropy_1gram))
with(f.ratings.orig, cor.test(funniness, entropy_3gram))
with(f.ratings.orig, cor.test(funniness, KL_1gram))
with(f.ratings.orig, cor.test(funniness, KL_3gram))
with(f.ratings.orig, cor.test(funniness, minKL_3gram))
with(f.ratings.orig, cor.test(funniness, KL_byWord_3gram))
with(f.ratings.orig, cor.test(funniness, minKL_byWord_3gram))

with(f.ratings.orig.puns, cor.test(funniness, entropy_1gram))

ggplot(f.ratings.orig, aes(x=KL_3gram, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()


ambiguity_1gram.orig <- summarySE(f.ratings.orig, measurevar="entropy_1gram_z", groupvars=c("sentenceType"))

ggplot(ambiguity_1gram.orig, aes(x=sentenceType, y=entropy_1gram_z, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=entropy_1gram_z-se, ymax=entropy_1gram_z+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))


ambiguity_3gram.orig <- summarySE(f.ratings.orig, measurevar="entropy_3gram_z", groupvars=c("sentenceType"))

ggplot(ambiguity_3gram.orig, aes(x=sentenceType, y=entropy_3gram_z, fill=sentenceType)) +
  geom_bar(position=position_dodge(),
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
             geom_errorbar(aes(ymin=entropy_3gram_z-se, ymax=entropy_3gram_z+se),
                           size=.3,    # Thinner lines
                           width=.2,
                           position=position_dodge(.9))


summary(lm(data=f.ratings.orig, funniness ~ entropy_1gram + KL_1gram))
summary(lm(data=f.ratings.orig, funniness ~ entropy_3gram + KL_3gram))
summary(lm(data=f.ratings.orig, funniness ~ entropy_3gram + minKL_3gram))
## the best! r^2 = 0.254
summary(lm(data=f.ratings.orig, funniness ~ entropy_3gram + KL_byWord_3gram))
##
summary(lm(data=f.ratings.orig, funniness ~ entropy_3gram + minKL_byWord_3gram))

f.ratings.orig.puns <- subset(f.ratings.orig, sentenceType=="pun")
summary(lm(data=f.ratings.orig.puns, funniness ~ entropy_3gram + KL_byWord_3gram))

