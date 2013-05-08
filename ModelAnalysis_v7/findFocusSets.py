# computes focus disjointedness term P(f | m, w) using
# word pair relatedness from wordPair_relatedness_*.csv 
# and homophone log probability from homophone_unigram.csv
# and content word log probability from contentWord_unigram.csv

import sys, re, string, itertools
import math


def normListSumTo(L, sumTo=1):
    sum = reduce(lambda x,y:x+y, L)
    return [ x/(sum*1.0)*sumTo for x in L]

relatedness_param = float(sys.argv[2])
scale_param = float(sys.argv[3])


# The output is formatted as follows:

print "uniqueID,sentenceType,isOrig,contentWords,focusWordsM1,focusWordsM2"

# a dictionary holding unigram probabilities for h1 (original homophone)
# indexed by the original homophone
m1ProbDict = dict()

# a dictionary holding unigram probabilities for h2 (modified homophone)
# indexed by the oriignal homophone
m2ProbDict = dict()

unigramFile = open("../homophones_unigram.csv", "r")

firstLine = 0

for l in unigramFile:
    if firstLine == 0:
        firstLine = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        key = toks[2]
        m1Prob = toks[4]
        m2Prob = toks[5]
        m1ProbDict[key] = math.log(float(m1Prob))
        m2ProbDict[key] = math.log(float(m2Prob))


# a dictionary holding the unigram probabilities for each content word
wordProbDict = dict()

wordFile = open("../contentWords_unigram.csv", "r")
firstline = 0
for l in wordFile:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        word = toks[0]
        prob = toks[1]
        wordProbDict[word] = math.log(float(prob))


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
        isOrig = toks[6]
        uniquePairID = toks[0]
        word = toks[8]
        # original homophone
        hom = toks[7]
        # relatedness of observed word with original homophone (h1)
        m1_relatedness = float(toks[9])
        # relatedness of observed word with modified homophone (h2)
        m2_relatedness = float(toks[10])
        
        # if this is the first word pair entry for the sentence,
        # intializes all the relevant information and puts it in
        # the dictionary indexed by sentence ID
        if uniqueID not in sentenceDict:
            # wordArray is an array of observed words for each sentence
            wordArray = [word]

            # hom1RelatednessArray is an array of relatedness for the observed words
            # and the original homophone (h1)
            m1RelatednessArray = [relatedness_param]
            
            # hom2RelatednessArray is an array of relatedness for the observed words
            # and the modified homophone (h2)
            m2RelatednessArray = [0]
            
            # infoArray is an array of all the relevant information for a sentence,
            # namely whether it is a pun, the original homophone, the array of observed words,
            # the array of relatedness for the observed words and h1, and the array of relatedness
            # for the observed words and h2
            infoArray = [sentenceType, isOrig, hom, wordArray, m1RelatednessArray, m2RelatednessArray]
            
            # places the infoArray for the sentence in the dictionary
            sentenceDict[uniqueID] = infoArray

        # if the sentence is already in the dictionary, updates the information for that sentence
        # with information from the new pair
        else:
            # retrieves the current infoArray for the sentence
            infoArray = sentenceDict[uniqueID]
            
            # infoArray[2] is the array of observed words. Updates it with the observed word from current pair
            infoArray[3].append(word)

            # infoArray[3] is the array of relatedness with h1. Updates it with relatedness from current pair
            infoArray[4].append(m1_relatedness)

            # infoArray[4] is the array of relatedness with h2. Updates it with relatedness from current pair
            infoArray[5].append(m2_relatedness)

            # puts the updated infoArray into the dictionary indexed by sentenceID
            sentenceDict[uniqueID] = infoArray

