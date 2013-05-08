# computes maximal KL divergence for each sentence by looking up
# word pair relatedness from relatedness_orig.csv or relatedness_mod.csv 
# and homophone log probability from homophone_unigram.csv.
# prints out the contexts that produce the maximal KL divergence
# as well as the KL divergence itsef for each sentence.

import sys, re, string, itertools
import math

# The output is formatted as follows:

print "uniqueID,sentenceType,sumKL,numContextCombos,aveKL"

# a dictionary holding unigram probabilities for h1 (original homophone)
# indexed by the original homophone
hom1ProbDict = dict()

# a dictionary holding unigram probabilities for h2 (modified homophone)
# indexed by the oriignal homophone
hom2ProbDict = dict()

unigramFile = open(sys.argv[2], "r")

firstLine = 0

for l in unigramFile:
    if firstLine == 0:
        firstLine = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        key = toks[2]
        h1Prob = toks[4]
        h2Prob = toks[5]
        hom1ProbDict[key] = math.log(float(h1Prob))
        hom2ProbDict[key] = math.log(float(h2Prob))

# a dictionary holding word pair information, with each entry being a sentence
sentenceDict = dict()

pairFile = open(sys.argv[1], "r")

firstLine = 0

for l in pairFile:
    if firstLine == 0:
        firstLine = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        uniqueID = int(toks[1])
        sentenceType = toks[5]
        uniquePairID = toks[0]
        word = toks[8]
        # original homophone
        hom = toks[7]
        # relatedness of observed word with original homophone (h1)
        hom1_relatedness = toks[9]
        # relatedness of observed word with modified homophone (h2)
        hom2_relatedness = toks[10]
        
        # if this is the first word pair entry for the sentence,
        # intializes all the relevant information and puts it in
        # the dictionary indexed by sentence ID
        if uniqueID not in sentenceDict:
            # wordArray is an array of observed words for each sentence
            wordArray = [word]

            # hom1RelatednessArray is an array of relatedness for the observed words
            # and the original homophone (h1)
            hom1RelatednessArray = [hom1_relatedness]
            
            # hom2RelatednessArray is an array of relatedness for the observed words
            # and the modified homophone (h2)
            hom2RelatednessArray = [hom2_relatedness]
            
            # infoArray is an array of all the relevant information for a sentence,
            # namely whether it is a pun, the original homophone, the array of observed words,
            # the array of relatedness for the observed words and h1, and the array of relatedness
            # for the observed words and h2
            infoArray = [sentenceType, hom, wordArray, hom1RelatednessArray, hom2RelatednessArray]
            
            # places the infoArray for the sentence in the dictionary
            sentenceDict[uniqueID] = infoArray

        # if the sentence is already in the dictionary, updates the information for that sentence
        # with information from the new pair
        else:
            # retrieves the current infoArray for the sentence
            infoArray = sentenceDict[uniqueID]
            
            # infoArray[2] is the array of observed words. Updates it with the observed word from current pair
            infoArray[2].append(word)

            # infoArray[3] is the array of relatedness with h1. Updates it with relatedness from current pair
            infoArray[3].append(hom1_relatedness)

            # infoArray[4] is the array of relatedness with h2. Updates it with relatedness from current pair
            infoArray[4].append(hom2_relatedness)

            # puts the updated infoArray into the dictionary indexed by sentenceID
            sentenceDict[uniqueID] = infoArray

# f is a function that generates all subsets of a list
f = lambda x: [[y for j, y in enumerate(set(x)) if (i >> j) & 1] for i in range(2**len(set(x)))]

# sublist is a function htat gets elements in list based on a list of indices
sublist = lambda searchList, ind: [searchList[i] for i in ind]

