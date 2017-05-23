function [] = PR() 
% PageRank Based community Detection

graphPath = '../example/amazon/graph';
communityPath = '../example/amazon/community';

% load graph
graph = loadGraph(graphPath);

% load truth communities
comm = loadCommunities(communityPath);

% choose a community from truth communities randomly
commId = randi(length(comm));

% choose 3 nodes from selected community randomly
seedId = randperm(length(comm{commId}),3);
seed = comm{commId}(seedId);

% detect community by PageRank diffusion
[set,conductance,cut,volume] = pprgrow(graph,seed);

% compute F1 score
jointSet = intersect(set,comm{commId});
jointLen = length(jointSet);
F1 = 2*jointLen/(length(set)+length(comm{commId}));

% printing out result
fprintf('The detected community is')
disp(set')
fprintf('The F1 score between detected community and ground truth community is %.3f\n',F1)

% save out result
savePathandName = '../example/amazon/output_PR.txt';
dlmwrite(savePathandName,'The detected community is','delimiter','');
dlmwrite(savePathandName,set','-append','delimiter','\t','precision','%.0f');
dlmwrite(savePathandName,'The F1 score between detected community and ground truth community is','-append','delimiter','');
dlmwrite(savePathandName,F1,'-append','delimiter','\t','precision','%.3f');
