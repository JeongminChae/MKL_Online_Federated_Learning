
function [theta , er_sel, kernel_loss, chosen_index]=ofl_function(y,x,params, theta, kernel_loss, D, frequent_index)

    %PARAMETERS 
     ker_list=params.ker_list;  eta_g=params.eta_g;sigma=params.sigma; 
     lambda=params.lambda; eta_l=params.eta_l; n_ker=length(sigma);

   for i=1:n_ker
             
        theta0=theta(:,i);
        kx0=[sin(D{i}*x); cos(D{i}*x)];
        fx(i)=kx0'*theta0; 
        er_temp(i,1)=(y-fx(i))^2; 
        grad=-2*(y-fx(i))*kx0; 
        theta_temp= theta0 - (eta_l)*grad - 2*lambda*(eta_l)*theta0; %OGD
        theta0=theta_temp;
        theta(:,i)=theta0;
   end
    
    %PROBABILITY DISTRIBUTION (WEIGHTS)

    prob = kernel_loss/sum(kernel_loss);
    
    %CHOOSE ONE INDEX ACCORDING TO THE ABOVE PROBABILITY
    temp_a = rand;
    for tt=1:n_ker
        if sum(prob(1:tt)) > temp_a
            chosen_index = tt;
            break;
        end  
    end
    
   
   f_hat_select = fx(frequent_index); 
         
   kernel_loss = kernel_loss.*exp(-eta_g*er_temp);
     
   if max(kernel_loss)>1e12
       kernel_loss=kernel_loss/sum(kernel_loss);
   end
    
   %MSE COMPUTATION
   er_sel= (y-f_hat_select)^2;


    
end