# iterates through all the sentences in sentenceDict in the order of sentenceID
for k, v in sentenceDict.iteritems():

    # sentenceID
    uniqueID = str(k)

    # isPun
    sentenceType = v[0]
    
    # isOrig
    isOrig = v[1]

    # the original homophone (not necessarily the one observed. Just the more standard one.
    hom = v[2]

    # the log probablity of the original homophone h11
    m1PriorProb = m1ProbDict[hom]

    # the log probability of the modified homophone h2
    m2PriorProb = m2ProbDict[hom]

    # array of all observed words in the sentence
    words = v[3]
    
    # number of content words in sentence
    numWords = len(words)

    # array of relatedness measures with all words and h1
    m1Relatedness = v[4]

    # array of relatedness measures with all words and h2
    m2Relatedness = v[5]

    # makes a list of all possible focus vectors1
    focusVectors =list(itertools.product([False, True], repeat=numWords))

    #print focusVectors
    
    # vector containing probabilities for each f,w combination given M1
    fWGivenM1 = []
    # vector containing probabilities for each f,w combination given M2
    fWGivenM2 = []

    # iterates through all subsets of indices in contextSubsets
    for fVector in focusVectors:
        #print "Words: " + ";".join(words)
        #print "Focus vector: ",
        #print fVector
        
        # probabilty of each word being in focus (coin weight)
        probWordInFocus = 0.5 # can be tweaked

        # Probability of a focus vector
        # Determined by the number of words in focus (number of "True" in vector) vs not
        numWordsInFocus = sum(fVector)
        
        probFVector = math.pow(probWordInFocus, numWordsInFocus) * math.pow(1 - probWordInFocus, numWords - numWordsInFocus)
        sumLogProbWordsGivenM1F = 0
        sumLogProbWordsGivenM2F = 0
        wordsInFocus = []
        for j in range(numWords):
            wordj = words[j]
            if fVector[j] is True:
                wordsInFocus.append(wordj)
                logProbWordGivenM1 = wordProbDict[wordj] + m1Relatedness[j] + scale_param
                logProbWordGivenM2 = wordProbDict[wordj] + m2Relatedness[j] + scale_param
                sumLogProbWordsGivenM1F = sumLogProbWordsGivenM1F + logProbWordGivenM1
                sumLogProbWordsGivenM2F = sumLogProbWordsGivenM2F + logProbWordGivenM2
            else:
                logProbWord = wordProbDict[wordj]
                sumLogProbWordsGivenM1F = sumLogProbWordsGivenM1F + logProbWord
                sumLogProbWordsGivenM2F = sumLogProbWordsGivenM2F + logProbWord
        
        # P(f | m, w) \propto P(w | m, f) P(f | m) -> since f, m are independent, this just goes to P(f)
        probFGivenWordsM1 = math.exp(math.log(probFVector) + sumLogProbWordsGivenM1F)
        probFGivenWordsM2 = math.exp(math.log(probFVector) + sumLogProbWordsGivenM2F)
        fWGivenM1.append(probFGivenWordsM1)
        fWGivenM2.append(probFGivenWordsM2)

    # normalizes probability vectors of F to sum to 1 for each M1 and M2
    normalizedFWGivenM1 = normListSumTo(fWGivenM1, 1)
    normalizedFWGivenM2 = normListSumTo(fWGivenM2, 1)
    
    # find F vector with maximal probabiltiy given m1 and m2
    #print normalizedFWGivenM1
    #print normalizedFWGivenM2
    #print normalizedFWGivenM1.index(max(normalizedFWGivenM1))
    maxM1FocusVector = focusVectors[normalizedFWGivenM1.index(max(normalizedFWGivenM1))]
    maxM2FocusVector = focusVectors[normalizedFWGivenM2.index(max(normalizedFWGivenM2))]

    # find words in focus given maxM1FocusVector and maxM2FocusVector
    maxM1FocusWords = []
    maxM2FocusWords = []
    for i in range(len(maxM1FocusVector)):
        if maxM1FocusVector[i] is True:
            maxM1FocusWords.append(words[i])
        if maxM2FocusVector[i] is True:
            maxM2FocusWords.append(words[i])


    # compute symmetrised KL between the two distributions
    #print ";".join(words)
    #print ";".join(maxM1FocusWords)
    #print ";".join(maxM2FocusWords)
    
    print uniqueID + "," + sentenceType + "," + str(isOrig) + "," + "," + ";".join(maxM1FocusWords) + "," + ";".join(maxM2FocusWords)

