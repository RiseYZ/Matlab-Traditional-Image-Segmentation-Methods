function segmented_mask = improvedGMM2(img, cluster_num)
    % 将RGB图像转换为灰度图像
    img_gray = double(img);
    
    % 将图像矩阵转换为向量
    img_vector = img_gray(:);
    
    % 使用K-means算法进行初始化
    [label, centers] = kmeans(img_vector, cluster_num, 'Distance', 'sqeuclidean', 'Start', 'plus');
    
    % 使用fitgmdist拟合高斯混合模型，以K-means的结果作为初始值
    S = struct('mu', centers, 'Sigma', repmat(eye(1), [1, 1, cluster_num]), 'ComponentProportion', ones(1, cluster_num) * (1/cluster_num));
    gmm_model = fitgmdist(img_vector, cluster_num, 'Start', S, 'RegularizationValue', 0.01);
    
    % 计算每个像素属于每个高斯成分的后验概率
    posterior_probs = posterior(gmm_model, img_vector);
    
    % 选择后验概率最大的成分作为每个像素的类别
    [~, label] = max(posterior_probs, [], 2);
    
    % 将标签重塑回图像尺寸
    label = reshape(label, size(img_gray));
    
    % 将标签映射到0-255范围
    segmented_mask = uint8(255 * (label - 1) / (cluster_num - 1));
end
