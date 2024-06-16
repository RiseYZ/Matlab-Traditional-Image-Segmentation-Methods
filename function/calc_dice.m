function res = calc_dice(image1, image2)  

      
    [N,M] = size (image1);
    
    pp = 0;
    qq = 0;
    for i = 1:N
        for j = 1:M
            
            qq = qq+1;
            if (image1(i,j) == image2(i,j))
                pp = pp+1;
            end
        end
    end

    res = 1-pp / qq;
end