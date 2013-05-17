import sys, re, string

# match trigram probabilities to word pairs

wordPairDict = dict()

wordPairF = open("../Materials/wordPairs_orig_withRatings_withUnigram.csv", "r")
firstline = 0
for l in wordPairF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        sentenceID = toks[1]
        word = toks[8]
        if sentenceID not in wordPairDict:
            wordPairDict[sentenceID] = [word]
        else:
            words = wordPairDict[sentenceID]
            words.append(word)
            wordPairDict[sentenceID] = words
f = open("trigramOutput_processed_allWords_replaceUnk.txt", "r")

for l in f:
    l = l.replace("\n", "")
    toks = l.split("\t")
    sentenceID = toks[0]
    word = toks[1]
    prob = toks[2]
    if int(sentenceID) > 320:
        sentenceID = str(int(sentenceID) - 160)
    if int(sentenceID) > 80 and int(sentenceID) <= 160:
        sentenceID = str(int(sentenceID) - 80)
    words = wordPairDict[sentenceID]
    if word in words or word == "<unk>":
        print l

