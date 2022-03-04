function [H,Alpha] = network_structure(Nuser)
%UNTITLED Summary of this function goes here
%   Detailed 

%H = rand(Nuser,Nuser) < o;
%H = triu(H,1);
%H = H + H'; 

H=rand(Nuser,Nuser);

H=ones(Nuser,Nuser);

% Neighbors
%Nei=cell(Nuser,1);
%for i=1:Nuser
%    Nei{i}=find(H(i,:));
%end

Alpha=zeros(Nuser,Nuser);


end


%for i=1:Nuser
%    nei=Nei{i};
%    sum_Alpha=0;
%    for n=1:length(nei)
%        nei_n=Nei{nei(n)};
%        Alpha(i,nei(n))=1/(1+max(length(nei),length(nei_n)));
%        sum_Alpha= sum_Alpha+Alpha(i,nei(n));
%        Alpha(nei(n),i)=1/(1+max(length(nei),length(nei_n)));
%    end
%    Alpha(i,i)=1-sum_Alpha;
%end

