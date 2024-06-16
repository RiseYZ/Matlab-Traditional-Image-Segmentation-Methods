function binaryMask = unetpred2mask(pred)
    % 设置阈值
    threshold = 0.5;

    % 获取预测结果的大小
    [height, width, ~] = size(pred);

    % 初始化二值掩膜
    binaryMask = zeros(height, width);

    % 遍历每个像素位置
    for i = 1:height
        for j = 1:width
            % 如果目标类别的概率大于阈值，则将掩膜对应位置设为 1
            if pred(i, j, 1) > threshold
                binaryMask(i, j) = 1;
            else
                binaryMask(i, j) = 0;
            end
        end
    end
end
