function [D] = random_feature_map(params)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L=params.L; N=params.N;
kernel_temp = params.sigma;
n_ker = length(kernel_temp);

for i=1:n_ker
 D{i}=kernel_temp(i)*randn(L,N);
end

C=ceil(L/N)-1;
resd=L-C*N;
for i=1:n_ker
    for c=1:C+1
        G=randn(N,N);
        [Q,R]=qr(G);
        if c<C+1
            D_temp(c*N-N+1:c*N,:)=kernel_temp(i)*Q;
        else
            D_temp(c*N-N+1:c*N-N+resd,:)=kernel_temp(i)*Q(1:resd,:);     
        end
    end
    v1=chi2rnd(ones(L,1));
    D{i}=diag(sqrt(v1))*D_temp;
end



end

