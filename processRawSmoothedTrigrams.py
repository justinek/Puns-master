# grab the trigram probabilities from the smoothed trigram output
# prints out only the trigram probabilities of content words and homophones 
import sys, re, string

fWords = open("functionWords.txt", "r")
fDict = dict()
fDict["the"] = 0
for w in fWords:
    w = w.replace("\n", "")
    toks = w.split("\t")
    fDict[toks[0]] = 0

hWords = open("homophones.csv", "r")
hDict = dict()
for w in hWords:
    w = w.replace("\n", "")
    toks = w.split(",")
    hDict[int(toks[0])] = toks[1]

f = open(sys.argv[1], "r")

sentenceID = 0
for l in f:
    l = l.replace("\n", "")
    if not re.match("\t", l) and not re.match("\d", l) and l != "":
        sentenceID = sentenceID + 1
        #print "sentence: " + l
    elif re.match("\t", l):
        toks = l.split(" ")
        word = toks[1].lower()
        prob = toks[7]
        if word != "</s>":
            #print hDict[sentenceID] + "end"
            #print word + "end"
            if word not in fDict or word == hDict[sentenceID]:
                if sentenceID > 235:
                    print str(sentenceID) + "," +  word + "," + prob
