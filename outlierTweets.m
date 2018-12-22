% Performs noise removal on the datausing three different methods. First, we
% implement a drop tolerance; if the consensus matrix has an entry
% less than a specified amount, we drop that entry to zero. Then we 
% use DBSCAN and remove outlier tweets. 
% 
% INPUT:
% data: data matrix under consideration. Features should be 
% columns, and data should be rows.
% consM: consensus matrix
% distM: A siamilarity matrix based on a distance metric
%
% OUTPUT:
% allType, consensus/similarity matrix 
% dataI, matrix where the rows are all the data points, and the column is 
% index1 cluster that the data point corresponded to in that run of k-means


function [allType,dataI,index1] = outlierTweets(data,consM,distM)
[~,n] = size(data);

%% Perform noise removal using three methods
[type1,~] = outliers(n,consM);
fprintf('Done with ConsM noise removal\n');
[type2,~,c,runs] = play(n,distM);
fprintf('Done with DBSCAN noise removal\n');
type3 = playConsM(n,consM,c,runs);
fprintf('Done with DBSCAN on the ConsM noise removal\n');

allType = [type1 type2 type3];
rowsum = sum(allType,2);
type4 = ones([n 1]);
for k = 1:n
    if rowsum(k) <= 1
        type4(k) = 0;
    end
end

index = linspace(1,n,n)';
allType = [index allType type4];

ptrm = zeros([4 1]);
for k = 1:4
    ind = find(allType(:,k+1) == 0);
    ptrm(k,:) = length(ind);
    ind = [];
end
fprintf('Number of points removed by ConsM is: %d\n', ptrm(1,:));
fprintf('Number of points removed by DBSCAN is: %d\n', ptrm(2,:));
fprintf('Number of points removed by DBSCAN on ConsM is: %d\n', ptrm(3,:));
fprintf('Number of points removed by Intersect is: %d\n', ptrm(4,:));

%% SVD
if n > 3
    [~,S,V] = svds(data);
    coord = S*V';
    coord = coord';
end

%% Original Data plotted
if n == 2
    figure('Name','Original Data');
    plot(data(:,1),data(:,2),'*'); axis([min(data(:,1))-1 max(data(:,1))+1 min(data(:,2))-1 max(data(:,2))+1]);
elseif n == 3
    figure('Name','Original Data');
    plot3(data(:,1),data(:,2),data(:,3),'*');xlim([min(data(:,1))-1 max(data(:,1))+1]);
    ylim([min(data(:,2))-1 max(data(:,2))+1]); zlim([min(data(:,3))-1 max(data(:,3))+1]);
else
    figure('Name','Original Data');
    plot3(coord(:,1),coord(:,2),coord(:,3),'*'); xlim([min(coord(:,1))-1 max(coord(:,1))+1]);
    ylim([min(coord(:,2))-1 max(coord(:,2))+1]);zlim([min(coord(:,3))-1 max(coord(:,3))+1]);
    xlabel('1^{st} Dimension','FontSize',12);ylabel('2^{nd} Dimension','FontSize',12); zlabel('3^{rd} Dimension','FontSize',12);
end
%% New data plotted
for k = 1:4
    dataI = data;
    index1 = index;
    tokeep = allType(:,k+1)==1;
    dataI(:,tokeep) = [];
    index1 = index1(tokeep,:);
    if k == 1
        figure('Name','Data with outliers removed with ConsM');
    elseif k == 2
        figure('Name','Data with outliers removed with DBSCAN');
    elseif k == 3
        figure('Name','Data with outliers removed with DBSCAN on ConsM');
    else
        figure('Name','Data with outliers removed with Intersect');
    end
    
    if n == 2
        plot(dataI(:,1),dataI(:,2),'*');axis([min(data(:,1))-1 max(data(:,1))+1 min(data(:,2))-1 max(data(:,2))+1]);
    elseif n == 3
        plot3(dataI(:,1),dataI(:,2),dataI(:,3),'*');xlim([min(data(:,1))-1 max(data(:,1))+1]);
        ylim([min(data(:,2))-1 max(data(:,2))+1]); zlim([min(data(:,3))-1 max(data(:,3))+1]);
    else
        plot3(coord(index1,1),coord(index1,2),coord(index1,3),'*');xlim([min(coord(:,1))-1 max(coord(:,1))+1]);
        ylim([min(coord(:,2))-1 max(coord(:,2))+1]);zlim([min(coord(:,3))-1 max(coord(:,3))+1]);
        xlabel('1^{st} Dimension','FontSize',12);ylabel('2^{nd} Dimension','FontSize',12); zlabel('3^{rd} Dimension','FontSize',12);
    end
end

end %function

%% On the Consensus Matrix - Drop Tolereance
function [type,consM] = outliers(n,consM)
%[~,n] = size(data);

dropTemp = 10;%input('How much of the consensus clustering would you like to drop?\nExample: 25 = 25%\n');

dropT = floor(max(consM(:,1)).*(dropTemp./100));

consM2 = consM;
for k  = 1:length(consM)
    for j = 1:length(consM)
        if consM(k,j) < dropT
            consM2(k,j) = 0;
        end
    end
end

rowsum = [];
for k = 1:length(consM2)
    rowsum(k,:) = sum(consM2(k,:));
end

ave = mean(consM2);
ave2 = mean(ave);

index = linspace(1,n,n)';
dataI = [index ones([n 1])];

for k  = 1:length(consM2)
    if ave(k) < ave2
        dataI(k,2) = 0;
    end
end

type = dataI(:,2);

end


%% Multiple runs of dbscan
function [type,distM,c,runs] = play(n,distM)
%[~,n] = size(data);

c = 300; %input('What is the min. number of points in a dense cluster?\n');

runs = 10; %input('How many runs of DBSCAN would you like to do?\n');

allType = [];

Eps=0.95;
for k = 1:runs
    type=dbscan2(distM,c,Eps);
    allType(:,k) = type;
    Eps = Eps + 0.1;
end

index = linspace(1,n,n)';
dataI = [index ones([n 1])];

rowsum2 = sum(allType,2);
cut = .99*runs;
for k  = 1:length(rowsum2)
    if rowsum2(k) < cut || rowsum2(k) == cut
        dataI(k,2) = 0;
    end
end

type = dataI(:,2);
end

%% dbscan2
function type = dbscan2(distM,c,Eps)
D = le(distM,Eps);
rowsum = sum(D,2);
type = zeros([length(rowsum) 1]);

for k = 1:length(rowsum)
    if rowsum(k) == 1
        type(k) = -1;
    elseif rowsum(k) < c
        type(k) = 0;
    else
        type(k) = 1;
    end
end

end %Function

%% dbscan on the consmat
function type = playConsM(n,consM,c,runs)

Eps = floor(max(consM(:,1))*.75);

allType = [];

for k = 1:runs
    type = dbscanConsM(consM,c,Eps);
    allType(:,k) = type;
end

index = linspace(1,n,n)';
dataI = [index ones([n 1])];

rowsum = sum(allType,2);
cut = runs*0.5;
for k  = 1:length(rowsum);
    if rowsum(k) <= cut;
        dataI(k,2) = 0;
    end
end

type = dataI(:,2);
end

%% DCSCAN consmat
function type = dbscanConsM(consM,c,Eps)
D = ge(consM,Eps);
rowsum = sum(D,2);
type = zeros([length(rowsum) 1]);

for k = 1:length(rowsum)
    if rowsum(k) == 1
        type(k) = -1;
    elseif rowsum(k) < c
        type(k) = 0;
    else
        type(k) = 1;
    end
end

end %Function
