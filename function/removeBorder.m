function img = removeBorder(img)
    % 获取图像的大小
    [rows, cols] = size(img);
    
    % 遍历图像的边界像素
    for i = 1:rows
        for j = 1:cols
            % 如果是边界像素且像素值不为0，则进行递归处理
            if (i == 1 || i == rows || j == 1 || j == cols) && img(i, j) ~= 0
                img = recursiveRemove(img, i, j);
            end
        end
    end
end

function img = recursiveRemove(img, row, col)
    % 将当前像素置为0
    img(row, col) = 0;
    
    % 定义相邻像素的偏移量
    offsets = [-1, 0; 1, 0; 0, -1; 0, 1];
    
    % 对当前像素的相邻像素进行递归处理
    for k = 1:size(offsets, 1)
        newRow = row + offsets(k, 1);
        newCol = col + offsets(k, 2);
        
        % 检查相邻像素是否在图像范围内且像素值不为0
        if newRow >= 1 && newRow <= size(img, 1) && newCol >= 1 && newCol <= size(img, 2) && img(newRow, newCol) ~= 0
            img = recursiveRemove(img, newRow, newCol);
        end
    end
end