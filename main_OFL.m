
%ICML2021: Multiple Kernel-Based Online Federated Leaerning 

clear all; close all;
clc

rng(31) %random seed value



%ONLINE REGRESSIONS DATASETS

%TwitterData, TwitterDataL, TomData, AirData, EnergyData, Wave, Weather
load Conductivity


%TIME-SERIES DATASETS
%load AQI_large_p5 %Traffic,Temperature

%%Time-series data generation 
%l=5; 
%J=length(y);
%M=J-l;

%for i=1:M
%    for k=1:l
%        X(k,i) = y(i+(k-1));
%    end
%    z(i) = y(i+l);
%end

%y=z;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TRIAL=20; %Number of trials
Nuser =20; %Number of nodes in the network
T=length(y); N=size(X,1);

%Kernel Dictionary
for i=1:11
    kernel_temp(i) = 10^(i-6);
end

params=struct;
params.N=N; params.ker_list={'rbf'}; 
params.lambda=0.01;   
params.sigma=kernel_temp; 
params.L=50; params.eta_l = 1/sqrt(T); 

n_ker=length(kernel_temp);
D=cell(n_ker,1);
L=params.L;
T=floor(T/Nuser);


for s=1:TRIAL
    
    %random feature map
    
    [D] = random_feature_map(params);

    %initialization (theta/local loss)

    for u=1:Nuser
        kernel_loss_int(:,u) = ones(length(params.sigma),1)/length(params.sigma);
        theta_int(:,:,u)=zeros(2*params.L, length(kernel_temp));
    end


    frequent_index = randi(n_ker); %initial kernel index

    for t=1:T %time index
    
  
        params.eta_g = (log(n_ker))/sqrt(t);
        temp_theta = zeros(size(theta_int)); 
    
        for u=1:Nuser
 
            [theta(:,:,u), error_sel(u,t), kernel_loss(:,u), select_index(u)]=ofl_function(y((t-1)*Nuser+u),X(:,(t-1)*Nuser+u),params,theta_int(:,:,u),kernel_loss_int(:,u),D,frequent_index);
        
            if t==1
                error_sel(u,t)=1; %nitial MSE values
            end
        
            ofl_sel(u,t)=mean(error_sel(u,[1:t]));
            kernel_loss_int(:,u) = kernel_loss(:,u); %local accumulated loss at each node
            theta_int(:,:,u) = theta(:,:,u); %local theta update
                
        end
    
        %Kernel selection at the central node
        frequent_index = random_kernel_selection(select_index, Nuser, n_ker);
    
        %Find the nodes that sent the "frequent_index":
    
        index_chosen = find(select_index==frequent_index);
        selected_theta = theta(:,:,index_chosen);
        nn = length(index_chosen);
        for kk=1:nn
            temp_theta = temp_theta + (1/nn)*selected_theta(:,:,kk);
        end
    
        %Global model-update from the aggreaged theta's and the
        %"frequent_index"
    
        for u=1:Nuser
            theta_int(:,frequent_index,u) = temp_theta(:,frequent_index,u); %global theta update (only one kernel)
        end
    
    end %end of t

    ofl_sel_mse = zeros(size(ofl_sel(1,:)));

   
    for u=1:Nuser
         ofl_sel_mse = ofl_sel_mse + ofl_sel(u,:);
    end 

    ofl_sel_mse=ofl_sel_mse/Nuser;
    mse_error(s,:) = ofl_sel_mse;

end %end of s


average_mse = mean(mse_error);
semilogy([1:T], average_mse,'r')
hold on
