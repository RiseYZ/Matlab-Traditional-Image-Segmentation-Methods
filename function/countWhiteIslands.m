function count = countWhiteIslands(BW)
    % ��ͼ��ת��Ϊ��ֵͼ��
    BW = im2bw(BW);

    % ʹ�� bwlabel ���������ͨ����
    [L, num] = bwlabel(BW);

    % �����ɫ�µ�������
    count = num;
end
