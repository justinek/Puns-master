import sys, re, string

f = open("homophones.csv", "r")

firstline = 0

for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        print "homophoneID," + l
        firstline = 1
    else :
        toks = l.split(",")
        print toks[0] + "-" + toks[1] + "," + l
