a0=read.csv("Measures/ambiguityMeasures_orig_withHomPrior2.csv")

ggplot(a0, aes(x=p_m1_given_w, p_m2_given_w, color=sentenceType)) +
  geom_point() +
  theme_bw()

## compute entropy

a0$entropy = -(a0$p_m1_given_w * log(a0$p_m1_given_w) + a0$p_m2_given_w * log(a0$p_m2_given_w))

summary(lm(data=a0, entropy ~ sentenceType))

entropy.summary0 = summarySE(a0, measurevar="entropy", groupvars=c("sentenceType"))
ggplot(entropy.summary0, aes(x=sentenceType, y=entropy, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=entropy-ci, ymax=entropy+ci),
                width=.2) +
                  theme_bw() +
                  xlab("") +
                  ylab("Entropy of P(m | w): Ambiguity measure") +
                  scale_x_discrete(limits=c("pun", "nonpun", "depunned"), labels=c("Pun", "Non-pun", "De-punned")) +
                  scale_fill_discrete(guide=FALSE) +
                  theme(axis.text.x  = element_text(size=16), axis.title.y  = element_text(size=16))

sentences.rating.orig$entropy0 = a0$entropy
ggplot(sentences.rating.orig, aes(x=entropy0, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  xlab("Entropy of P(m | w): Ambiguity measure") +
  ylab("Funniness") +
  scale_color_discrete(name="Sentence Type", limits=c("pun", "nonpun", "depunned"), labels=c("Pun", "Non-pun", "De-punned")) +
  theme(axis.title.x  = element_text(size=16), axis.title.y  = element_text(size=16))


with(sentences.rating.orig, cor.test(entropy0, funniness))

### focus measures
# just original sentences

f0=read.csv("Measures/focusMeasures_orig2.csv")

summary(lm(data=f0, KL ~ sentenceType))

focus.summary0 = summarySE(f0, measurevar="KL", groupvars=c("sentenceType"))
ggplot(focus.summary0, aes(x=sentenceType, y=KL, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=KL-ci, ymax=KL+ci),
                width=.2) +
                  xlab("") +
                  ylab("Symmetrised KL for P(f | w, m): Disjointedness measure") +
                  theme_bw() +
                  scale_x_discrete(limits=c("pun", "nonpun", "depunned"), labels=c("Pun", "Non-pun", "De-punned")) +
                  scale_fill_discrete(guide=FALSE) +
                  theme(axis.text.x  = element_text(size=16), axis.title.y  = element_text(size=16))



sentences.rating.orig$focus0 = f0$KL
ggplot(sentences.rating.orig, aes(x=focus0, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  xlab("Symmetrised KL for P(f | w, m): Disjointedness measure") +
  ylab("Funniness") +
  scale_color_discrete(name="Sentence Type", limits=c("pun", "nonpun", "depunned"), labels=c("Pun", "Non-pun", "De-punned")) +
  theme(axis.title.x  = element_text(size=16), axis.title.y  = element_text(size=16))


with(sentences.rating.orig, cor.test(focus0, funniness))


## combine balance and focus
summary(lm(data=sentences.rating.orig, funniness ~ entropy0))
summary(lm(data=sentences.rating.orig, funniness ~ focus0))
summary(lm(data=sentences.rating.orig, funniness ~ entropy0 + focus0))
summary(lm(data=sentences.rating.orig, funniness ~ entropy0 * focus0))


ggplot(sentences.rating.orig, aes(x=focus0, y=entropy0, color=funniness)) +
  geom_point() +
  theme_bw() +
  scale_colour_gradientn(colours=rev(rainbow(3))) +
  xlab("disjointedness") +
  ylab("ambiguity")

## make ellipse plot

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




qplot(data=sentences.rating.orig, x=focus0,y=entropy0,colour=sentenceType)+stat_ellipse(level=0.95)

stderr <- function(x) sqrt(var(x)/length(x))

df_ell <- data.frame() 
for(g in levels(sentences.rating.orig$sentenceType)){df_ell <- rbind(df_ell, cbind(as.data.frame(with(sentences.rating.orig[sentences.rating.orig$sentenceType==g,], ellipse(cor(entropy0, focus0),scale=c(stderr(entropy0),stderr(focus0)),centre=c(mean(entropy0),mean(focus0))))),group=g))} 

ggplot(sentences.rating.orig, aes(x=entropy0,y=focus0,colour=sentenceType)) + 
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
  
  



## combine balance and focus in summary plot
balance.summary = summarySE(sentences.rating.orig, measurevar="entropy0", groupvars="sentenceType")
focus.summary = summarySE(sentences.rating.orig, measurevar="focus0", groupvars="sentenceType")
combine.summary <- data.frame(sentenceType = balance.summary$sentenceType, 
                              balance_mean = balance.summary$entropy0, balance_ci = balance.summary$ci,
                              focus_mean = focus.summary$focus0, focus_ci = focus.summary$ci)

ggplot(combine.summary, aes(x=balance_mean, y=focus_mean, color=sentenceType)) +
  geom_point(shape=18, size=6) +
  geom_errorbar(aes(ymin=focus_mean-focus_ci,ymax=focus_mean+focus_ci)) + 
  geom_errorbarh(aes(xmin=balance_mean-balance_ci,xmax=balance_mean+balance_ci)) +
  theme_bw() +
  xlab("Ambiguity") +
  ylab("Disjointedness") +
  scale_color_discrete(name="Sentence Type", limits=c("pun", "nonpun", "depunned"), labels=c("Pun", "Non-pun", "De-punned")) +
  theme(axis.title.x  = element_text(size=16), axis.title.y  = element_text(size=16))



       


####
# full sentences

a1=read.csv("Measures/ambiguityMeasures_full_withHomPrior1.csv")
a1$isOrig = factor(a1$isOrig)
ggplot(a1, aes(x=p_m1_given_w, p_m2_given_w, color=sentenceType)) +
  geom_point() +
  theme_bw()

## compute entropy

a1$entropy = -(a1$p_m1_given_w * log(a1$p_m1_given_w) + a1$p_m2_given_w * log(a1$p_m2_given_w))

entropy.summary1 = summarySE(a1, measurevar="entropy", groupvars=c("sentenceType", "isOrig"))
ggplot(entropy.summary1, aes(x=sentenceType, y=entropy, fill=isOrig)) +
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  geom_errorbar(position=position_dodge(0.9), aes(ymin=entropy-ci, ymax=entropy+ci),
                width=.2) +
                  theme_bw()

sentences.rating$entropy = a1$entropy
ggplot(sentences.rating, aes(x=entropy, y=funniness, color=sentenceType, shape=isOrig)) +
  geom_point() +
  theme_bw()

with(sentences.rating, cor.test(entropy, funniness))

## focus measures

### focus measures
# just original sentences

f1=read.csv("Measures/focusMeasures_full1.csv")
f1$isOrig = factor(f1$isOrig)

focus.summary1 = summarySE(f1, measurevar="KL", groupvars=c("sentenceType", "isOrig"))
ggplot(focus.summary1, aes(x=sentenceType, y=KL, fill=isOrig)) +
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  geom_errorbar(position=position_dodge(0.9), aes(ymin=KL-ci, ymax=KL+ci),
                width=.2) +
                  xlab("") +
                  ylab("Symmetrised KL for P(f | w, m): Disjointedness measure") +
                  theme_bw()


sentences.rating$focus = f1$KL
ggplot(sentences.rating, aes(x=focus, y=funniness, color=sentenceType, shape=isOrig)) +
  geom_point() +
  theme_bw() +
  xlab("Symmetrised KL for P(f | w, m): Disjointedness measure") +
  ylab("Funniness")


with(sentences.rating, cor.test(focus, funniness))


## combine balance and focus
summary(lm(data=sentences.rating, funniness ~ entropy))
summary(lm(data=sentences.rating, funniness ~ focus))
summary(lm(data=sentences.rating, funniness ~ entropy + focus))
summary(lm(data=sentences.rating, funniness ~ entropy * focus))


ggplot(sentences.rating, aes(x=focus, y=entropy, color=funniness)) +
  geom_point() +
  theme_bw() +
  scale_colour_gradientn(colours=rev(rainbow(3))) +
  xlab("disjointedness") +
  ylab("ambiguity")

## combine balance and focus in summary plot
balance.summary1 = summarySE(sentences.rating, measurevar="entropy", groupvars=c("sentenceType", "isOrig"))
focus.summary1 = summarySE(sentences.rating, measurevar="focus", groupvars=c("sentenceType", "isOrig"))
combine.summary1 <- data.frame(sentenceType = balance.summary1$sentenceType, isOrig = balance.summary1$isOrig,
                              balance_mean = balance.summary1$entropy, balance_ci = balance.summary1$ci,
                              focus_mean = focus.summary1$focus, focus_ci = focus.summary1$ci)

ggplot(combine.summary1, aes(x=focus_mean, y=balance_mean, color=sentenceType, shape=isOrig)) +
  geom_point(size=6) +
  geom_errorbar(aes(ymin=balance_mean-balance_ci,ymax=balance_mean+balance_ci)) + 
  geom_errorbarh(aes(xmin=focus_mean-focus_ci,xmax=focus_mean+focus_ci)) +
  theme_bw() +
  xlab("disjointedness") +
  ylab("ambiguity") +
  scale_fill_discrete(name="Sentence type") +
  scale_shape_manual(name="Observed homophone", breaks=c("0", "1"),
                       labels=c("Original", "Modified"), values=c(16, 1))


e = read.csv("prophet_example.csv")
e$combo = factor(e$combo)
ggplot(e, aes(x=combo, y=probOrig, fill=meaningOrig)) + 
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  theme_bw()

ggplot(e, aes(x=combo, y=probMod, fill=meaningMod)) + 
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  theme_bw()



library(lattice)
m <- with(sentences.rating.orig, loess(funniness ~ entropy0*focus0))
grid <-data.frame(x=sentences.rating.orig$entropy0, y=sentences.rating.orig$focus0)
grid$z <- as.vector(predict(m,newdata=grid))
levelplot(z ~ x*y, grid)
contourplot(z ~ x*y, grid)




library(lattice)
x <- runif(1000,-1,1)
y <- runif(1000,-1,1)
z <- x*y + rnorm(1000)

Ambiguity = sentences.rating.orig$entropy0
Distinctiveness = sentences.rating.orig$focus0
Funniness = sentences.rating.orig$funniness
m <- loess(Funniness ~ Ambiguity*Distinctiveness)
grid <- expand.grid(Ambiguity=do.breaks(c(0,0.7),50),Distinctiveness=do.breaks(c(0.9,5.1),50))
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

direct.label(p)
