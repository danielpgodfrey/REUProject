clear all;
# Replace with mat file saved from Python
load('stuff.mat');

A = A./realmin('double');
A = A./eps('double');
idx = all(A==0,2);

A(idx,:) = [];
fullA = full(A);
tfidf = tfidf2(fullA);

fprintf('freq');
freq = full(sum(A));
A = A';
B = A(freq~=1,:);
A = A';

fprintf('vocab');
vocab = evalc('type tweet2_dict.csv');
vocab = strsplit(vocab, ',');
vocab = strrep(vocab, '"', '');

fprintf('tweet_words');
tweet_words = evalc('type tweets2.csv');
tweet_words = strsplit(tweet_words, '\n');
tweet_words = strrep(tweet_words, '"', '');
tweet_words(1) = [];
tweet_words(end) = [];
tweet_words(idx) = [];

fprintf('tweet_words');
tweeters = evalc('type tweets2.csv');
tweeters = strsplit(tweeters, '\n');
tweeters(1) = [];
tweeters(end) = [];
tweeters(idx) = [];

tweets.tdm = A';
tweets.tfidf = sparse(tfidf');
tweets.vocab = vocab;
tweets.freq = freq;
[tweets.ranked_freq, idx] = sort(tweets.freq, 'descend');
tweets.ranked_vocab = tweets.vocab(idx);
tweets.tweet_vocab = tweet_words;
tweets.full_tweets = tweeters;

save('tweets.mat', 'tweets');
