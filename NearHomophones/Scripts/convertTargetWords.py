import sys, re, string

# very dumb script for converting a list of target words into their counterparts

targetDict = dict()

targetF = open("../Materials/nearPuns_targetWords.csv", "r")

for l in targetF:
    l = l.replace("\n", "")
    l = l.lower()
    toks = l.split(",")
    #print toks[0]
    targetDict[toks[0]] = toks[1]
    targetDict[toks[1]] = toks[0]
listToConvert = open("../Materials/nearPuns_nonpuns_m1.csv", "r")
for l in listToConvert:
    l = l.replace("\n", "")
    toks = l.split(",")
    #print toks[0]
    print targetDict[toks[0]]
