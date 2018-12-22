% Writes verses corresponding to different clusters into a text file.
% Also, writes the corresponding verse to a separate text file.
% 
% If you have a lot of clusters, use a folder

%INPUT:
% IDX:    row vector. each ith element in the vector should correspond
%         to the number of cluster that element i is in
% verses: should be a struct with a vocab and count member/method/whatever
%
%OUTPUT:
% Writes 2 text files for every cluster you have. 

function cluster_meaning_bible(IDX, verses)
    % number of clusters is highest number in IDX vector:
    num_of_clusters = max(IDX(:));
    % add space between words
    formatspec = '%s ';
    
    %% Change file name here! Will rewrite whatever is in the folder:
    vocab_folder_name = 'cluster_vocab20clusters';
    verse_folder_name = 'cluster_verses20clusters';
    mkdir(vocab_folder_name);
    mkdir(verse_folder_name);
    
    % go through every cluster in the data and write a different file for
    % each one.
    for i=1:num_of_clusters
        
        vocab_file_name = sprintf('/cluster%d_vocab.txt', i);
        verse_file_name = sprintf('/cluster%d_verses.txt', i);
        vocab_dir = strcat(vocab_folder_name, vocab_file_name);
        verse_dir = strcat(verse_folder_name, verse_file_name);
        cluster_vocab_id = fopen(vocab_dir, 'w');
        cluster_verses_id = fopen(verse_dir, 'w');
        
        %% go through all of the data points
        for j=1:length(IDX)
            
            % if the data point is in the ith cluster, write it to the file
            if IDX(j) == i
                % option: if you don't want multiple words appearing in a 
                % verse to count multiple times, change this
                % to a single for loop (get rid of for l=...)
                for k=1:length(verses(j).vocab)
                    for l=1:verses(j).count(k)
                        fprintf(cluster_vocab_id, formatspec, verses(j).vocab{k});
                    end
                end
                % print the corresponding verse to a separate file
                fprintf(cluster_verses_id, formatspec, verses(j).text);
                % make new lines. each line corresponds to a verse.
                fprintf(cluster_vocab_id, '%s\n', '');
                fprintf(cluster_verses_id, '%s\n', '');
            end
                
            
         end
      end
        % close the file
        fclose(cluster_vocab_id);
        fclose(cluster_verses_id);
end
