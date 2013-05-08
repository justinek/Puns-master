# analyzes balance vs support

d = read.csv("Measures/balanceSupport_normal.csv")
d$supportBalanceRatio = d$support / (d$balance + 0.01)
summary(lm(data=d, support ~ sentenceType))
summary(lm(data=d, balance ~ sentenceType))
summary(lm(data=d, supportBalanceRatio ~ sentenceType))

support.summary = summarySE(d, measurevar="support", groupvars=c("sentenceType"))
ggplot(support.summary, aes(x=sentenceType, y=support, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=support-ci, ymax=support+ci),
                width=.2) +
                  theme_bw()


balance.summary = summarySE(d, measurevar="balance", groupvars=c("sentenceType"))
ggplot(balance.summary, aes(x=sentenceType, y=1/(balance + 0.0001), fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=balance-ci, ymax=balance+ci),
                width=.2) +
                  theme_bw()
supportBalanceRatio.summary = summarySE(d, measurevar="supportBalanceRatio", groupvars=c("sentenceType"))
ggplot(supportBalanceRatio.summary, aes(x=sentenceType, y=supportBalanceRatio, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=supportBalanceRatio-ci, ymax=supportBalanceRatio+ci),
                width=.2) +
                  theme_bw()


# analyzies max KL measures (no homophone prior!) for original sentences
# to see how they differ across sentence types
d.m = read.csv("Measures/maxKL_homPrior_normalizeContextLength.csv")

summary(lm(data=d.m, maxKL ~ sentenceType))

d.m.puns.depuns = d.m[d.m$sentenceType != "nonpun",]
summary(lm(data=d.m.puns.depuns, maxKL ~ sentenceType))

# reads in funniness and correctness ratings for sentences
d.fc = read.csv("../sentences_funniness_correctness.csv")
d.fc.normal = d.fc[d.fc$normal == 0,]
d.fc.normal$measure1 = d.m$maxKL


# compute mean and sd of maxKL for different sentence types
m1.summary = summarySE(d.fc.normal, measurevar="measure1", groupvars=c("sentenceType"))

ggplot(m1.summary, aes(x=sentenceType, y=measure1, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure1-ci, ymax=measure1+ci),
                width=.2) +
                  theme_bw()

ggplot(d.fc.normal, aes(x=log(measure1), y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

# compute correlation between funniness and measure
d.fc.normal.filtered = d.fc.normal[d.fc.normal$measure1 > 0,]
with(d.fc.normal.filtered, cor.test(funniness, log(measure1)))

# for just puns and depunned
d.fc.normal.puns.depuns = d.fc.normal[d.fc.normal$sentenceType != "nonpun",]
# remove 0s
d.fc.normal.puns.depuns.clean = d.fc.normal.puns.depuns[d.fc.normal.puns.depuns$measure1 != 0,]
with(d.fc.normal.puns.depuns.clean, cor.test(funniness, measure1))
## it's significant!!! :)
with(d.fc.normal.puns.depuns.clean, cor.test(funniness, log(measure1)))
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

ggplot(m12.summary, aes(x=sentenceType, y=measure13, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=measure13-ci, ymax=measure13+ci),
                width=.2) +
                  theme_bw()



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