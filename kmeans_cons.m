% Runs k-means multiple times on a data matrix to construct a
% consensus clustering matrix. It will start with a user-specified minimum
% number of clusters for k-means, and will increment k by one until
% the user-specified maximum number of clusters is reached.
% Returns a consensus/similarity matrix.
%
% INPUT:
% matrix: data matrix under consideration. Features should be
% columns, and data should be rows.
% min_num: minimum number of clusters you want (for the first run)
% max_num: maximum number of clusters you want (for the last run)
%
% OUTPUT:
% cons_mat, consensus/similarity matrix
% allIDX, matrix where the rows are all the data points, and the column is
% the cluster that the data point corresponded to in that run of k-means

function [cons_mat, allIDX] = kmeans_cons(matrix, min_num, max_num)

num_sim = max_num - min_num + 1;
allIDX = zeros(size(matrix,2),num_sim);
% Run multiple instances of k-means with k = [numClusterMin: numClusterMax]
for h = 1:num_sim
    fprintf('Step %d\n', h+min_num-1)
    IDXi = kmeans(matrix', h+min_num-1, 'EmptyAction', 'singleton', 'distance', 'cosine');
    allIDX(:,h) = IDXi;
end

cons_mat = zeros(length(matrix));

% Construct the consensus matrix
for i = 1:num_sim
    % The largest cluster index is the number of clusters
    max_j = max(allIDX(:,i));
    for j = 1:max_j
        % Find data points that are clustered together
        [p,q] = meshgrid(find(allIDX(:,i) == j), find(allIDX(:,i) == j));
        pairs = [p(:), q(:)]';
        % Create consensus matrix, adding 1 to the i,j entry if data
        % points i and j are clustered together.
        for k=1:2:length(pairs)*2
            cons_mat(pairs(k), pairs(k+1)) = cons_mat(pairs(k), pairs(k+1)) + 1;
        end
    end
end


end
