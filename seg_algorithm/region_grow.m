function J = region_grow(I)  

[M,N]=size(I);
x1 = M/2;
y1 = N/2;
seed=I(x1,y1); %��ȡ�������ػҶ�ֵ

J=zeros(M,N);
J(x1,y1)=1;

count=1; %����������
threshold=0.15;
while count>0
    count=0;
    for i=1:M %��������ͼ��
    for j=1:N
        if J(i,j)==1 %���ڡ�ջ����
        if (i-1)>1&(i+1)<M&(j-1)>1&(j+1)<N %3*3������ͼ��Χ��
            for u=-1:1 %8-��������
            for v=-1:1
                if J(i+u,j+v)==0&abs(I(i+u,j+v)-seed)<=threshold
                    J(i+u,j+v)=1;
                    count=count+1;  %��¼�˴��������ĵ����
                end
            end
            end
        end
        end
    end
    end
end

end