clear all
clc
v = VideoReader('C:\Users\wenbin\Desktop\luwen_three\所用视频\suzie.avi');
% v = VideoReader('xylophone.mp4');
i=1;
load('suzie_split.mat')
% load('vipmen_图像.mat')
%%
width=v.Height;
length=v.Width;
f_len=v.FrameRate*v.Duration;
%% qianru
cwatermark_1 = imread('H:\新建文件夹\standard_test_images\fu.bmp');
%jiangwei
watermark=arnold(cwatermark_1,2,3,5);
w_length=1024;
%%
frame=cell(1,f_len);
while hasFrame(v)
    frame{i} = (readFrame(v));
    i=i+1;
end
old_frame=frame;%保存

%%
% index = 1;
for index = 1:2
    if index == 1
        [new_frame{index},x{index},y{index}] = videotuckertest02(frame,suzie_split(index),suzie_split(index+1),width,length,w_length,watermark);
    else
        [new_frame{index},x{index},y{index}] = videotuckertest02(frame,suzie_split(index)+1,suzie_split(index+1),width,length,w_length,watermark);
    end
%     index = index + 1;
end
%%
ex_v = VideoWriter('v_watermark','Uncompressed AVI');
open(ex_v);
index = 1;
for j = 1:suzie_split(index+1)-suzie_split(index)+1
    writeVideo(ex_v,new_frame{index}{j});
end
%%
for index = 2:2
    for j = 1:suzie_split(index+1)-suzie_split(index)
    writeVideo(ex_v,new_frame{index}{j});
    end
end
close(ex_v);
%%
e_v = VideoReader('v_watermark.avi');
i = 1;
nnew_frame=cell(1,f_len);
while hasFrame(e_v)
    nnew_frame{i} = readFrame(e_v);
    i=i+1;
end
% %%
ex_w = cell(1,2);
index = 1;
ex_w{index}=tiquvideowatermark_t(nnew_frame,length,width,x{index},y{index},suzie_split(index),suzie_split(index+1));
% %%
for index=2:2
    ex_w{index}=tiquvideowatermark_t(nnew_frame,length,width,x{index},y{index},suzie_split(index)+1,suzie_split(index+1));
end
% %%
new_ex_w = zeros(32,32);
for k = 1:2
    for i = 1:32
        for j = 1:32
            new_ex_w(i,j) = ex_w{k}(i,j) + new_ex_w(i,j);
        end
    end
end
% %% 投票
nnew_ex_w = zeros(32,32);
for i = 1:32
    for j = 1:32
        if new_ex_w(i,j) >= 1
            nnew_ex_w(i,j) = 1;
        else
            nnew_ex_w(i,j) = 0;
        end
    end
end


% %%
imshow(logical(nnew_ex_w))
disp('原水印图像与提取水印图像互相关系数')
NC=ncc(double(cwatermark_1),nnew_ex_w)
disp('原水印图像与提取水印图像的误码率')
BER=ber(double(cwatermark_1),nnew_ex_w)

%%
