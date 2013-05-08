import sys, re, string

# reads in nearPuns_raw.csv. Prints out sentence ID,
# sentence, and the observed and alternative homophones

f = open("../Materials/nearPuns_raw.txt", "r")

print "sentenceID\tsentence\tm1\tm2"
sentenceID = 1

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split("\t")
        sentence = toks[0]
        words = sentence.translate(None, '!,.;:?').split()
        observedHomophone = ""
        alternativeHomophone = toks[1]
        for word in words:
            if re.search('#', word):
                word = word.translate(None, '#"')
                word = word.translate(None, "'")
                observedHomophone = word.lower()
        print str(sentenceID) + "\t" + sentence + "\t" +  observedHomophone + "\t" + alternativeHomophone       
        sentenceID = sentenceID + 1
