import sys, re, string

f = open("sentences.csv", "r")
functionWords = open("functionWords.txt", "r")

functionDict = dict()

# puts all the function words in a dictionary
for l in functionWords:
    fw = l.replace("\n", "").split("\t")[0]
    fw = fw.replace(" ", "")
    functionDict[fw.lower()] = 0

#for k, v in functionDict.iteritems():
    #print k,
    
firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        uniqueID = toks[0]
        sentenceID = toks[1]
        homophoneID = toks[2]
        phoneticID = toks[3]
        homophone = toks[4]
        sentenceType = toks[5]
        isOrig = toks[6]
        sentence = toks[7].lower()
        words = sentence.split(" ")
        for word in words:
            if "#" not in word:
                word = word.translate(None, '!?.,;:')
                if word not in functionDict.keys() and word is not "":
                    print uniqueID + "," + sentenceID + "," + homophoneID + "," + phoneticID + "," + sentenceType + "," + isOrig + "," + homophone + "," + word

