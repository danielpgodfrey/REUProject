% Writes tweets corresponding to different clusters into a text file.
% Also, writes the corresponding tweet to a separate text file.
% 
% If you have a lot of clusters, use a folder

%INPUT:
% IDX:    row vector. each ith element in the vector should correspond
%         to the number of cluster that element i is in
% tweets: should be a struct with a vocab and count member/method
%
%OUTPUT:
% Writes 2 text files for every cluster you have. 

function cluster_meaning_tweets(IDX, tweets)
    % number of clusters is highest number in IDX vector:
    num_of_clusters = max(IDX(:));
    % add space between words
    formatspec = '%s ';
    
    %% Change file name here! Will rewrite whatever is in the folder:
    vocab_folder_name = sprintf('%dcluster_vocab', num_of_clusters);
    tweet_folder_name = sprintf('%dcluster_tweets', num_of_clusters);
    mkdir(vocab_folder_name);
    mkdir(tweet_folder_name);
    
    % go through every cluster in the data and write a different file for
    % each one.
    for i=1:num_of_clusters
        
        vocab_file_name = sprintf('/cluster%d_vocab.txt', i);
        tweet_file_name = sprintf('/cluster%d_tweets.txt', i);
        vocab_dir = strcat(vocab_folder_name, vocab_file_name);
        tweet_dir = strcat(tweet_folder_name, tweet_file_name);
        cluster_vocab_id = fopen(vocab_dir, 'w');
        cluster_tweets_id = fopen(tweet_dir, 'w');
        
        %% go through all of the data points
        for j=1:length(IDX)
            
            % if the data point is in the ith cluster, write it to the file
            if IDX(j) == i
                % option: if you don't want multiple words appearing in a 
                % tweet to count multiple times, change this
                % to a single for loop (get rid of for l=...)
                fprintf(cluster_vocab_id, formatspec, tweets{j});
                % print the corresponding tweet to a separate file
                %fprintf(cluster_tweets_id, formatspec, tweets.newfull{j});
                % make new lines. each line corresponds to a tweet.
                fprintf(cluster_vocab_id, '%s\n', '');
                fprintf(cluster_tweets_id, '%s\n', '');
            end
                
            
         end
      end
        % close the file
        fclose(cluster_vocab_id);
        fclose(cluster_tweets_id);
end
