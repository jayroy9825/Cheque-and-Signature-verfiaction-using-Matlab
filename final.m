clc;
clear all;

%Input Image of Cheque
I=imread('Axis.jpg');
% INput Image of Reference Signature
I2=imread('sir1.jpg');

ChequeNo(I)
Sign(I,I2)


function ChequeNo(I)
    
I3=rgb2gray(I);
I3=im2double(I3);
I3=im2bw(I,0.9);
figure,imshow(I3);

[rows,cols]=size(I3);

% finding location of white space
xstart=cols;
xend=1;
ystart=rows;
yend=1;
for r=1:rows
    for c=1:cols
        if((I3(r,c)==1))
            if (r<ystart)
                ystart=r;
            end
            if((r>yend))
                yend=r; 
            end
            if (c<xstart)
                xstart=c;
            end
            if (c>xend)
                xend=c;
            end     
       end  
    end
end
        
%Crop the image of cheque & store it in another martix       
for i=ystart:yend
    for j=xstart:xend
        im((i-ystart+1),(j-xstart+1))=I3(i,j);
    end
end
              
%resize the new image 
I3=imresize(im,[500,1000]);
[x y]=size(I3)
figure,imshow(I3);

%crop the row which contain cheque number information
im=imcrop(I3,[1,440,1000,40]);

%Find Digits
im=imfilter(im,[1,1]);
blackPixel=1000;
[r c]=size(im);
for m=1:r
    for n=1:c
        if((im(m,n)==0))
            if (n<blackPixel && n>100)
                blackPixel=n;
            end
        end
    end
end
im=imcrop(im,[blackPixel,1,1000-blackPixel,40]);

%Crop the cheque number
im=imcrop(im,[15,1,110,40]);
figure,imshow(im);

%Do Pre-processing on Cheque Number Image
[r,c]=size(im)
figure,imshow(im);

[r,c]=size(im)
blackFound=0;
right=c;
    for i=1:6
        %Finding First Comma
        for j=1:r
            for k=1:c
                if(im(j,k)==0)
                    if(k<right)
                        right=k;
                    end
                end
            end
        end
        
        finish=right;
        pureWhiteFound=0;
        %finding the next pure white column
        
        while(pureWhiteFound==0 && finish~=c+1)
            row=1;
            blackFound=0;
            while(blackFound==0 && row~=(r+1))
                %If a black pixel is found in the column step to the next coloumn
                if(im(row,finish)==0)
                    blackFound=1;
                else
                    row=row+1;
                end
            end
            %If non black pixel is found in the curren column
            if(blackFound==0)
                pureWhiteFound=1;
            else
                finish=finish+1;
            end
        end
        I=imcrop(im,[right,1,finish-right-1,r]);
        %Removing Extra Space
        ystart=r;
        yend=1;
        [p q]=size(I);
        for m=1:p
            for n=1:q
                if((I(m,n)==0))
                    if (m<ystart)
                        ystart=m;
                    end
                    if((m>yend))
                        yend=m; 
                    end
               end  
            end
        end
        %Crop Digits of Cheque Number
        number(:,:,i)=imresize(imcrop(im,[right,ystart,finish-right-1,yend-ystart]),[40,20]); 
        %Image Contain Digits which are not Cropped yet.
        im=imcrop(im,[finish,1,c,r]);     
        [r,c]=size(im);
        right=c;
    end
    for i=1:6
        figure,imshow(number(:,:,i));
        
    end
    
   
