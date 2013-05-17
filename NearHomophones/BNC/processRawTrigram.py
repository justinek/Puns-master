import sys, re, string

# reads in raw trigram output
# prints out sentence ID and the trigram
# probability of each individual token in the sentence

f = open("trigramOutput_raw.txt", "r")

sentenceID = 0
for l in f:
    l = l.replace("\n", "")
    if not re.match("file", l) and not re.match("\t", l) and not re.match("\d", l) and l != "":
        sentenceID = sentenceID + 1
    elif re.match("\t", l):
        toks = l.split(" ")
        word = toks[1].lower()
        prob = toks[7]
        if word != "</s>" and not word in string.punctuation:
            print str(sentenceID) + "\t" + word + "\t" + prob

