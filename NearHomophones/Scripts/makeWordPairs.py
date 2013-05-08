import sys, re, string

f = open("../Materials/sentences_all.txt", "r")
functionWords = open("../Materials/functionWords.txt", "r")

functionDict = dict()

# puts all the function words in a dictionary
for l in functionWords:
    fw = l.replace("\n", "").split("\t")[0]
    fw = fw.replace(" ", "")
    functionDict[fw.lower()] = 0

print "pairID,sentenceID,sentenceType,homophoneID,version,m1,word"

pairID = 1
firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split("\t")
        uniqueID = toks[0]
        sentenceType = toks[1]
        homophoneID = toks[2]
        phoneticID = toks[3]
        sentence = toks[4].lower()
        sentence = sentence.translate(None, '"!?.,;:')
        m1 = toks[5].lower()
        m2 = toks[6].lower()
        words = sentence.split(" ")
        for word in words:
            if word not in functionDict.keys() and word is not "":
                if word.replace("'", "") != m1.replace("'", ""):
                    print str(pairID) + "," + uniqueID + "," + sentenceType + "," + homophoneID + "," + phoneticID  + "," + m1 + "," + word
                    pairID = pairID + 1
