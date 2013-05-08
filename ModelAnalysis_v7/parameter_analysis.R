##### 
# compare ambiguity measure with free paramters
f.ratings = read.csv("../sentences_funniness_correctness.csv")
f.ratings <- subset(f.ratings, isOrig=="0")
## read in balance measures
balance = read.csv("Measures/Trigram/balance_A10_R12.9.csv")
f.ratings$entropy = balance$entropy
with(f.ratings, cor.test(funniness, entropy))

ggplot(f.ratings, aes(x=entropy, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

## read in focus measures
focus = read.csv("Measures/Trigram/focus_A10_R12.9.csv")
f.ratings$minKL = focus$minKL
f.ratings$KL = focus$KL
with(f.ratings, cor.test(funniness, minKL))
with(f.ratings, cor.test(funniness, KL))

summary(lm(data=f.ratings, funniness ~ KL + entropy))

ggplot(f.ratings, aes(x=KL, y=funniness, color=sentenceType)) + 
  geom_point() +
  theme_bw()

## read in support measures
support = read.csv("support_A10_R12.9.csv")
f.ratings$supportM1 = support$maxPm1
f.ratings$supportM2 = support$maxPm2
f.ratings$supportDiff = abs(f.ratings$supportM1 - f.ratings$supportM2)
f.ratings$supportRatio = log(f.ratings$supportM1) - log(f.ratings$supportM2)
with(f.ratings, cor.test(funniness, log(supportM1)))
with(f.ratings, cor.test(funniness, log(supportM2)))
with(f.ratings, cor.test(funniness, log(supportDiff)))
with(f.ratings, cor.test(funniness, supportRatio))
with(f.ratings, cor.test(funniness, log(supportM1) - log(supportM2)))

ggplot(f.ratings, aes(log(supportM1), funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(f.ratings, aes(log(supportM2), funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(f.ratings, aes(log(supportDiff), funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(f.ratings, aes(log(supportM1) - log(supportM2), funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  xlab("Absolute difference in max support for m1 and m2") +
  ylab("Funniness ratings (z-scored)") +
  scale_color_discrete(name="Sentence Type", limits=c("pun", "nonpun", "depunned"), 
                       labels=c("Pun", "Non-pun", "De-punned"))
  
  

summary(lm(data=f.ratings, funniness ~ entropy + minKL))

summary(lm(data=f.ratings, funniness ~ log(supportM1) + log(supportM2) + log(supportDiff)))

# full model
summary(lm(data=f.ratings, funniness ~ minKL + entropy + KL + 
  log(supportM1) + log(supportM2) + log(supportDiff)))

# just puns
f.ratings.puns = subset(f.ratings, sentenceType == "pun")
summary(lm(data=f.ratings.puns, funniness ~ log(supportM1) + log(supportM2) + log(supportDiff)))

# no de-puns
f.ratings.punsnonpuns = subset(f.ratings, sentenceType != "depunned")
summary(lm(data=f.ratings.punsnonpuns, funniness ~ entropy + minKL + 
  log(supportM1) + log(supportM2) + log(supportDiff)))

# no nonpuns
f.ratings.punsdepunned = subset(f.ratings, sentenceType != "nonpun")
summary(lm(data=f.ratings.punsdepunned, funniness ~ entropy + minKL))


entropy_summary = summarySE(f.ratings, measurevar="entropy", groupvars=c("sentenceType"))
ggplot(entropy_summary, aes(x=sentenceType, y=entropy, fill=sentenceType)) +
  geom_bar(color="black", size=.3, stat="identity") +
  geom_errorbar(aes(ymin=entropy-se, ymax=entropy+se),
                size=.3,    # Thinner lines
                width=.2) +
                  theme_bw()

KL_summary = summarySE(f.ratings, measurevar="minKL", groupvars=c("sentenceType"))
ggplot(KL_summary, aes(x=sentenceType, y=minKL, fill=sentenceType)) +
  geom_bar(color="black", size=.3, stat="identity") +
  geom_errorbar(aes(ymin=minKL-se, ymax=minKL+se),
                size=.3,    # Thinner lines
                width=.2) +
  theme_bw()

### plot ellipses

require(proto)

StatEllipse <- proto(ggplot2:::Stat,
{
  required_aes <- c("x", "y")
  default_geom <- function(.) GeomPath
  objname <- "ellipse"
  
  calculate_groups <- function(., data, scales, ...){
    .super$calculate_groups(., data, scales,...)
  }
  calculate <- function(., data, scales, level = 0.75, segments = 51,...){
    dfn <- 2
    dfd <- length(data$x) - 1
    if (dfd < 3){
      ellipse <- rbind(c(NA,NA))  
    } else {
      require(MASS)
      v <- cov.trob(cbind(data$x, data$y))
      shape <- v$cov
      center <- v$center
      radius <- sqrt(dfn * qf(level, dfn, dfd))
      angles <- (0:segments) * 2 * pi/segments
      unit.circle <- cbind(cos(angles), sin(angles))
      ellipse <- t(center + radius * t(unit.circle %*% chol(shape)))
    }
    
    ellipse <- as.data.frame(ellipse)
    colnames(ellipse) <- c("x","y")
    return(ellipse)
  }
}
)

stat_ellipse <- function(mapping=NULL, data=NULL, geom="path", position="identity", ...) {
  StatEllipse$new(mapping=mapping, data=data, geom=geom, position=position, ...)
}


qplot(data=f.ratings, x=entropy,y=minKL,colour=sentenceType)+stat_ellipse(level=0.95)

stderr <- function(x) sqrt(var(x)/length(x))

df_ell <- data.frame() 
for(g in levels(f.ratings$sentenceType)){df_ell <- rbind(df_ell, cbind(as.data.frame(with(f.ratings[f.ratings$sentenceType==g,], ellipse(cor(entropy, KL),scale=c(stderr(entropy),stderr(KL)),centre=c(mean(entropy),mean(KL))))),group=g))} 

ggplot(f.ratings, aes(x=entropy,y=KL,colour=sentenceType)) + 
  geom_path(data=df_ell, aes(x=x, y=y,colour=group)) +
  theme_bw() +
  xlab("Ambiguity") +
  ylab("Distinctiveness") +
  #ylim(c(1,5)) +
  #xlim(c(0,0.6)) +
  scale_color_discrete(name="", limits=c("pun", "depunned", "nonpun"), 
                       labels=c("Pun", "De-punned", "Non-pun")) +
                         theme(axis.title.x=element_text(size=16), 
                               axis.title.y=element_text(size=16), 
                               legend.text=element_text(size=16), 
                               legend.title=element_text(size=16),
                               legend.position=c(0.15, 0.85))


## color contour plots, balance + distinctiveness

Ambiguity = f.ratings$entropy
Distinctiveness = f.ratings$KL
Funniness = f.ratings$funniness
m <- loess(Funniness ~ Ambiguity*Distinctiveness)
grid <- expand.grid(Ambiguity=do.breaks(c(0,0.7),50),Distinctiveness=do.breaks(c(0.00058,0.00131),50))
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
