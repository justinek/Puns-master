import sys, re, string

f = open("../Materials/nonPuns_orig.txt", "r")

for l in f:
    l = l.replace("\n", "")
    l = l.replace('"', "")
    toks = l.split("\t")
    sentence = toks[4].lower()
    m1 = toks[5].lower()
    m2 = toks[6].lower()
    sentence = sentence.replace(m1, m2)
    print sentence
