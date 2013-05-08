import sys, re, string

# read in relatedness_summary from Data/
# and stores uniquePairID -> rating data in dict
r_dict = dict()
r_summary = open("RelatednessExperiment/Data/relatedness_summary.csv", "r")
firstline = 0
for l in r_summary:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        uniquePairID = toks[1]
        relatedness = toks[3]
        r_dict[uniquePairID] = relatedness


# read in wordpairs_full
# and matches uniquePairID to relatedness ratings

f = open(sys.argv[1], "r")
firstline = 0
for l in f:
    if firstline == 0:
        print l
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        ID = toks[0]
        rating = r_dict[ID]
        print ",".join(toks[0:8]) + "," + rating

