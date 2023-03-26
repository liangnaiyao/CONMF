% This code is for the paper:
% Naiyao Liang, Zuyuan Yang, Zhenni Li, Shengli Xie, "Co-consensus semi-supervised multi-view learning with orthogonal non-negative matrix factorization", Information Processing and Management 59 (2022) 103054.
% If you use this code, please kindly cite our paper.
% This is where you can start.
clear all; clc
addpath('./tools');
%% parameters setting
options.k = 5;             
options.sigma = 0.1; % control the contribution of the consensus graph     
options.mu = 5; % control the degree of orthogonality or the contribution of the consensus relation between data and assemble centroid
options.iters = 200;   
%% data loading and processing
load MSRCv1_example_50label  % the label rate is 50%
options.label=label;
result = main_CONMF(X_src,X_tar,Y_src',Y_tar',options);
%% print result
fprintf('\n result:\n ac: %0.2f\tnmi:%0.2f\tpur:%0.2f\tar:%0.2f\n', result(1), result(2), result(3), result(4));