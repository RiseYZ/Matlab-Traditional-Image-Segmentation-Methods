function mask = graphCut(img, bagX1, bagY1, bagX2, bagY2,iterCnt,preMethod)
    % �������:
    % img     - ����ͼ��
    % bagX1   - ����������߾���ͼ����߽��������
    % bagY1   - ���������ϱ߾���ͼ���ϱ߽��������
    % bagX2   - ���������ұ߾���ͼ���ұ߽��������
    % bagY2   - ���������±߾���ͼ���±߽��������
    % iterCnt - ��������
    % preMethod -ʹ��preMethonȷ����ʼ�߽�
    % ��ȡͼ��ߴ�
    [height, width, ~] = size(img);
    
    % ����������������ͳߴ�
    x = bagX1 + 1;
    y = bagY1 + 1;
    roiWidth = width - bagX1 - bagX2;
    roiHeight = height - bagY1 - bagY2;
    premask = 0;
    
    
    
    % �������������Ч��
    if roiWidth <= 0 || roiHeight <= 0
        error('Invalid rectangle dimensions. The specified rectangle is outside the image boundaries.');
    end
    L = superpixels(img,1000);
    % ��ʼ������
    ROI = false(height, width); % Initialize all to false
    ROI(y:y+roiHeight-1, x:x+roiWidth-1) = true; % ROI area to true
    switch preMethod
        case 'splitAndMerge' 
            minsize = 8;
            threshold = 10;
            premask = splitAndMerge(img,2,@predicate);
            
            %ִ�бտ���
            premask = closingOperation(premask,9);
            premask = openingOperation(premask,9);
            premask = openingOperation(premask,9);
            SE = strel('square', 9);
            
            % �Զ�ֵͼ��������Ͳ���
            BW_dilated = imdilate(premask, SE);
            ROI(premask == 0) = false; % �� BW ��ֵΪ 0 ��λ���� ROI ����Ϊ false
            ROI(premask ~= 0) = true;  % �� BW ��ֵ��Ϊ 0 ��λ���� ROI ����Ϊ true
        case 'improvedGMM1'
            premask = improvedGMM1(img, 2);
%             premask = keepLargestIsland(premask);
            SE = strel('square', 6);
            premask = openingOperation(premask,11);
            premask = openingOperation(premask,11);
            premask = openingOperation(premask,11);
            premask = openingOperation(premask,11);
            premask = closingOperation(premask,11);
            
            
            %���һȦ��ɫ����
            premask = addWhiteBorder(premask,1);
            if countWhiteIslands(premask) > 1
                premask = removeBorder(premask);
            end
            %���������ػ�ԭ
            premask = premask(2:end-1, 2:end-1);
            
            % �Զ�ֵͼ��������Ͳ���
            premask = imdilate(premask, SE);
            
            ROI(premask == 0) = false; % �� BW ��ֵΪ 0 ��λ���� ROI ����Ϊ false
            ROI(premask ~= 0) = true;  % �� BW ��ֵ��Ϊ 0 ��λ���� ROI ����Ϊ true
         case 'activecontour' %�ڶ���������Ҫ�����ʼ����ģ�ͣ��������Զ�ȷ����������Ҫ�ṩ��ʼ����
            tmpmask = zeros(size(img));
            tmpmask(25:end-25,25:end-25) = 1;
            premask = activecontour(img,tmpmask,100);
            SE = strel('square', 9);
           
            % �Զ�ֵͼ��������Ͳ���
            BW_dilated = imdilate(premask, SE);
        otherwise
            
    end
    
    
    % ʹ�� grabcut ����ͼ��ָ�
    BW = grabcut(img, L, ROI);
    for i = 2:iterCnt
        ROI(BW == 0) = false; % �� BW ��ֵΪ 0 ��λ���� ROI ����Ϊ false
        ROI(BW ~= 0) = true;  % �� BW ��ֵ��Ϊ 0 ��λ���� ROI ����Ϊ true
        BW = grabcut(img,L,ROI);
    end
    % ������������ͼ��ѡ�в���Ϊ 1��δѡ�в���Ϊ 0
%     mask = uint8(BW);
        mask = BW;
        
        
     %���Ч��һ���ע��
%      addWhiteBorder(mask,1);
%      if countWhiteIslands(mask) > 1
%            mask = removeBorder(mask);
%      end
%      mask = mask(2:end-1, 2:end-1);
     
     
end
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