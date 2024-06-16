function BW = keepLargestIsland(BW)
    % 将图像转换为二值图像
    BW = im2bw(BW);

    % 使用 bwlabel 函数标记连通区域
    [L, num] = bwlabel(BW);

    % 计算每个孤岛的面积
    area = zeros(1, num);
    for i = 1:num
        area(i) = sum(L(:) == i);
    end

    % 找到最大面积的孤岛
    [~, idx] = max(area);

    % 保留最大面积的孤岛，消除其他孤岛
    BW = (L == idx);
end
