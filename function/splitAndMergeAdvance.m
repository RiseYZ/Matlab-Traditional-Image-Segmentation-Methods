function splitAndMergeAdvance()
    % 该函数仅用于测试，因为splitAndMerge算法运行时间较长，该函数会直接对splitAndMerge预测结果的文件进行操作

    % 给定标签文件夹路径
    splitAndMerge = './pred_result/splitAndMerge';  % 这里假设标签掩膜的文件夹路径与预测掩膜的文件夹路径相同

    % 获取文件夹中的文件列表
    pred_files = dir(fullfile(splitAndMerge, '*.bmp')); 
    method = 'improvedSplitAndMerge';

    % 遍历文件并计算指标
    for i = 1:length(pred_files)
        clc
        fprintf('Schedule: %d / %d\n', i, length(pred_files));
        % 读取掩膜
        pred_mask = imread(fullfile(splitAndMerge, pred_files(i).name));
        close_open_mask = closeThenOpen(pred_mask, 8, 6);
        open_close_open_mask = openingOperation(close_open_mask, 15);
        imwrite(open_close_open_mask, sprintf('./pred_result/improvedSplitAndMerge/%s', pred_files(i).name));
    end

    [dice, iou] = evaluate(sprintf('./pred_result/%s', method));

    fprintf('The evaluation of %s:\n', method);
    fprintf('Dice: %.4f\n', dice);
    fprintf('IOU: %.4f\n', iou);
end