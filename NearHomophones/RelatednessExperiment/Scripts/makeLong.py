import sys, re, string

# turn zscored data into long form

f = open("../Data/data_zscored_corrected.txt", "r")

subjectFields = ["workerID", "gender", "age", "condition"]
itemFields = ["pairID", "order", "wordOrder", "result", "zscored"]

#subjectIndices = [0, 1, 2, 3]
#itemIndices = [4, 5, 6, 7]

print "workerID,gender,age,condition,pairID,order,wordOrder,rating,zscored"
firstline = 0
for l in f:
    l = l.replace("\n", "")
    toks = l.split("\t")
    if firstline == 0:
        firstline = 1
    else:
        numItems = len(toks[4].split(","))
        for n in range(numItems):
            print ",".join(toks[0:4]) + "," + toks[4].split(",")[n] + "," + toks[5].split(",")[n] + "," + toks[6].split(",")[n] + "," + toks[7].split(",")[n] + "," + toks[8].split(",")[n]

