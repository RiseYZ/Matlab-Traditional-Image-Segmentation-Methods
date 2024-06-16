function BW = keepLargestIsland(BW)
    % ��ͼ��ת��Ϊ��ֵͼ��
    BW = im2bw(BW);

    % ʹ�� bwlabel ���������ͨ����
    [L, num] = bwlabel(BW);

    % ����ÿ���µ������
    area = zeros(1, num);
    for i = 1:num
        area(i) = sum(L(:) == i);
    end

    % �ҵ��������Ĺµ�
    [~, idx] = max(area);

    % �����������Ĺµ������������µ�
    BW = (L == idx);
end
