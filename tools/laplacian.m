function [W,D] = laplacian(X,manifold)

W = affinity(X,manifold);

if manifold.bNormalizeGraph  
    D = 1./sqrt(sum(W));
    D(isinf(D)) = 0;
    D = diag(sparse(D));
    W = D*W*D;
    D(D>0) = 1;
else
    D = diag(sparse(sum(W)));
end

end
