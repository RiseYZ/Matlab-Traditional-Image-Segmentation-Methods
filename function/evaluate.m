function [avg_dice, avg_iou] = evaluate(pred_folder)
    % 
    %   该函数传入指定的预测掩膜的输出路径，返回预测结果（dice、iou）
    % 
    
    fprintf('Start evaluation......\n');

    % 给定标签文件夹路径
    true_folder = './data/label';  % 这里假设标签掩膜的文件夹路径与预测掩膜的文件夹路径相同

    % 获取文件夹中的文件列表
    pred_files = dir(fullfile(pred_folder, '*.bmp')); 
    true_files = dir(fullfile(true_folder, '*.bmp'));
    
    % 初始化结果数组
    num_files = min(length(pred_files), length(true_files));
    dice_values = zeros(num_files, 1);
    iou_values = zeros(num_files, 1);

    % 遍历文件并计算指标
    for i = 1:num_files
        % 读取预测结果和标签掩膜
        pred_mask = imread(fullfile(pred_folder, pred_files(i).name));
        true_mask = imread(fullfile(true_folder, true_files(i).name));

        % 计算 Dice 系数和 IoU 值
        [dice, iou] = compute_metrics(pred_mask, true_mask);

        % 存储结果
        dice_values(i) = dice;
        iou_values(i) = iou;
    end
    
    % 计算平均值
    avg_dice = mean(dice_values);
    avg_iou = mean(iou_values);
    fprintf('End evaluation......\n');
end

% 定义函数：计算 Dice 系数和 IoU 值
function [dice, iou] = compute_metrics(pred_mask, true_mask)
    % 将预测掩膜和标签掩膜转换为二进制数组
    pred_mask = logical(pred_mask);
    true_mask = logical(true_mask);

    % 计算交集和并集
    intersection = sum(pred_mask(:) & true_mask(:));
    union = sum(pred_mask(:) | true_mask(:));

    % 计算 Dice 系数
    dice = 2 * intersection / (sum(pred_mask(:)) + sum(true_mask(:)));

    % 计算 IoU 值
    iou = intersection / union;
end
