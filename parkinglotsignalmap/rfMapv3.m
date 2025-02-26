%function [map] = rfMap( input )

fileID = fopen('WAKITAKI.txt');
format_file= '%f =%f %f %f %f %f %f %f %f %f';
C = textscan(fileID,format_file,'Delimiter',',','commentStyle','Time')
fclose(fileID);

A = cell2mat(C);
[row,col]=size(A);

for i=1:row
    for j=1:col-1
        B(i,j)=A(i,j+1);
    end
end
for k=100:row
    display (k)
    input = [B(k,3) B(k,2) B(k,1);B(k,6) B(k,5) B(k,4);B(k,9) B(k,8) B(k,7)]
    % 2-D DCT transform
    f = dct2(input);
    
    %Zero-padded matrix
    len = 200;
    filtered = zeros(len, len);
    filtered(1:3,1:3) = f;
    
    %Inverse 2-D DCT Transform
    map = (len/4)*idct2(filtered);
    
    %%Optional figure
    
    subplot(221)
    mesh(input)
    
    subplot(222)
    mesh(map,'FaceColor','interp')
    
    subplot(223)
    imshow(map/max(max(B)))
    colormap(jet)
    text(len/6,len/6,'1')
    text(len/2,len/6,'2')
    text(len*5/6,len/6,'3')
    text(len/6,len/2,'4')
    text(len/2,len/2,'5')
    text(len*5/6,len/2,'6')
    text(len/6,len*5/6,'7')
    text(len/2,len*5/6,'8')
    text(len*5/6,len*5/6,'9')
    pause(0.1)
end
%end