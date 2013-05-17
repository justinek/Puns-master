import sys, re, string

m1Dict = dict()
m2Dict = dict()

targetF = open("targetWords.csv", "r")

firstline = 0

for l in targetF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        sentenceID = toks[0]
        m1 = toks[3].lower()
        m2 = toks[4].lower()
        m1Dict[sentenceID] = m1
        m2Dict[sentenceID] = m2

#for k, v in m1Dict.iteritems():
#    print k + "," +v

f = open("trigramOutput_processed_allWords_replaceUnk.txt", "r")

for l in f:
    l = l.replace("\n", "")
    toks = l.split("\t")
    sentenceID = toks[0]
    word = toks[1]
    prob = toks[2]
    version = toks[3]
    if version == "m1":
        if m1Dict[sentenceID] == word:
            print sentenceID + "," + version + "," + word + "," + prob
    elif version == "m2":
        if m2Dict[sentenceID] == word:
            print sentenceID + "," + version +"," + word + "," + prob
