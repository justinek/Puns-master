# prints out the trigrams and their sentence ID numbers

import sys, re, string

f = open("sentences_numbered.csv", "r")

for l in f:
    l = l.replace("\n", "")
    toks = l.split(",")
    ID = toks[0]
    sentence = toks[1]
    sentence = re.sub("[!.@'#$,;]", '', sentence)
    words = sentence.split(" ")
    for i in range(len(words) - 2):
        trigram = words[i:i+3]
        print ID + "," + " ".join(trigram)