# iterates through all the sentences in sentenceDict in the order of sentenceID
for k, v in sentenceDict.iteritems():

    # sentenceID
    uniqueID = str(k)

    # isPun
    sentenceType = v[0]

    # the original homophone (not necessarily the one observed. Just the more standard one.
    hom = v[1]

    # the log probablity of the original homophone h1
    hom1PriorProb = hom1ProbDict[hom]

    # the log probability of the modified homophone h2
    hom2PriorProb = hom2ProbDict[hom]

    # array of all observed words in the sentence
    contextWords = v[2]

    # array of relatedness measures with all words and h1
    hom1Relatedness = v[3]

    # array of relatedness measures with all words and h2
    hom2Relatedness = v[4]

    # makes a list of all possible subsets containing the integers
    # 0 - len(contextWords) - 1
    contextSubsets = list(f(range(len(contextWords))))

    # print contextSubsets
    
    # intializes maxKL as the smallest possible number
    sumKL = 0

    numContextCombos = 0
    # intializes maxC1 as the empty set
    #maxC1 = []

    # intializes maxC2 as the empty set
    #maxC2 = []

    maxHom1c1Prob = 0
    maxHom2c1Prob = 0
    maxHom1c2Prob = 0
    maxHom2c2Prob = 0

    # iterates through all subsets of indices in contextSubsets
    for subset1 in contextSubsets:
        # ignores empty subsets
        if len(subset1) > 0:
            
            # c1 is context1, the subset of contextWords selected using the
            # subset1 indices
            c1 = sublist(contextWords, subset1)

            # hom1c1 is the array of relatedness between h1 and words in c1
            # selected from hom1Relatedness using the subset1 indices
            hom1c1 = sublist(hom1Relatedness, subset1)

            # hom2c1 is the array of relatedness between h2 and words in c1
            # selected from hom1Relatedness using the subset1 indices
            hom2c1 = sublist(hom2Relatedness, subset1)

            # hom1c1Score is the sum of all the relatedness meausres between h1 and words in c1
            # added to the prior probability of h1, namely sum(R(c1i, h1)) + P(h1), which is
            # our approximation for log P(h1 | C1).
            hom1c1Score = sum(map(float, hom1c1)) + float(hom1PriorProb)

            # hom2c1Score is the sum of all the relatedness measures between h2 and words in c1
            # addd to the prior probability of h2, namely sum(R(c1i, h2)) + P(h2), which is
            # our approxiation for log P(h2 | C1).
            hom2c1Score = sum(map(float, hom2c1)) + float(hom2PriorProb)
            
            # exponentiates hom1c1Score and hom2c1Score to probability space 
            hom1c1Prob = math.exp(hom1c1Score)
            hom2c1Prob = math.exp(hom2c1Score)

            # We now have P(h1 | C1) and P(h2 | C1) for this particular C1

            # We now iterate through all possible C2 by iterating through all possible subsets of indices
            for subset2 in contextSubsets:
                # ignores empty set
                if len(subset2) > 0:

                    # c2 is selected from contextWords using the indices specified by subset2
                    c2 = sublist(contextWords, subset2)

                    # hom1c2 is an array of relatedness between h1 and words in c2
                    hom1c2 = sublist(hom1Relatedness, subset2)

                    # hom2c2 is an array of relatedness between h2 and words in c2
                    hom2c2 = sublist(hom2Relatedness, subset2)
                    
                    # Approximation for log P(h1 | C2)
                    hom1c2Score = sum(map(float, hom1c2)) + float(hom1PriorProb)
                    
                    # Approximation for log P(h2 | C2)
                    hom2c2Score = sum(map(float, hom2c2)) + float(hom2PriorProb)

                    # exponentiates hom1c2Score and hom2C2Scores into probability space
                    hom1c2Prob = math.exp(hom1c2Score)
                    hom2c2Prob = math.exp(hom2c2Score)

                    # computes symmetrized KL
                    KL = math.log(hom1c1Prob/hom1c2Prob)*hom1c1Prob+math.log(hom1c2Prob/hom1c1Prob)*hom1c2Prob 
                    + math.log(hom2c1Prob/hom2c2Prob)*hom2c1Prob+math.log(hom2c2Prob/hom2c1Prob)*hom2c2Prob
                    
                    sumKL = sumKL + KL
                    numContextCombos = numContextCombos + 1

                    # updates maxKL if current KL is greater than current maxKL
                    #if KL > maxKL:
                    #    maxKL = KL
                        
                        # updates maxC1, maxC2 if currennt c1, c2 produces KL that is greater than current maxKL
                    #    maxC1 = c1
                    #    maxC2 = c2
                        #maxHom1c1Prob = hom1c1Score
                        #maxHom2c1Prob = hom2c1Score
                        #maxHom1c2Prob = hom1c2Score
                        #maxHom2c2Prob = hom2c2Score


    print uniqueID + "," + sentenceType + "," + str(sumKL) + "," + str(numContextCombos) + "," + str(float(sumKL) / float(numContextCombos))
    #print ';'.join(maxC1),
    #print ",",
    #print ';'.join(maxC2),
    #print "," + str(maxHom1c1Prob) + "," + str(maxHom2c1Prob) + "," + str(maxHom1c2Prob) + "," + str(maxHom2c2Prob),
    #print "," + str(maxKL)


