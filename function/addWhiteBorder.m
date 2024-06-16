function padded_img = addWhiteBorder(img, pad_size)
    img = img / 255;
    
    % ����һ�������ͼ�񣬳�ʼʱȫΪ��ɫ��255��
    padded_img = ones(size(img) + 2 * pad_size) * 255;
    
    % ��ԭͼ���Ƶ������ͼ������
    padded_img(pad_size + 1:end - pad_size, pad_size + 1:end - pad_size) = img * 255;
end
