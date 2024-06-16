function segmented_mask = MRF(img, cluster_num, maxiter)
    img_gray = double(img);
    
    % 随机初始化标签
    label = randi([1, cluster_num], size(img_gray));
    
    iter = 0;
    while iter < maxiter
        % 计算先验概率
        label_u = imfilter(label, [0, 1, 0; 0, 0, 0; 0, 0, 0], 'replicate');
        label_d = imfilter(label, [0, 0, 0; 0, 0, 0; 0, 1, 0], 'replicate');
        label_l = imfilter(label, [0, 0, 0; 1, 0, 0; 0, 0, 0], 'replicate');
        label_r = imfilter(label, [0, 0, 0; 0, 0, 1; 0, 0, 0], 'replicate');
        label_ul = imfilter(label, [1, 0, 0; 0, 0, 0; 0, 0, 0], 'replicate');
        label_ur = imfilter(label, [0, 0, 1; 0, 0, 0; 0, 0, 0], 'replicate');
        label_dl = imfilter(label, [0, 0, 0; 0, 0, 0; 1, 0, 0], 'replicate');
        label_dr = imfilter(label, [0, 0, 0; 0, 0, 0; 0, 0, 1], 'replicate');
        
        p_c = zeros(cluster_num, numel(label));
        % 计算像素点8邻域标签相对于每一类的相同个数
        for i = 1:cluster_num
            label_i = i * ones(size(label));
            temp = ~(label_i - label_u) + ~(label_i - label_d) + ...
                   ~(label_i - label_l) + ~(label_i - label_r) + ...
                   ~(label_i - label_ul) + ~(label_i - label_ur) + ...
                   ~(label_i - label_dl) + ~(label_i - label_dr);
            p_c(i, :) = temp(:) / 8; % 计算概率
        end
        p_c(p_c == 0) = 0.001; % 防止出现0
        
        % 计算似然函数
        mu = zeros(1, cluster_num);
        sigma = zeros(1, cluster_num);
        % 求出每一类的高斯参数 -- 均值和方差
        for i = 1:cluster_num
            index = find(label == i); % 找到每一类的点
            data_c = img_gray(index);
            mu(i) = mean(data_c); % 均值
            sigma(i) = var(data_c); % 方差
        end
        
        p_sc = zeros(cluster_num, numel(label));
        % 计算每个像素点属于每一类的似然概率
        for j = 1:cluster_num
            MU = repmat(mu(j), numel(img_gray), 1);
            p_sc(j, :) = 1 / sqrt(2 * pi * sigma(j)) * ...
                         exp(-(img_gray(:) - MU).^2 / (2 * sigma(j)));
        end 
        
        % 找到联合概率最大的标签，取对数防止值太小
        [~, label] = max(log(p_c) + log(p_sc));
        label = reshape(label, size(img_gray));
        
        iter = iter + 1;
    end
    
    % 将标签映射到0-255范围
    segmented_mask = uint8(255 * (label - 1) / (cluster_num - 1));
end
