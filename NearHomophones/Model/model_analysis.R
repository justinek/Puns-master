# reads funniness ratings per sentence
d.funny <- read.csv("../Materials/sentences_orig_withRatings.csv")

# reads model output for balance meaures
d.balance <- read.csv("balance_r15.csv")
d.funny$balance <- d.balance$entropy

with(d.funny, cor.test(rating, balance))

d.funny.pun <- subset(d.funny, sentenceType == "pun")
with(d.funny.pun, cor.test(rating, balance))

ggplot(d.funny, aes(x=balance, y=rating, color=sentenceType)) +
  geom_point() +
  theme_bw()

balance.summary <- summarySE(d.funny, measurevar="balance", groupvars=c("sentenceType"))
ggplot(balance.summary, aes(x=sentenceType, y=balance, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=balance-ci, ymax=balance+ci),
                width=.2) +
                  theme_bw()

# reads model output for focus measures
d.focus <- read.csv("focus_r15.csv")
d.funny$focusKL <- d.focus$KL
d.funny$focusMinKL <- d.focus$minKL

with(d.funny, cor.test(rating, focusKL))
with(d.funny, cor.test(rating, focusMinKL))

d.funny.pun <- subset(d.funny, sentenceType == "pun")
with(d.funny.pun, cor.test(rating, focusKL))

ggplot(d.funny, aes(x=focusKL, y=rating, color=sentenceType)) +
  geom_point() +
  theme_bw()

focus.summary <- summarySE(d.funny, measurevar="focusKL", groupvars=c("sentenceType"))
ggplot(focus.summary, aes(x=sentenceType, y=focusKL, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=focusKL-ci, ymax=focusKL+ci),
                width=.2) +
                  theme_bw()


summary(lm(data=d.funny, rating ~ balance * focusKL))
summary(lm(data=d.funny.pun, rating ~ balance * focusKL))

### plot ellipses

stderr <- function(x) sqrt(var(x)/length(x))

df_ell <- data.frame() 
for(g in levels(d.funny$sentenceType)){
  df_ell <- rbind(df_ell, cbind(as.data.frame(with(d.funny[d.funny$sentenceType==g,], 
  ellipse(cor(balance, focusKL),scale=c(stderr(balance),stderr(focusKL)),
          centre=c(mean(balance),mean(focusKL))))),group=g))} 

ggplot(d.funny, aes(x=balance,y=focusKL,colour=sentenceType)) + 
  geom_path(data=df_ell, aes(x=x, y=y,colour=group)) +
  theme_bw() +
  xlab("Ambiguity") +
  ylab("Distinctiveness") +
  #ylim(c(1,5)) +
  #xlim(c(0,0.6)) +
  scale_color_discrete(name="", limits=c("pun","nonpun"), 
                       labels=c("Pun", "Non-pun")) +
                         theme(axis.title.x=element_text(size=16), 
                               axis.title.y=element_text(size=16), 
                               legend.text=element_text(size=16), 
                               legend.title=element_text(size=16),
                               legend.position=c(0.15, 0.85))


## contour lines
Ambiguity = d.funny$balance
Distinctiveness = d.funny$focusKL
Funniness = d.funny$rating
m <- loess(Funniness ~ Ambiguity*Distinctiveness)
grid <- expand.grid(Ambiguity=do.breaks(c(0,0.7),50),Distinctiveness=do.breaks(c(7.4,12),50))
grid$Funniness <- as.vector(predict(m,newdata=grid))
levelplot(Funniness ~ Ambiguity*Distinctiveness, grid)
contourplot(cuts=17, Funniness ~ Ambiguity*Distinctiveness, grid, size=16, xlab="Ambiguity", ylab="Disjointedness", nlevels = 40)

## in ggplot with color contour lines


p <- ggplot(data=grid,aes(x=Ambiguity,y=Distinctiveness,z=Funniness)) + 
  stat_contour(aes(color=..level..)) + 
  scale_colour_gradient(high="#990033", low="#FF9999") + 
  theme_bw() + theme(panel.grid.minor=element_blank(), 
                     panel.grid.major=element_blank(), 
                     axis.title.x=element_text(size=16), 
                     axis.title.y=element_text(size=16))
library(directlabels)
direct.label(p)

## reads model output for max support
d.support <- read.csv("maxSupport_r20_p50.csv")
d.funny$maxPm1 <- d.support$maxPm1
d.funny$maxPm2 <- d.support$maxPm2

with(d.funny, cor.test(rating, log(maxPm1)))
with(d.funny, cor.test(rating, log(maxPm2)))
with(d.funny, cor.test(rating, log(maxPm1/ maxPm2)))
with(d.funny, cor.test(rating, log(maxPm1) + log(maxPm2)))

ggplot(d.funny, aes(x=log(maxPm1), y=rating, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(d.funny, aes(x=log(maxPm2), y=rating, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(d.funny, aes(x=log(maxPm1/maxPm2), y=rating, color=sentenceType)) +
  geom_point() + 
  theme_bw()

ggplot(d.funny, aes(x=log(maxPm1*maxPm2), y=rating, color=sentenceType)) +
  geom_point() + 
  theme_bw()

ggplot(d.funny, aes(x=log(maxPm1), y=log(maxPm2), color=sentenceType)) +
  geom_point() +
  theme_bw()
