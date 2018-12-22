% Read in bible from XML file, and clean it up
collection = evalc('type bible_en.xml');
collection = regexprep(collection, '<.*?>', '');
collection = lower(collection);
collection = regexprep(collection, '\W', ' ');
collection = strtrim(regexprep(collection,'\s*', ' '));
temp = regexprep(collection, ' ',''',''');
eval(['words = {''',temp,'''};']);

[vocabulary,~,index] = unique(words);
vocabulary_words = length(vocabulary);
frequencies = hist(index,vocabulary_words);
[ranked_frequencies,ranking_index] = sort(frequencies,'descend');
ranked_vocabulary = vocabulary(ranking_index);


temp = evalc('type bible_en.xml');
temp = lower(temp);
temp = regexprep(temp, '</chapter>', ' S ');
temp = regexprep(temp, '<.*?>', '');
temp = regexprep(temp, '\W', ' ');
temp = strtrim(regexprep(temp,'\s*', ' '));
temp = regexprep(temp, ' ',''',''');

eval(['wordsofchapters = {''',temp,'''};']);
limits = [0,find(strcmp(wordsofchapters,'S'))];

field1 = 'vocab';
value1 = cell(length(vocabulary),1);
chapters = struct(field1, value1);

for k=1:length(limits)-1
    [chapters(k).vocab, ~, chapters(k).count]= unique(wordsofchapters(limits(k)+1:limits(k+1)-1));
end;


tdmtx = sparse(length(ranked_vocabulary), length(chapters));
for k=1:length(chapters)
    [~,termindex] = intersect(ranked_vocabulary,chapters(k).vocab);
    [a b c] = unique(chapters(k).vocab);
    tdmtx(termindex,k) = hist(c, length(a));
end;
