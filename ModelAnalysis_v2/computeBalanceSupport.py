import math, sys, re, string

f = open(sys.argv[1], "r")

sentenceDict = dict()
firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
        print "uniqueID,sentenceType,isOrig,normal,support,balance"
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        uniqueID = int(toks[1])
        sentenceType = toks[5]
        #print sentenceType
        isOrig = toks[6]
        normal = toks[11]
        hom1 = float(toks[9])
        hom2 = float(toks[10])
        if uniqueID not in sentenceDict:
            hom1s = [hom1]
            hom2s = [hom2]
            infoArr = [sentenceType, isOrig, normal, hom1s, hom2s]
            #print infoArr
            sentenceDict[uniqueID] = infoArr
        else:
            infoArr = sentenceDict[uniqueID]
            infoArr[3].append(hom1)
            infoArr[4].append(hom2)
            sentenceDict[uniqueID] = infoArr


for ID, info in sentenceDict.iteritems():
    #print str(ID)
    print info
    sentenceType = info[0]
    isOrig = info[1]
    normal = info[2]
    hom1s = info[3]
    hom2s = info[4]
    support = math.fabs(sum(hom1s)) + math.fabs(sum(hom2s))
    balance = math.fabs(sum(hom1s) - sum(hom2s))
    print str(ID) + "," + sentenceType + "," + isOrig + "," + normal + "," + str(support) + "," + str(balance)




