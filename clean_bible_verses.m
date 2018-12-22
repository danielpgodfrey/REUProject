% stops and stems verses so that i can use them!
function verses = clean_bible_verses(verses, stop_list)  
    
    [IWBible,IWFreq] = removeStpsVocabFreq(stop_list,ranked_vocabularyB,ranked_frequenciesB);
    
    %% stemming
    for i=1:length(verses)
       verses(i).vocab = stemmer(verses(i).vocab); 
    end
    
    %% stop list
    for i=1:length(verses)
        [verses(i).vocab, verses(i).count] = removeStpsVersesAndCount(stop_list, verses(i).vocab, verses(i).count);
    end
    
    %% term weighting
   [tfidf_matrix, tfidf] = tfidf2(term_doc_matrix);
   [u_idf, s_idf, v_idf] = svds(tfidf_matrix, 100);
   coords_tfidf = s_idf*v_idf';
   [IDX_tfidf, C_tfidf] = kmeans(coords_tfidf', 150);
   
end
