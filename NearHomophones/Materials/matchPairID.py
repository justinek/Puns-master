import sys, string, re

# match word pairs in the incorrectly labeled byCondition file
# to the correct word pair IDs

# dictionary mapping word pairs with IDs
idDict = dict()

f = open("wordPairs.csv", "r")

firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        m1 = toks[5]
        word = toks[6]
        pairID = toks[0]
        idDict[m1 + "," + word] = pairID

f_incorrect = open("wordPairs_byCondition_exp2.csv", "r")

firstline = 0
for l in f_incorrect:
    l = l.replace("\n", "")
    if firstline == 0:
        print l
        firstline = 1
    else:
        origPairID = toks[0]
        #print origPairID
        toks = l.split(",")
        m1 = toks[5]
        word = toks[6]
        pairID = idDict[m1 + "," + word]
        print ",".join(toks[0:8]) + "," + pairID
        #else:
            #print ",".join(toks[0:8]) + "," + origPairID
