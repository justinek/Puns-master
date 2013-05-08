import sys, re, string

# use the CMU dictionary to translate the homophones
# into phonetic transcription

cmu = open("../CMUDict/cmudict.0.7a.txt", "r")

cmuDict = dict()

for l in cmu:
    if not re.match(";", l):
        toks = l.split()
        word = toks[0]
        phones = " ".join(toks[1:])
        cmuDict[word] = phones

f = open("../Materials/nearPuns_homophones.txt", "r")

print "sentenceID\tsentence\tm1\tm2\tm1_phone\tm2_phone"

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split("\t")
        m1 = toks[2].upper()
        m2 = toks[3].upper()
        m1_phone = ""
        m2_phone = ""
        if m1 in cmuDict:
            m1_phone = cmuDict[m1]
        if m2 in cmuDict:
            m2_phone = cmuDict[m2]
        print toks[0] + "\t" + toks[1] + "\t" + toks[2] + "\t" + toks[3] + "\t" + m1_phone + "\t" + m2_phone


