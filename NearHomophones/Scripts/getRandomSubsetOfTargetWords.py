import sys, re, random, string

# read in pairs of target words and chooses a random subset of them

f = open("../Materials/targetWords.csv", "r")

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        l = l.lower()
        if random.randint(0, 3) == 0:
            print l

