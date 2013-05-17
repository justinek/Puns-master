import sys, re, string

# reads in wordPair file with ratings and fills in the unigram probabilities
# of content words

bncDict = dict()

bncF = open("../BNC/bnc_unigram.txt", "r")

totalCount = 0
for l in bncF:
    l = l.replace("\n", "")
    toks = l.split("\t")
    bncDict[toks[0]] = int(toks[1])
    totalCount = totalCount + int(toks[1])


f = open("../Materials/wordPairs_orig_withRatings.csv", "r")

firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
        toks = l.split(",")
        print ",".join(toks[0:11]) + ",unigram"
    else:
        toks = l.split(",")
        word = toks[8]
        if word in bncDict:
            prob = float(bncDict[word]) / float(totalCount)
        else:
            prob = float(1) / float(totalCount)
        print ",".join(toks[0:11]) + "," + str(prob)

