import sys, re, string

# replace the target word with its near-homophone
# reads in nearPuns_homophones.txt

f = open("../Materials/nearPuns_homophones.txt", "r")

for l in f:
    l = l.replace("\n", "")
    toks = l.split("\t")
    sentence = toks[1]
    m1 = toks[2]
    m2 = toks[3]
    sentence = sentence.replace("#" + m1, m2)
    print sentence
