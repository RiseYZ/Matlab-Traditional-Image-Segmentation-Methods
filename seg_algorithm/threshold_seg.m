function mask = threshold_seg(image, threshold)
    % ��Ϊ�ָ��㷨�İ���
    % ��ͼ��Ӧ����ֵ�ָ�
    mask = (image < threshold * 255) * 255;
end