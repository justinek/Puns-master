import re, string, sys

# replace the incorrect pair IDs

idDict = dict()

idF = open("../conditions.txt", "r")

for l in idF:
    l = l.replace("\n", "")
    toks = l.split("\t")
    idDict[toks[0]] = toks[1]

f = open("../Data/data_raw_filterLanguage.txt", "r")

firstline = 0

indexPairID = 0
for l in f:
    l = l.replace("\n", "")
    toks = l.split("\t")
    if firstline == 0:
        indexPairID = toks.index("Answer.uniquePairIDs")
        indexCondition = toks.index("Answer.condition")
        firstline = 1
        print l
    else:
        condition = toks[indexCondition]
        if int(condition) >= 13:
            newPairIDs = idDict[condition]
            oldPairIDs = toks[indexPairID]
            l = l.replace(oldPairIDs, newPairIDs)
        print l
