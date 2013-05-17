import sys, re, string

# adds information of the target words into the word pairs file

targetF = open("../BNC/targetWords_trigrams.csv", "r")

targetDict = dict()
firstline = 0
for l in targetF:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        sentenceID = toks[0]
        trigramProbs = toks[2:4]
        targetDict[sentenceID] = trigramProbs

unigramF = open("../Materials/homophones_unigram.csv", "r")
unigramDict = dict()

firstline = 0
for l in unigramF:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        sentenceID = toks[0]
        #print sentenceID
        m1Prob = toks[5]
        unigramDict[sentenceID] = m1Prob 

f = open("../Materials/wordPairs_orig_withRatings_withTrigrams.csv", "r")

currentID = 0
firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        print l
        firstline = 1
    else:
        toks = l.split(",")
        sentenceID = int(toks[2])
        if sentenceID > currentID:
            currentID = sentenceID
            targetWord = toks[7]
            targetProbs = targetDict[str(sentenceID)]
            unigramProb = unigramDict[str(sentenceID)]
            print str(0) + "," + ",".join(toks[1:8]) + "," + targetWord + ",0,0," + unigramProb + "," + ",".join(targetProbs)
            print l
        else:
            print l

