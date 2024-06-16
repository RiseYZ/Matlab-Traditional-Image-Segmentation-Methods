function mask = edgedet_seg(image)
    % 此为分割算法的案例
    % 对图像应用边缘检测

    % 使用Canny方法进行边缘检测,阈值设置为0.3
    BW = edge(image,'canny', 0.3);

    % 闭运算进行边界连接
    BW = imdilate(BW,strel('diamond',3)); %# dilation
    BW = imfill(BW,'holes');             %# fill inside silhouette
    BW = imerode(BW,strel('diamond',3));  %# erode
    BW = bwperim(BW,8);                  %# get perimeter
    BW = imfill(BW,'holes');
    mask = BW;

end
