import sys, re, string

# build a dictionary mapping word pairs [homophone;word] with uniquePairIDs

idF = open("wordPairs_unique.csv", "r")

idDict = dict()
firstline = 0

for l in idF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        ID = toks[0]
        pair = toks[2] + ";" + toks[3]
        idDict[pair] = ID


f = open("wordPairs.csv", "r")

firstline = 0

for l in f:
    if firstline == 0:
        print l
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        pair = toks[6] + ";" + toks[7]
        ID = idDict[pair]
        print ID + ",",
        print l

