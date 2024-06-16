function mask = watershed_seg(image)
    % 此为分割算法的案例
    % 对图像应用分水岭分割

   fd = double(image);
   h = fspecial('sobel');% 获得Sobel算子
   % 计算图像的梯度幅度，假设h同时包含了水平和垂直方向的Sobel算子   
   g = sqrt(imfilter(fd, h, 'replicate').^2 + imfilter(fd, h', 'replicate').^2);
   % 进行分水岭运算  
   l = watershed(g);
   % 找到分水岭变换结果中为0的位置（即分水岭的边界）  
   wr = l == 0;
   % 对图像g进行开闭运算以平滑图像  
   g2 = imclose(imopen(g, ones(3,3)), ones(3,3));
   % 对平滑后的图像进行分水岭运算  
   l2 = watershed(g2); 
   % 找到第二次分水岭变换结果中为0的位置（即分水岭的边界）  
   wr2 = l2 == 0;
   % 复制原始图像到f2  
   f2 = image;  
   % 将f2中wr2指定的位置设置为白色（255）  
   f2(wr2) = 255;
   % 将f2中所有非255的像素设置为0，以创建二值图像  
   f2_binary = f2 == 255;
   f2_binary_uint8 = im2uint8(f2_binary);
   b=im2bw(image, graythresh(image));
   BW=f2_binary_uint8&~b;
   BW = imdilate(BW,strel('diamond',5)); %# dilation
   BW = imfill(BW,'holes');             %# fill inside silhouette
   BW = imerode(BW,strel('diamond',5));  %# erode
   BW = bwperim(BW,8);                  %# get perimeter
   BW = imfill(BW,'holes');

   mask = BW;
end
