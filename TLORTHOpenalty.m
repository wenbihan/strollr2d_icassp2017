function [D, X]= TLORTHOpenalty(D,Y,numiter,tau)
n = size(Y, 1);
for i=1:numiter
    % sparse coding, l0 penalty method
    X = D * Y;
    [~, maxInd] = max(abs(X));
    maxVal = X(maxInd);
    X(abs(X) < tau) = 0;
    X(maxInd) = maxVal;
    % transform update, closed-form 
    [U, ~, V] = svd(Y * X');
    D = (V(:,1:n))*U';    
end