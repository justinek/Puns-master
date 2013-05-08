# reads in wordPairs and trigramProbs_h1_h2
# and prints out only the trigram probabilities of content words.

import sys, re, string

unigrams = open(sys.argv[1], "r")
# stores all the unigram probabilities of content words
unigramsDict = dict()
firstline = 0
for l in unigrams:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        unigramsDict[toks[0]] = toks[1]


trigrams = open(sys.argv[2], "r")
# stores all the trigram probabilities based on sentence ID
trigramsDict = dict()
firstline = 0
for l in trigrams:
    if firstline == 0:
        firstline = 1
    else:
        l = l.lower()
        l = l.replace("\n", "")
        toks = l.split(",")
        uniqueID = toks[0]
        h1_trigram_words = toks[1].split(" ")
        h1_trigram_end = h1_trigram_words[len(h1_trigram_words) - 1]
        # if there is already an entry of this sentence in the trigrams dictionary
        if uniqueID in trigramsDict:
            probDict = trigramsDict[uniqueID]
        # else create a new one
        else:
            probDict = dict()
        probDict[h1_trigram_end] = [toks[3], toks[4]]
        trigramsDict[uniqueID] = probDict

wordPairs = open(sys.argv[3], "r")

firstline = 0
for l in wordPairs:
    if firstline == 0:
        toks = l.split(",")
        print ",".join(toks[1:len(toks) - 1]) + ",h1_ngramProb,h2_ngramProb"
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        ID = toks[1]
        word = toks[8]
        trigramsInfo = trigramsDict[ID]
        # if there is trigram probability for this word
        if word in trigramsInfo:
            trigrams_h1 = trigramsInfo[word][0]
            trigrams_h2 = trigramsInfo[word][1]
            print ",".join(toks[1:len(toks) - 1]) + "," +  trigrams_h1 + "," + trigrams_h2
        # if this is the first or second word, use unigram
        else:
            unigram = unigramsDict[word]
            print ",".join(toks[1:len(toks) - 1]) + "," + unigram + "," + unigram







