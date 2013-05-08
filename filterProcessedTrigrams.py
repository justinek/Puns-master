# read original word pairs, filter out spurious words,
# and print them in the order of original file

import re, string, sys

f1 = open("ModelAnalysis_v5/wordPair_relatedness_trigrams_orig.csv", "r")

wordDict = dict()

firstline = 0
for l in f1:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        uniqueID = int(toks[0])
        word = toks[7]
        if uniqueID not in wordDict:
            wordDict[uniqueID] = [word]
        else:
            wordVector = wordDict[uniqueID]
            wordVector.append(word)
            wordDict[uniqueID] = wordVector

f2 = open(sys.argv[1], "r")
for l in f2:
    l = l.replace("\n", "")
    toks = l.split(",")
    uniqueID = int(toks[0]) - 235
    word = toks[1]
    contentWords = wordDict[uniqueID]
    if word not in contentWords:
        print l
