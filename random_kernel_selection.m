function [frequent_index] = random_kernel_selection(select_index, Nuser, n_ker)

    for tt=1:n_ker
        prob_c(tt) = power(sum(select_index == tt),Nuser);
    end
        
        prob_c =prob_c/sum(prob_c);
        temp_a = rand;
    
        for tt=1:n_ker
            if sum(prob_c(1:tt)) > temp_a
                frequent_index = tt;
            break;
        end  
    end
        
end

