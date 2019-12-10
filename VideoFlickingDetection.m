clc
clear all
close all
v = VideoReader('flicker.mp4');
h=v.Height;
w=v.Width;
n=30;
s=zeros(n,w);
% Part-1
% Calulating luminance between neighboring pixels and summing it for each
% columns in a frame
for q=1:n
    f=v.read(q);
    f=0.299 * f(:,:,1) + 0.587 * f(:,:,2) + 0.114 * f(:,:,3);
    for a=1:w
        for k=2:h
            d=difference(f,a,k);
            s(q,a)=s(q,a)+d;
        end
    end
end
% Part-2
% Performing Motion Estimation 
t=zeros(n,w,11);
for q=2:n  
    for u=6:w-5
        for c=-5:5
        t(q,u,c+6)=t(q,u,c+6)+abs(s(q,u)-s(q-1,u+c)); 
        end
    end
end
t(1,:,:)=t(2,:,:);
% Part-3
% performing a motion compensation to a current frame data
p=zeros(n,w);
v = VideoReader('flicker.mp4');
for q=1:n 
    f=v.read(q);
    f=0.299 * f(:,:,1) + 0.587 * f(:,:,2) + 0.114 * f(:,:,3);
    for a=1:w
        for k=1:h
            p(q,a)=p(q,a)+double(f(k,a));
        end
    end 
end
% Part-4
% difference between a previous frame data and the compensated current frame 
% data
e=zeros(n,w);
for q=2:n
    for u=6:w
        [a,b]=min(t(q,u,:));    
        e(q,u)=p(q,u)-p(q-1,u+b-6);
    end
end 
e(1,:,:)=e(2,:,:);
% Part-5
% Displaying Output
for i=1:n
    subplot(1,2,1);
    f=v.read(i);
    image(f);
    k=strcat('Frame',num2str(i));
    title(k);
    axis off;
    axis image;
    subplot(1,2,2);
    image(f);
    y=e(i,:)<0;
    if sum(y)>100
        title('Flickering Detected');
    else
        title('No Flickering Detected');
    end
    axis off;
    axis image;
    drawnow
end
