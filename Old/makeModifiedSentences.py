# reads in original sentences and replaces homophone with alternative
# using a homophone dictionary built from "homophones.csv"

import sys, re, string

f = open("sentences_orig.csv", "r")
homs = open("homophones.csv", "r")

# homophone dictionary where the key is a homophone appearing in the original sentences
# and the value is the alternative homophone

homDict = dict()

firstline = 0
for l in homs:
    l = l.replace("\n", "")
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        hom1 = toks[2]
        hom2 = toks[3]
        homDict[hom1] = hom2
    
firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        print l
        firstline = 1
    else:
        l = l.lower()
        toks = l.split(",")
        sentenceID = toks[0]
        homophoneID = toks[1]
        #if "a" in homophoneID:
        #    homophoneID = homophoneID.replace("a", "b")
        #else:
        #    homophoneID = homophoneID.replace("b", "a")
        phoneticID = toks[2]
        homophone = toks[3]
        sentenceType = toks[4]
        isOrig = toks[5]
        if '"' not in toks[6]:
            sentence = '"' + toks[6] 
        else:
            sentence = toks[6]
        #print sentence
        print sentenceID + "|" + homophoneID + "|" + phoneticID + "|" + homophone + "|" + sentenceType + "|" + "0" + "|" + sentence + '"' 
        
        hom1 = "#" + homophone
        hom2 = "#" + homDict[homophone]
        sentence = sentence.replace(hom1, hom2)
        #print sentence
        #print sentenceID + "|" + homophoneID + "|" + phoneticID + "|" + homDict[homophone] + "|" + sentenceType + "|" + "1" + "|" + sentence

    
