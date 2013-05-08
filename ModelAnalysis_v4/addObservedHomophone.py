import sys, re, string

# adds a word pair for each sentence grouping
# that is relatedness of the observed homophone to itself
# and to the alternative homophone

pairF = open(sys.argv[1], "r")

currentID = 0

self_relatedness = 3
other_relatedness = -1

firstline = 0
for l in pairF:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
        print l
    else:
        toks = l.split(",")
        uniqueID = int(toks[1])
        sentenceID = toks[2]
        homophoneID = toks[3]
        phoneticID = toks[4]
        sentenceType = toks[5]
        isOrig = toks[6]
        homophone = toks[7]
        if uniqueID != currentID:
            print "0," + str(uniqueID) + "," + sentenceID + "," + homophoneID + "," + phoneticID + "," + sentenceType + "," + isOrig + "," + homophone + "," + homophone + "," + str(self_relatedness) + "," + str(other_relatedness) + ",0"
            currentID = uniqueID
            print l
        else:
            print l
