function [result_all] = main_CONMF(Xl,Xu,Yl,Yu,options)
% If you use this code, please kindly cite our paper:
% Naiyao Liang, Zuyuan Yang, Zhenni Li, Shengli Xie, "Co-consensus semi-supervised multi-view learning with orthogonal non-negative matrix factorization", Information Processing and Management 59 (2022) 103054.
%% Set variables
sigma = options.sigma;
mu = options.mu;
iters = options.iters;
%% Data normalization 
P=length(Xl); X=cell(1,P); nl = length(Yl); nu = length(Yu);
for p=1:P
    X{p}=[Xl{p},Xu{p}];
    m{p} = size(X{p},1);
    X{p} = X{p}./sum(X{p});
    Xl{p} = X{p}(:,1:nl);
    Xu{p} = X{p}(:,nl+1:end);
end    
%% Construct graph
manifold.k = options.k;
manifold.Metric = 'Cosine';
manifold.NeighborMode = 'KNN';
manifold.WeightMode = 'Cosine';
manifold.bNormalizeGraph = 0;

Sp=cell(1,P); Sp_sum=0;
for p=1:P
    Sp{p} = laplacian(X{p}',manifold); 
    Sp_sum=Sp_sum+Sp{p};
end
Dp_sum = diag((sum(Sp_sum)));
%% Initialization   
Y = [Yl;Yu];     
c = length(unique(Y));
YY = [];
for i = reshape(unique(Y),1,c)
    YY = [YY,Y==i];
end
YYl = YY(1:nl,:);

U=cell(1,P);   
for p=1:P
    U{p} = rand(m{p},c);
end
Vl = YYl;
Vl = Vl*diag((1./sqrt(2*sum(Vl.^2))));
Vu = rand(nu,c);
V = [Vl;Vu];
w=ones(1,P)./P;  % view weight 
%% run
for it = 0:iters  
    if it>0
        tem1=0; tem2=0; 
        for p=1:P
            U{p} = U{p}.*((Xl{p}*Vl+Xu{p}*Vu)./(U{p}*(Vl'*Vl)+U{p}*(Vu'*Vu)+eps));  % update the assemble centroid U
            tem1=tem1+w(p)*Xu{p}'*U{p}; tem2=tem2+w(p)*U{p}'*U{p}; 
        end
        Vu3=Vu.*Vu.*Vu;
        Vu = Vu.*((tem1+sigma*Sp_sum(nl+1:end,:)*V+mu*Vu+2*mu*Vu3)./(Vu*tem2+sigma*Dp_sum(nl+1:end,:)*V+2*mu*Vu*(Vu'*Vu)+2*mu*Vu3+eps)); % update the consensus class indicator matrix of unlabeled data Vu
        V = [Vl;Vu];
        for p=1:P
            tem=X{p}-U{p}*V';
            w(p)=1/(2*sqrt(sum(sum(tem.*tem))));  % update view weight w
            clear tem;
        end    
    end
     
    if mod(it,50)==0
        fprintf('[%d]',it);
        [ac1, nmi1, Pri1,AR1]=printResult(V(nl+1:end,:),options.label(nl+1:end)',c,0); 
    end
end
result_all=[ac1, nmi1, Pri1,AR1]*100;   
end