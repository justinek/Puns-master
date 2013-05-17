# computes ambiguity term P(m | w) using
# word pair relatedness and trigram probabilities 
# from wordPair_relatedness_trigram_orig.csv,
# homophone log probability from homophone_unigram.csv.

import sys, re, string, itertools
import math

# The output is formatted as follows:

homophone_relatedness = float(sys.argv[2])
parameter = float(sys.argv[3])
print "uniqueID,sentenceType,isOrig,p_m1_given_w,p_m2_given_w, entropy"

# a dictionary holding unigram probabilities for h1 (original homophone)
# indexed by the original homophone
m1ProbDict = dict()

# a dictionary holding unigram probabilities for h2 (modified homophone)
# indexed by the oriignal homophone
m2ProbDict = dict()

# homophone unigram
unigramFile = open("../Materials/homophones_unigram.csv", "r")

firstLine = 0

for l in unigramFile:
    if firstLine == 0:
        firstLine = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        key = toks[3].lower()
        m1Prob = toks[5]
        m2Prob = toks[6]
        m1ProbDict[key] = math.log(float(m1Prob))
        m2ProbDict[key] = math.log(float(m2Prob))

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
        uniqueID = int(toks[0])
        sentenceType = toks[3]
        isOrig = "m1"
        # observed homophone
        hom = toks[4]
        # content word
        word = toks[5]
        # relatedness of observed word with observed homophone (m1)
        m1_relatedness = float(toks[6])
        # relatedness of observed word with alternative homophone (m2)
        m2_relatedness = float(toks[7])
        # prior trigram probability of the content word with observed homophone (m1)
        m1_ngram = math.log(float(toks[9]))
        # prior trigram probability of the content word with the alternative homophone (m2)
        m2_ngram = math.log(float(toks[10]))

        # if this is the first word pair entry for the sentence,
        # intializes all the relevant information and puts it in
        # the dictionary indexed by sentence ID
        if uniqueID not in sentenceDict:
            # wordArray is an array of observed words for each sentence
            wordArray = [word]

            # hom1RelatednessArray is an array of relatedness for the observed words
            # and the original homophone (h1)
            m1RelatednessArray = [homophone_relatedness]
            
            # hom2RelatednessArray is an array of relatedness for the observed words
            # and the modified homophone (h2)
            m2RelatednessArray = [0]
            
            # m1NgramArray is an array of ngram probabilities for the observed words and the original homophone
            m1NgramArray = [m1_ngram]

            # m2NgramArray is an array of ngram probs for the observed words and the modified homophone
            m2NgramArray = [m2_ngram]

            # infoArray is an array of all the relevant information for a sentence,
            # namely whether it is a pun, the original homophone, the array of observed words,
            # the array of relatedness for the observed words and h1, and the array of relatedness
            # for the observed words and h2
            infoArray = [sentenceType, isOrig, hom, wordArray, m1RelatednessArray, m2RelatednessArray, m1NgramArray, m2NgramArray]
            
            # places the infoArray for the sentence in the dictionary
            sentenceDict[uniqueID] = infoArray

        # if the sentence is already in the dictionary, updates the information for that sentence
        # with information from the new pair
        else:
            # retrieves the current infoArray for the sentence
            infoArray = sentenceDict[uniqueID]
            
            # infoArray[3] is the array of observed words. Updates it with the observed word from current pair
            infoArray[3].append(word)

            # infoArray[4] is the array of relatedness with h1. Updates it with relatedness from current pair
            infoArray[4].append(m1_relatedness)

            # infoArray[5] is the array of relatedness with h2. Updates it with relatedness from current pair
            infoArray[5].append(m2_relatedness)

            # infoArray[6] is the array of ngram with h1
            infoArray[6].append(m1_ngram)

            # infoArray[7] is the array of ngram with h2
            infoArray[7].append(m2_ngram)

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
    #print hom
    #print m1ProbDict
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

    # array of ngram with all words and h1
    m1Ngram = v[6]

    # array of ngram with all words and h2
    m2Ngram = v[7]

    # makes a list of all possible focus vectors1
    focusVectors =list(itertools.product([False, True], repeat=numWords))

    #print focusVectors

    sumOverMF = 0
    sumM1OverF = 0
    sumM2OverF = 0
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

        wordsInFocus = []
        sumLogProbWordsGivenM1F = 0
        sumLogProbWordsGivenM2F = 0
        for j in range(numWords):
            wordj = words[j]
            if fVector[j] is True:
                wordsInFocus.append(wordj)
                logProbWordGivenM1 = m1Ngram[j] + m1Relatedness[j] + parameter
                logProbWordGivenM2 = m2Ngram[j] + m2Relatedness[j] + parameter
                sumLogProbWordsGivenM1F = sumLogProbWordsGivenM1F + logProbWordGivenM1
                sumLogProbWordsGivenM2F = sumLogProbWordsGivenM2F + logProbWordGivenM2
            else:
                logProbWordGivenM1_ngram = m1Ngram[j]
                logProbWordGivenM2_ngram = m2Ngram[j]
                sumLogProbWordsGivenM1F = sumLogProbWordsGivenM1F + logProbWordGivenM1_ngram
                sumLogProbWordsGivenM2F = sumLogProbWordsGivenM2F + logProbWordGivenM2_ngram
        
        # with homophone prior
        probM1FGivenWords = math.exp(m1PriorProb + math.log(probFVector) + sumLogProbWordsGivenM1F)
        probM2FGivenWords = math.exp(m2PriorProb + math.log(probFVector) + sumLogProbWordsGivenM2F)
        
        # no homophone prior
        #probM1FGivenWords = math.exp(math.log(probFVector) + sumLogProbWordsGivenM1F)
        #probM2FGivenWords = math.exp(math.log(probFVector) + sumLogProbWordsGivenM2F)
       
    # sums over all possible focus vectors

    sumM1OverF = sumM1OverF + probM1FGivenWords
    sumM2OverF = sumM2OverF + probM2FGivenWords
    sumOverMF = sumOverMF + probM1FGivenWords + probM2FGivenWords
    
    # normalizes
    probM1 = sumM1OverF / sumOverMF
    probM2 = sumM2OverF / sumOverMF

    entropy = - (probM1 * math.log(probM1) + probM2 * math.log(probM2)) 
    #print "Words: " + ";".join(words)
    #print "P(m1): " + str(math.exp(m1PriorProb)) + "; P(m2): " + str(math.exp(m2PriorProb))
    print uniqueID + "," + sentenceType + "," + str(isOrig) + "," + str(probM1) + "," + str(probM2) + "," + str(entropy)
    #print "P(m1|w): " + str(probM1) + "; P(m2|w): " + str(probM2)

