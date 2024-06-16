function mask = SA_segmentation(image , reference_image)  
max_iter = 100;
initial_temp = 10000;
cooling_rate = 0.99;
threshold_range = [0,255];

    best_threshold = 0;  
    best_dice = -inf;  % ��ʼ��Ϊ���������Ϊ������Ҫ�ҵ����ֵ  
    current_temp = initial_temp;  
      
    % ģ���˻�ѭ��  
    for iter = 1:max_iter  
        % ���ѡ��һ���µ���ֵ  
        new_threshold = threshold_range(1) + rand() * (threshold_range(2) - threshold_range(1));  
          
        % ʹ���µ���ֵ����ͼ��ָ�  
        new_mask = image > new_threshold;  
          
        % ����Diceϵ��  
        new_dice = calc_dice(new_mask, reference_image);  % ����reference_image��ĳ���ο�ͼ����ǩ  
          
        % �ж��Ƿ�����µ���ֵ  
        if new_dice > best_dice || rand() < exp((best_dice - new_dice) / current_temp)  
            best_threshold = new_threshold;  
            best_dice = new_dice;  
        end  
          
        % ��ȴ  
        current_temp = current_temp * cooling_rate;  
    end  
      
    % ʹ�������ֵ����ͼ��ָ���ؽ��  
    mask = image > best_threshold;  
end  
  
