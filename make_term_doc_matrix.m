function term_doc_matrix = make_term_doc_matrix(IWBible, verses)

term_doc_matrix = sparse(length(IWBible), length(verses));

for k=1:length(verses)
    [~,index] = intersect(IWBible, verses(k).vocab);
    for i=1:length(index)
        term_doc_matrix(index(i),k) = verses(k).count(i);
    end
end
