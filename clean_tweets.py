# -*- coding: utf-8 -*-
# requires: nltk package (pip it) and run in python:
# import nltk
# nltk.download()

import re
import csv
import string
from nltk.corpus import stopwords
from nltk.stem import SnowballStemmer
import textmining
import numpy as np
import scipy
from scipy import io

# file to load and file to write
tweet_filename = 'Tweets.csv'
new_tweet_filename = 'tweets2.csv'

# load personal stop list
stop_list_file = open('stop_list.txt', 'r')
stop_list = stop_list_file.read().split()
stop_list_file.close()

# load nltk stop list
stop = stopwords.words('english')
stop_spanish = stopwords.words('spanish')

# stemmer
stemmer = SnowballStemmer('english')

# for writing
newfile = open(new_tweet_filename, 'wb')
wr = csv.writer(newfile, quoting=csv.QUOTE_ALL)

# for reading
with open(tweet_filename, 'rU') as csvfile:
    tweetreader = csv.reader(csvfile, delimiter='\n', quotechar='"')

    # remove html, @s from tweets, punctuation, and stopwords
    # and stems the words, and saves them to new csv file
    for row in tweetreader:
        row[0] = re.sub(
            r'''(?i)\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))''',
            '',
            row[0],
            flags=re.MULTILINE)
        row[0] = re.sub(r'@\w*', '', row[0])
        row[0] = re.sub('[%s]' % re.escape(string.punctuation), ' ', row[0])
        row[0] = re.sub(r'\W', ' ', row[0])
        row[0] = row[0].lower()
        row[0] = row[0].strip()

        # stemming
        a = [stemmer.stem(i) for i in row[0].split()]
        # apply stop list
        a = [
            i for i in a
            if i.lower()
            not in stop and i.lower()
            not in stop_spanish and i.lower() not in stop_list]
        row[0] = ' '.join(a)
        wr.writerow(row)

# create term-document matrix
tdm = textmining.TermDocumentMatrix()

with open(new_tweet_filename, 'rU') as csvfile:
    tweetreader = csv.reader(csvfile, delimiter='\n', quotechar='"')
    for row in tweetreader:
        tdm.add_doc(str(row[0]))

it = 1
for rows in tdm.rows(cutoff=2):
    # print rows, len(rows)
    if it == 1:
        dic_csv = open('tweet2_dict.csv', 'wb')
        wr = csv.writer(dic_csv, quoting=csv.QUOTE_ALL)
        wr.writerow(rows)
    elif it == 2:
        A = scipy.sparse.csr_matrix(rows)
    else:
        rows = np.array(rows)
        B = scipy.sparse.csr_matrix(rows)
        A = scipy.sparse.vstack([A, B])
    if it < 3:
        it += 1

io.savemat('stuff.mat', dict(A=A))
