import sys, re, string

# compute and print the unigram frequencies of the target words

bncDict = dict()

bncF = open("../BNC/bnc_unigram.txt", "r")

totalCount = 0
for l in bncF:
    l = l.replace("\n", "")
    toks = l.split("\t")
    bncDict[toks[0]] = int(toks[1])
    totalCount = totalCount + int(toks[1])

f = open("../Materials/homophones.csv", "r")

firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
        print l
    else:
        toks = l.split(",")
        m1 = toks[3]
        m2 = toks[4]
        if m1 in bncDict:
            m1_prob = float(bncDict[m1]) / float(totalCount)
        else:
            m1_prob = float(1) / float(totalCount)
        if m2 in bncDict:
            m2_prob = float(bncDict[m2]) / float(totalCount)
        else:
            m2_prob = float(1) / float(totalCount)
        print ",".join(toks[0:5]) + "," + str(m1_prob) + "," + str(m2_prob)
