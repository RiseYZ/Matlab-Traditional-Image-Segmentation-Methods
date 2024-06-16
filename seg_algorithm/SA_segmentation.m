function mask = SA_segmentation(image , reference_image)  
max_iter = 100;
initial_temp = 10000;
cooling_rate = 0.99;
threshold_range = [0,255];

    best_threshold = 0;  
    best_dice = -inf;  % 初始化为负无穷大，因为我们想要找到最大值  
    current_temp = initial_temp;  
      
    % 模拟退火循环  
    for iter = 1:max_iter  
        % 随机选择一个新的阈值  
        new_threshold = threshold_range(1) + rand() * (threshold_range(2) - threshold_range(1));  
          
        % 使用新的阈值进行图像分割  
        new_mask = image > new_threshold;  
          
        % 计算Dice系数  
        new_dice = calc_dice(new_mask, reference_image);  % 假设reference_image是某个参考图像或标签  
          
        % 判断是否接受新的阈值  
        if new_dice > best_dice || rand() < exp((best_dice - new_dice) / current_temp)  
            best_threshold = new_threshold;  
            best_dice = new_dice;  
        end  
          
        % 冷却  
        current_temp = current_temp * cooling_rate;  
    end  
      
    % 使用最佳阈值进行图像分割并返回结果  
    mask = image > best_threshold;  
end  
  
