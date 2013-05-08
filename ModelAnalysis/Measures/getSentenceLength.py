# gets length of each sentence from a file like "measures_orig.csv" 
# and prints it out to
# understand whether length is what's driving
# the large KLs in non-puns

import sys, re, string

f = open(sys.argv[1], "r")

firstline = 0

for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        toks = l.split(",")
        print ",".join(toks[1:len(toks)-1]) + ",sentenceLength"
        firstline = 1
    else:
        toks = l.split(",")
        sentence = toks[7]
        words = sentence.split(" ")
        length = len(words)
        print ",".join(toks[1:len(toks)-1])  + "," + str(length)
