function [new_vocab, new_freq] = remove_repeated_words(stop_list, ranked_vocabulary, ranked_frequency)
    
    new_vocab = [size(ranked_vocabulary)];
    new_freq = [size(ranked_frequency)];
    
    for vocab_word=1:length(ranked_vocabulary)
        
        if not(ismember(ranked_vocabulary(vocab_word), stop_list))
            
            new_vocab = [new_vocab, ranked_vocabulary(vocab_word)];
            new_freq = [new_freq, ranked_frequency(vocab_word)];
        
        end;
    end;
end
