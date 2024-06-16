function img = removeBorder(img)
    % ��ȡͼ��Ĵ�С
    [rows, cols] = size(img);
    
    % ����ͼ��ı߽�����
    for i = 1:rows
        for j = 1:cols
            % ����Ǳ߽�����������ֵ��Ϊ0������еݹ鴦��
            if (i == 1 || i == rows || j == 1 || j == cols) && img(i, j) ~= 0
                img = recursiveRemove(img, i, j);
            end
        end
    end
end

function img = recursiveRemove(img, row, col)
    % ����ǰ������Ϊ0
    img(row, col) = 0;
    
    % �����������ص�ƫ����
    offsets = [-1, 0; 1, 0; 0, -1; 0, 1];
    
    % �Ե�ǰ���ص��������ؽ��еݹ鴦��
    for k = 1:size(offsets, 1)
        newRow = row + offsets(k, 1);
        newCol = col + offsets(k, 2);
        
        % ������������Ƿ���ͼ��Χ��������ֵ��Ϊ0
        if newRow >= 1 && newRow <= size(img, 1) && newCol >= 1 && newCol <= size(img, 2) && img(newRow, newCol) ~= 0
            img = recursiveRemove(img, newRow, newCol);
        end
    end
end