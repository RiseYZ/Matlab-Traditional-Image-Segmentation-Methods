function segmented_mask = improvedGMM1(img, cluster_num)
    % 将RGB图像转换为灰度图像
    img_gray = double(img);
    
    % 将图像矩阵转换为向量
    img_vector = img_gray(:);
    
    % 使用fitgmdist拟合高斯混合模型
    gmm_model = fitgmdist(img_vector, cluster_num, 'RegularizationValue', 0.01);
    
    % 计算每个像素属于每个高斯成分的后验概率
    posterior_probs = posterior(gmm_model, img_vector);
    
    % 选择后验概率最大的成分作为每个像素的类别
    [~, label] = max(posterior_probs, [], 2);
    
    % 将标签重塑回图像尺寸
    label = reshape(label, size(img_gray));
    
    % 修正目标区域
    adjust_label = adjustGMMLabels(label);
    
    % 将标签映射到0-255范围
    segmented_mask = uint8(255 * (adjust_label - 1) / (cluster_num - 1));
end
