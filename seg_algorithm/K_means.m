function J = K_means(I)  

    [L,Centers] = imsegkmeans(I, 2);
    [~, maxIdx] = max(Centers(:)); 
    J = 255 * ones(size(I), 'uint8'); 
    J(L == maxIdx) = 0;  
   
end