%Imorting Sample Templates
 sample(:,:,1)=im2bw(imresize(rgb2gray(imread('one.jpg')),[128 128]));
 sample(:,:,2)=im2bw(imresize(rgb2gray(imread('two.jpg')),[128 128]));
 sample(:,:,3)=im2bw(imresize(rgb2gray(imread('three.jpg')),[128 128]));
 sample(:,:,4)=im2bw(imresize(rgb2gray(imread('four.jpg')),[128 128]));
 sample(:,:,5)=im2bw(imresize(rgb2gray(imread('five.jpg')),[128 128]));
 sample(:,:,6)=im2bw(imresize(rgb2gray(imread('six.jpg')),[128 128]));
 sample(:,:,7)=im2bw(imresize(rgb2gray(imread('seven.jpg')),[128 128]));
 sample(:,:,8)=im2bw(imresize(rgb2gray(imread('eight.jpg')),[128 128]));
 sample(:,:,9)=im2bw(imresize(rgb2gray(imread('nine.jpg')),[128 128]));
 sample(:,:,10)=im2bw(imresize(rgb2gray(imread('zero.jpg')),[128 128]));
 
%Resizing & pre-processing on Sample Image 
for i=1:10
    xstart=128;
    xend=1;
    ystart=128;
    yend=1;
    for r=1:128
        for c=1:128
            if((sample(r,c,i)==0))
                if (r<ystart)
                    ystart=r;
                end
                if((r>yend))
                    yend=r; 
                end
                if (c<xstart)
                    xstart=c;
                end
                if (c>xend)
                    xend=c;
                end     
           end  
        end
    end
     samplecut(:,:,i)=imresize(imcrop(sample(:,:,i),[xstart,ystart,xend-xstart,yend-ystart]),[40 20]);
end

%Comapring Digits with sample Image
for i=1:6
    percentage=0;
    picsize=40*20;
    for j=1:10
        matchingPixels=0;
        for m=1:40
            for n=1:20
                if(number(m,n,i)==samplecut(m,n,j))
                    matchingPixels=matchingPixels+1;
                end
            end
        end
        matchingPercentage=(matchingPixels/picsize)*100;
        if(matchingPercentage>percentage)
            percentage=matchingPercentage;
            if(j==1)
                num(i)=1;
            elseif(j==2)
                num(i)=2;
            elseif(j==3)
                num(i)=3;
            elseif(j==4)
                num(i)=4;
            elseif(j==5)
                num(i)=5;
            elseif(j==6)
                num(i)=6;
            elseif(j==7)
                num(i)=7;
            elseif(j==8)
                num(i)=8;
             elseif(j==9)
                num(i)=9;
            else
                num(i)=0;
                
            end
                    
        end
       
    end   
end

%Cheque number
chequeNumber=num(1)*10^5+num(2)*10^4+num(3)*10^3+num(4)*10^2+num(5)*10+num(6);

%formatting the cheque number in case of zeros at the begining
    str=int2str(chequeNumber);
    l=length(str);
    for i=l:5
        str=strcat('0',str);
    end
    ChequeNumber=str;
    %Output
    fprintf("Cheque Number For Given Image is : %s\n\n",ChequeNumber);
    
end



function Sign(I,I2)
    im=imresize(I,[500,1000]);
    [x y]=size(im);
    I1=im(300:370,1850:1950);
    figure,imshow(I1);
    I1=I2;
    I1(:,:,4)=[];
    I2(:,:,4)=[];
    I1=rgb2gray(I1);
    I2=rgb2gray(I2); 
    
    subplot(2,1,1)
    imshow(I1)
    figure;
    subplot(2,1,2);
    imshow(I2)
    
    figure;
    points1=detectHarrisFeatures(I1);plot(points1);
    figure;
    points2=detectHarrisFeatures(I2);plot(points2);
    
    [features1,valid_points1]=extractFeatures(I1,points1);
    [features2,valid_points2]=extractFeatures(I2,points2);
    
    indexPairs=matchFeatures(features1,features2);
    
    matchedPoints1=valid_points1(indexPairs(:,1),:);
    matchedPoints2=valid_points2(indexPairs(:,2),:);
    
    figure;
    showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    
    u=matchedPoints2.Metric-matchedPoints1.Metric;
    
    if abs(u)<=0.04 
        disp(" Signature Matched ");
    else
        disp(" Signature Not Matched ");
    end
end