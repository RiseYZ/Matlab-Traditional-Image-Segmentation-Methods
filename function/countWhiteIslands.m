function count = countWhiteIslands(BW)
    % 将图像转换为二值图像
    BW = im2bw(BW);

    % 使用 bwlabel 函数标记连通区域
    [L, num] = bwlabel(BW);

    % 计算白色孤岛的数量
    count = num;
end
