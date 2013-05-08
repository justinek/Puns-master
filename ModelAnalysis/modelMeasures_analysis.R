# analyzies max KL measures (no homophone prior!) for original sentences
# to see how they differ across sentence types
d.m = read.csv("Measures/maxKL_noHomPrior_orig.csv")

summary(lm(data=d.m, maxKL ~ sentenceType))

d.m.puns.depuns = d.m[d.m$sentenceType != "nonpun",]
summary(lm(data=d.m.puns.depuns, maxKL ~ sentenceType))

# reads in funniness and correctness ratings for sentences
d.fc = read.csv("../sentences_funniness_correctness.csv")
d.fc.orig = d.fc[d.fc$isOrig == 0,]
d.fc.orig$measure1 = d.m$maxKL


# compute mean and sd of maxKL for different sentence types
m1.summary = summarySE(d.fc.orig, measurevar="measure1", groupvars=c("sentenceType"))

ggplot(m1.summary, aes(x=sentenceType, y=measure1)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure1-ci, ymax=measure1+ci),
                width=.2) +
                  theme_bw()

# compute correlation between funniness and measure
with(d.fc.orig, cor.test(funniness, measure1))

# for just puns and depunned
d.fc.orig.puns.depuns = d.fc.orig[d.fc.orig$sentenceType != "nonpun",]
# remove 0s
d.fc.orig.puns.depuns.clean = d.fc.orig.puns.depuns[d.fc.orig.puns.depuns$measure1 != 0,]
with(d.fc.orig.puns.depuns.clean, cor.test(funniness, measure1))
## it's significant!!! :)
with(d.fc.orig.puns.depuns.clean, cor.test(funniness, log(measure1)))
# plot this
ggplot(d.fc.orig.puns.depuns.clean, aes(x=log(measure1), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

# for just puns
d.fc.orig.puns.clean = d.fc.orig.puns.depuns.clean[d.fc.orig.puns.depuns.clean$sentenceType=="pun",]
# not significant :( -> this means that earlier significance primarily driven by sentence type
with(d.fc.orig.puns.clean, cor.test(funniness, log(measure1)))
# plot this
ggplot(d.fc.orig.puns.clean, aes(x=log(measure1), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()


# analyzies average KL measures (no homophone prior!) for original sentences
# to see how they differ across sentence types
d.m2 = read.csv("Measures/aveKL_noHomPrior_orig.csv")

summary(lm(data=d.m2, averageKL ~ sentenceType))
summary(lm(data=d.m2, sumKL ~ sentenceType))

d.m2.puns.depuns = d.m2[d.m2$sentenceType != "nonpun",]
summary(lm(data=d.m2.puns.depuns, averageKL ~ sentenceType))

# reads in funniness and correctness ratings for sentences

d.fc.orig$measure2 = d.m2$averageKL


# compute mean and sd of maxKL for different sentence types
m2.summary = summarySE(d.fc.orig, measurevar="measure2", groupvars=c("sentenceType"))

ggplot(m2.summary, aes(x=sentenceType, y=measure2, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure2-ci, ymax=measure2+ci),
                width=.2) +
                  theme_bw()

# compute correlation between funniness and measure
with(d.fc.orig, cor.test(funniness, measure2))

# for just puns and depunned
d.fc.orig.puns.depuns = d.fc.orig[d.fc.orig$sentenceType != "nonpun",]
# remove 0s
d.fc.orig.puns.depuns.clean = d.fc.orig.puns.depuns[d.fc.orig.puns.depuns$measure1 != 0,]
with(d.fc.orig.puns.depuns.clean, cor.test(funniness, measure2))
## it's significant!!! :)
with(d.fc.orig.puns.depuns.clean, cor.test(funniness, log(measure2)))
# plot this
ggplot(d.fc.orig.puns.depuns.clean, aes(x=log(measure2), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

# for just puns
d.fc.orig.puns.clean = d.fc.orig.puns.depuns.clean[d.fc.orig.puns.depuns.clean$sentenceType=="pun",]
# not significant :( -> this means that earlier significance primarily driven by sentence type
with(d.fc.orig.puns.clean, cor.test(funniness, log(measure2)))
# plot this
ggplot(d.fc.orig.puns.clean, aes(x=log(measure1), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()


# analyzies max KL measures (with homophone prior!) for original sentences
# to see how they differ across sentence types
d.m.3 = read.csv("Measures/maxKL_homPrior_orig.csv")

summary(lm(data=d.m.3, maxKL ~ sentenceType))

d.m.3.puns.depuns = d.m.3[d.m.3$sentenceType != "nonpun",]
summary(lm(data=d.m.3.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure3 = d.m.3$maxKL

# compute mean and sd of maxKL for different sentence types
m3.summary = summarySE(d.fc.orig, measurevar="measure3", groupvars=c("sentenceType"))

ggplot(m3.summary, aes(x=sentenceType, y=measure3, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure3-ci, ymax=measure3+ci),
                width=.2) +
                  theme_bw()


# analyzies average KL measures (with homophone prior!) for original sentences
# to see how they differ across sentence types
d.m.4 = read.csv("Measures/aveKL_homPrior_orig.csv")

summary(lm(data=d.m.4, aveKL ~ sentenceType))
summary(lm(data=d.m.4, sumKL ~ sentenceType))

d.m.4.puns.depuns = d.m.4[d.m.4$sentenceType != "nonpun",]
summary(lm(data=d.m.4.puns.depuns, aveKL ~ sentenceType))

d.fc.orig$measure4 = d.m.4$aveKL

# compute mean and sd of maxKL for different sentence types
m4.summary = summarySE(d.fc.orig, measurevar="measure4", groupvars=c("sentenceType"))

ggplot(m4.summary, aes(x=sentenceType, y=measure4, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure4-ci, ymax=measure4+ci),
                width=.2) +
                  theme_bw()



# analyzies max KL measures (with homophone prior!) for original sentences (with normalized context size!)
# to see how they differ across sentence types
d.m.5 = read.csv("Measures/maxKL_homPrior_normalizeContextLength_orig.csv")

summary(lm(data=d.m.5, maxKL ~ sentenceType))

d.m.5.puns.depuns = d.m.5[d.m.5$sentenceType != "nonpun",]
summary(lm(data=d.m.5.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure5 = d.m.5$maxKL

# compute mean and sd of maxKL for different sentence types
m5.summary = summarySE(d.fc.orig, measurevar="measure5", groupvars=c("sentenceType"))

ggplot(m5.summary, aes(x=sentenceType, y=measure5, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure5-ci, ymax=measure5+ci),
                width=.2) +
                  theme_bw()


# analyzes average KL measures (with homophone prior!) for original sentences (with normalized context size!)
# to see how they differ across sentence types
d.m.6 = read.csv("Measures/aveKL_homPrior_normalizeContextLength_orig.csv")

summary(lm(data=d.m.6, aveKL ~ sentenceType))

d.m.6.puns.depuns = d.m.6[d.m.6$sentenceType != "nonpun",]
summary(lm(data=d.m.6.puns.depuns, aveKL ~ sentenceType))

d.fc.orig$measure6 = d.m.6$aveKL

# compute mean and sd of average KL for different sentence types
m6.summary = summarySE(d.fc.orig, measurevar="measure6", groupvars=c("sentenceType"))

ggplot(m6.summary, aes(x=sentenceType, y=measure6, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure6-ci, ymax=measure6+ci),
                width=.2) +
                  theme_bw()

# analyzes max KL measures (with homophone prior!) for original sentences 
# only considering H1

d.m.7 = read.csv("Measures/maxKL_homPrior_justH1.csv")

summary(lm(data=d.m.7, maxKL ~ sentenceType))

d.m.7.puns.depuns = d.m.7[d.m.7$sentenceType != "nonpun",]
summary(lm(data=d.m.7.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure7 = d.m.7$maxKL

# compute mean and sd of average KL for different sentence types
m7.summary = summarySE(d.fc.orig, measurevar="measure7", groupvars=c("sentenceType"))

ggplot(m7.summary, aes(x=sentenceType, y=measure7, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure7-ci, ymax=measure7+ci),
                width=.2) +
                  theme_bw()

# analyzes max KL measures (with homophone prior!) for original sentences 
# only considering H2

d.m.8 = read.csv("Measures/maxKL_homPrior_justH2.csv")

summary(lm(data=d.m.8, maxKL ~ sentenceType))

d.m.8.puns.depuns = d.m.8[d.m.8$sentenceType != "nonpun",]
summary(lm(data=d.m.8.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure8 = d.m.8$maxKL

# compute mean and sd of average KL for different sentence types
m8.summary = summarySE(d.fc.orig, measurevar="measure8", groupvars=c("sentenceType"))

ggplot(m8.summary, aes(x=sentenceType, y=measure8, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure8-ci, ymax=measure8+ci),
                width=.2) +
                  theme_bw()

# analyzes max KL measures (with homophone prior!) for original sentences 
# matching for contexts

d.m.9 = read.csv("Measures/maxKL_homPrior_matchContext.csv")

summary(lm(data=d.m.9, maxKL ~ sentenceType))

d.m.9.puns.depuns = d.m.9[d.m.8$sentenceType != "nonpun",]
summary(lm(data=d.m.9.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure9 = d.m.9$maxKL

# compute mean and sd of average KL for different sentence types
m9.summary = summarySE(d.fc.orig, measurevar="measure9", groupvars=c("sentenceType"))

ggplot(m9.summary, aes(x=sentenceType, y=measure9, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure9-ci, ymax=measure9+ci),
                width=.2) +
                  theme_bw()


# analyzes max KL measures (with NO prior!) for original sentences 
# assymetric KL

d.m.10 = read.csv("Measures/maxKL_noHomPrior_assymetry.csv")

summary(lm(data=d.m.10, maxKL ~ sentenceType))

d.m.10.puns.depuns = d.m.10[d.m.10$sentenceType != "nonpun",]
summary(lm(data=d.m.10.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure10 = d.m.10$maxKL

# compute mean and sd of average KL for different sentence types
m10.summary = summarySE(d.fc.orig, measurevar="measure10", groupvars=c("sentenceType"))

ggplot(m10.summary, aes(x=sentenceType, y=measure10, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure10-ci, ymax=measure10+ci),
                width=.2) +
                  theme_bw()


# analyzes max KL measures (with homophone prior!) for original sentences 
# assymetric KL

d.m.11 = read.csv("Measures/maxKL_homPrior_assymetry.csv")

summary(lm(data=d.m.11, maxKL ~ sentenceType))

d.m.11.puns.depuns = d.m.11[d.m.11$sentenceType != "nonpun",]
summary(lm(data=d.m.11.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure11 = d.m.11$maxKL

# compute mean and sd of average KL for different sentence types
m11.summary = summarySE(d.fc.orig, measurevar="measure11", groupvars=c("sentenceType"))

ggplot(m11.summary, aes(x=sentenceType, y=measure11, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure11-ci, ymax=measure11+ci),
                width=.2) +
                  theme_bw()


# analyzes max KL measures (with homophone prior!) for original sentences, normalize context length
# assymetric KL

d.m.12 = read.csv("Measures/maxKL_homPrior_normalizeContextLength_assymetry.csv")

summary(lm(data=d.m.12, maxKL ~ sentenceType))

d.m.12.puns.depuns = d.m.12[d.m.12$sentenceType != "nonpun",]
summary(lm(data=d.m.12.puns.depuns, maxKL ~ sentenceType))

d.fc.orig$measure12 = d.m.12$maxKL

# compute mean and sd of average KL for different sentence types
m12.summary = summarySE(d.fc.orig, measurevar="measure12", groupvars=c("sentenceType"))

ggplot(m12.summary, aes(x=sentenceType, y=measure12, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure12-ci, ymax=measure12+ci),
                width=.2) +
                  theme_bw()


# analyzes ave KL measures (with homophone prior!) for original sentences, normalize context length
# assymetric KL

d.m.13 = read.csv("Measures/aveKL_homPrior_normalizeContextLength_assymetry.csv")

summary(lm(data=d.m.13, maxKL ~ sentenceType))

d.m.13.puns.depuns = d.m.13[d.m.13$sentenceType != "nonpun",]
summary(lm(data=d.m.13.puns.depuns, aveKL ~ sentenceType))

d.fc.orig$measure13 = d.m.13$aveKL

# compute mean and sd of average KL for different sentence types
m13.summary = summarySE(d.fc.orig, measurevar="measure13", groupvars=c("sentenceType"))

ggplot(m13.summary, aes(x=sentenceType, y=measure13, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure13-ci, ymax=measure13+ci),
                width=.2) +
                  theme_bw()


# analyzes sum KL measures (with homophone prior!) for original sentences, normalize context length
# with balance and support

d.m.14 = read.csv("Measures/sumKL_support_balance_homPrior_normalized.csv")

summary(lm(data=d.m.14, sumKL ~ sentenceType))

d.m.14.puns.depuns = d.m.14[d.m.14$sentenceType != "nonpun",]
summary(lm(data=d.m.14.puns.depuns, sumKL ~ sentenceType))

d.fc.orig$sumKL = d.m.14$sumKL

# compute mean and sd of sum KL for different sentence types
sum.summary = summarySE(d.fc.orig, measurevar="sumKL", groupvars=c("sentenceType"))

ggplot(sum.summary, aes(x=sentenceType, y=sumKL, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=sumKL-ci, ymax=sumKL+ci),
                width=.2) +
                  theme_bw()

d.fc.orig$sumSupport = d.m.14$sumSupport
# compute mean and sd of support for different sentence types
support.summary = summarySE(d.fc.orig, measurevar="sumSupport", groupvars=c("sentenceType"))

ggplot(support.summary, aes(x=sentenceType, y=sumSupport, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=sumSupport-ci, ymax=sumSupport+ci),
                width=.2) +
                  theme_bw()


d.fc.orig$sumBalance = d.m.14$sumBalance
# compute mean and sd of support for different sentence types
balance.summary = summarySE(d.fc.orig, measurevar="sumBalance", groupvars=c("sentenceType"))

ggplot(balance.summary, aes(x=sentenceType, y=sumBalance, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=sumBalance-ci, ymax=sumBalance+ci),
                width=.2) +
                  theme_bw()

## correlate balance with funniness
ggplot(d.fc.orig, aes(x=log(sumBalance), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  xlab("balance")

cor.test(log(d.fc.orig$sumBalance), d.fc.orig$funniness)

withSum <- lm(data=d.fc.orig, funniness ~ log(sumBalance) + sumKL)
justBalance <- lm(data=d.fc.orig, funniness ~ log(sumBalance))
anova(withSum, justBalance)

summary(lm(data=d.fc.orig, funniness ~ log(sumBalance) + sumKL))
summary(lm(data=d.fc.orig, funniness ~ log(sumBalance)))

d.fc.orig.puns = d.fc.orig[d.fc.orig$sentenceType == "pun",]
with(d.fc.orig.puns, cor.test(log(sumBalance), funniness))

d.fc.orig.puns.depuns = d.fc.orig[d.fc.orig$sentenceType != "nonpun",]
with(d.fc.orig.puns.depuns, cor.test(log(sumBalance), funniness))


ggplot(d.fc.orig, aes(x=log(sumKL), y=log(sumBalance), color=sentenceType)) +
  geom_point() +
  theme_bw()

d.fc.orig.puns.nonpuns = d.fc.orig[d.fc.orig$sentenceType != "depunned",]
with(d.fc.orig.puns.nonpuns, cor.test(sumBalance, funniness))
ggplot(d.fc.orig.puns.nonpuns, aes(x=log(sumBalance), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()


# analyzes sum KL measures (with homophone prior!) for original sentences, normalize context length
# with balance and support, changed balance and support calculations

d.m.15 = read.csv("Measures/sumKL_support_balance_homPrior_normalized_v2.csv")

summary(lm(data=d.m.15, sumKL ~ sentenceType))
summary(lm(data=d.m.15, sumBalance ~ sentenceType))
summary(lm(data=d.m.15, sumSupport ~ sentenceType))


d.fc.orig$sumBalance_v2 = d.m.15$sumBalance
d.fc.orig$sumSupport_v2 = d.m.15$sumSupport

# compute mean and sd of sum KL for different sentence types
sum.summary = summarySE(d.fc.orig, measurevar="sumKL", groupvars=c("sentenceType"))

ggplot(sum.summary, aes(x=sentenceType, y=sumKL, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=sumKL-ci, ymax=sumKL+ci),
                width=.2) +
                  theme_bw()

# compute mean and sd of support for different sentence types
support_v2.summary = summarySE(d.fc.orig, measurevar="sumSupport_v2", groupvars=c("sentenceType"))

ggplot(support_v2.summary, aes(x=sentenceType, y=sumSupport_v2, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=sumSupport_v2-ci, ymax=sumSupport_v2+ci),
                width=.2) +
                  theme_bw()


# compute mean and sd of support for different sentence types
balance_v2.summary = summarySE(d.fc.orig, measurevar="sumBalance_v2", groupvars=c("sentenceType"))

ggplot(balance_v2.summary, aes(x=sentenceType, y=sumBalance_v2, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=sumBalance_v2-ci, ymax=sumBalance_v2+ci),
                width=.2) +
                  theme_bw()

## correlate balance with funniness
ggplot(d.fc.orig, aes(x=log(sumBalance_v2), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

cor.test(log(d.fc.orig$sumBalance), d.fc.orig$funniness)
cor.test(log(d.fc.orig$sumBalance_v2), d.fc.orig$funniness)

ggplot(d.fc.orig, aes(x=log(sumBalance), y=log(sumSupport_v2), color=sentenceType)) +
  geom_point() +
  theme_bw()

d.fc.orig.clean = d.fc.orig[d.fc.orig$measure1 > 0,]

summary(lm(data=d.fc.orig, funniness ~ log(sumBalance)))

ggplot(d.fc.orig, aes(x=log(sumKL), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

d.fc.orig.puns.depuns = d.fc.orig[d.fc.orig$sentenceType != "nonpun" & d.fc.orig$measure1 > 0,]

summary(lm(data=d.fc.orig.puns.depuns, funniness ~ log(sumKL)))
with(d.fc.orig.puns.depuns, cor.test(funniness, log(sumKL)))

d.fc.orig.pun = d.fc.orig[d.fc.orig$sentenceType == "pun",]
ggplot(d.fc.orig, aes(x=log(sumBalance), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  xlab("Balance") +
  ylab("Funniness (z-scored)") +
  scale_color_discrete(name="Sentence Type") +
  theme(legend.title = element_text(size=16)) +
  theme(legend.text = element_text(size=16)) +
  theme(axis.title.x= element_text(size=16)) +
  theme(axis.title.y= element_text(size=16))

d.fc.orig.depun = d.fc.orig[d.fc.orig$sentenceType == "depunned",]
ggplot(d.fc.orig.depun, aes(x=log(sumBalance), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

d.m.16 = read.csv("Measures/sumKL_support_balance_homPrior_normalized_v3.csv")

summary(lm(data=d.m.16, sumKL ~ sentenceType))
summary(lm(data=d.m.16, sumBalance ~ sentenceType))
summary(lm(data=d.m.16, sumSupport ~ sentenceType))
summary(lm(data=d.m.16, sumDominance ~ sentenceType))


d.fc.orig$sumDominance = d.m.16$sumDominance

ggplot(d.fc.orig, aes(x=log(sumBalance), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(d.fc.orig, aes(x=log(sumKL), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  xlab("sumKL")

d.fc.orig.filtered$sumKL_zscored = scale(log(d.fc.orig.filtered$sumKL))

ggplot(d.fc.orig.filtered, aes(x=sumKL_zscored, y=sumBalance_zscored, color=funniness, shape=sentenceType)) +
  geom_point() +
  theme_bw() +
  scale_colour_gradient(low="gray", high="black")
  scale_colour_gradientn(colours=rev(rainbow(3)))

with(d.fc.orig.filtered, cor.test(sumKL_zscored, sumBalance_zscored))

d.fc.orig.filtered = d.fc.orig[d.fc.orig$measure1 > 0,]
summary(lm(data=d.fc.orig, funniness ~ log(sumBalance) * measure1))
summary(lm(data=d.fc.orig, funniness ~ log(sumBalance)))

d.fc.orig.filtered$maxKL_zscored = scale(log(d.fc.orig.filtered$measure1))

# compare measures with h1 or h2
write.csv(d.fc.orig, "Measures/measures_orig.csv")
d.h1.h2 = read.csv("Measures/compare_max_h1h2.csv")
h1.h2.summary = summarySE(d.h1.h2, measurevar="measure", groupvars=c("sentenceType", "interpretation"))

ggplot(h1.h2.summary, aes(x=sentenceType, y=measure, fill=interpretation)) +
  geom_bar(position=position_dodge(), color="black", stat="identity") +
  geom_errorbar(position=position_dodge(0.9), aes(ymin=measure-ci, ymax=measure+ci), width=0.2) +
  theme_bw()


all.measures = read.csv("Measures/measures_orig.csv")
m7.m8.sum.summary = summarySE(all.measures, measurevar="sum7_8", groupvars=c("sentenceType"))
ggplot(m7.m8.sum.summary, aes(x=sentenceType, y=sum7_8, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=sum7_8-ci, ymax=sum7_8+ci), width=0.2) +
  theme_bw()



m6.byItem.summary <- summarySE(d.fc.orig, measurevar="measure6", groupvars=c("phoneticID", "sentenceType"))
m6.byItem.summary.puns.depunned <-
m6.byItem.summary[(m6.byItem.summary$sentenceType != "nonpun") & (m6.byItem.summary$phoneticID <= 40),]

ggplot(m6.byItem.summary.puns.depunned, aes(x=phoneticID, y=log(measure6), fill=sentenceType)) +
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  geom_errorbar(position=position_dodge(0.9), aes(ymin=measure6-ci, ymax=measure6+ci),
                width=.2) +
                  theme_bw()

# correlations between measures and funniness
# measure 1: maxKL, no hom prior, uniform context prob
ggplot(d.fc.orig, aes(x=log(measure1), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Max KL, no homophone prior, uniform context probability")

# measure 2: aveKL, no hom prior, uniform context prob
ggplot(d.fc.orig, aes(x=log(measure2), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Average KL, no homophone prior, uniform context probability")

# measure 3: maxKL, hom prior, uniform context probability
ggplot(d.fc.orig, aes(x=log(measure3), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Max KL, homophone prior, uniform context probability")

# measure 4: aveKL, hom prior, uniform context probability
ggplot(d.fc.orig, aes(x=log(measure4), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Average KL, homophone prior, uniform context probability")

# measure 5: maxKL, hom prior, normalize for context probability
ggplot(d.fc.orig, aes(x=log(measure5), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Max KL, homophone prior, normalize for context length")

# measure 6: aveKL, hom prior, normalize for context probability
ggplot(d.fc.orig, aes(x=log(measure6), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Average KL, homophone prior, nromalize for context length")



# measure 11: maxKL, hom prior, uniform context probability, assymetric KL
ggplot(d.fc.orig, aes(x=log(measure11), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Max KL, homophone prior, uniform context length, assymetric KL")

# measure 12: maxKL, hom prior, uniform context probability, assymetric KL
ggplot(d.fc.orig, aes(x=log(measure12), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  ggtitle("Max KL, homophone prior, normalize context length, assymetric KL")


###
# get correlations for non-nonpuns
d.fc.orig.nononpuns = d.fc.orig[d.fc.orig$sentenceType != "nonpun",]
d.fc.orig.nononpuns.filtered = d.fc.orig.nononpuns[d.fc.orig.nononpuns$measure1 > 0,]
d.fc.orig.filtered = d.fc.orig[d.fc.orig$measure1 > 0,]

with(d.fc.orig.nononpuns.filtered, cor.test(funniness, log(measure1)))
with(d.fc.orig.nononpuns.filtered, cor.test(funniness, log(measure2)))
with(d.fc.orig.nononpuns.filtered, cor.test(funniness, log(measure3)))
with(d.fc.orig.nononpuns.filtered, cor.test(funniness, log(measure4)))
with(d.fc.orig.nononpuns.filtered, cor.test(funniness, log(measure11)))
with(d.fc.orig.nononpuns.filtered, cor.test(funniness, log(measure12)))


d.fc.orig.pun.comp = d.fc.orig[d.fc.orig$uniqueID <= 40,]
d.fc.orig.depun.comp = d.fc.orig[d.fc.orig$sentenceType == "depunned",]

d.fc.orig.pun.clean = d.fc.orig.pun.comp[d.fc.orig.pun.comp$measure1 > 0,]
d.fc.orig.depun.clean = d.fc.orig.depun.comp[d.fc.orig.depun.comp$measure1 > 0,]

cor.test(d.fc.orig.pun.clean$funniness, d.fc.orig.depun.clean$funniness)
cor.test((d.fc.orig.pun.clean$funniness - d.fc.orig.depun.clean$funniness), 
         (log(d.fc.orig.pun.clean$measure3) - log(d.fc.orig.depun.clean$measure3)))

t.test(d.fc.orig.pun.comp$measure1, d.fc.orig.depun.comp$measure1, paired=TRUE)



# filter out stu's puns and non-puns
d.fc.orig.filtered = d.fc.orig[((d.fc.orig$uniqueID <= 40) |
  ((d.fc.orig$uniqueID >= 66) & (d.fc.orig$uniqueID <= 145))| 
  ((d.fc.orig$uniqueID >= 171) & (d.fc.orig$uniqueID <= 210))),]
m5.summary.filtered = summarySE(d.fc.orig.filtered, measurevar="measure5", groupvars=c("sentenceType"))

ggplot(m5.summary.filtered, aes(x=sentenceType, y=measure5, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure5-ci, ymax=measure5+ci),
                width=.2) +
                  theme_bw()



## analyze how KL measures correlate with sentence length
d.l = read.csv("Measures/measures_orig_withLength.csv")
d.l.filtered = d.l[d.l$measure1 > 0,]
cor.test(log(d.l.filtered$measure1), d.l.filtered$sentenceLength)

d.l.pun.depunned.filtered = d.l.filtered[d.l.filtered$sentenceType != "nonpun",]
cor.test(d.l.pun.depunned.filtered$measure1, d.l.pun.depunned.filtered$sentenceLength)

d.l.nonpun = d.l[d.l$sentenceType == "nonpun",]
d.l.nonpun.filtered = d.l.nonpun[d.l.nonpun$measure1 > 0,]
cor.test(log(d.l.nonpun.filtered$measure1), d.l.nonpun.filtered$sentenceLength)
cor.test(log(d.l.nonpun.filtered$measure2), d.l.nonpun.filtered$sentenceLength)
cor.test(log(d.l.nonpun.filtered$measure3), d.l.nonpun.filtered$sentenceLength)
cor.test(log(d.l.nonpun.filtered$measure4), d.l.nonpun.filtered$sentenceLength)
cor.test(log(d.l.nonpun.filtered$measure5), d.l.nonpun.filtered$sentenceLength)
cor.test(log(d.l.nonpun.filtered$measure6), d.l.nonpun.filtered$sentenceLength)


ggplot(d.l.nonpun, aes(x=sentenceLength, y=log(measure3), color=sentenceType)) +
  geom_point()+
  ylab("maxKL") +
  theme_bw()

ggplot(d.l.nonpun, aes(x=sentenceLength, y=log(measure6), color=sentenceType)) +
  geom_point()+
  theme_bw() +
  ylab("sumKL_contextNormed")
