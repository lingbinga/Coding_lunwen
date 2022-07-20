function ex_w=tiquvideowatermark_t(new_frame,length,width,x,y,k_1,k_2)
%%
% f_len = 18;
% frame=cell(1,f_len);
% for i=1:f_len
%     frame{i} = (readFrame(e_v));
% end
%%
for i = k_1:k_2
    b_frame{i}=new_frame{i}(:,:,3);
end
%%
for i = k_1:k_2
    m_frame(:,:,i)=b_frame{i};
end
I=double(m_frame);
[core, U1, U2, U3] = discreteHOSVD(I);
ex_core=tensor(core);
ex_U{1}=U1;
ex_U{2}=U2;
ex_U{3}=U3;
ex_Q_hat=ex_core;
for i=1:2
    ex_Q_hat=ttm(ex_Q_hat,ex_U{i},i);
end
ex_m_Q_hat=double(ex_Q_hat);
ex_m1_Q_hat=ex_m_Q_hat(:,:,2);
ex_s_Q_mat=mat2cell(ex_m1_Q_hat,ones(1,width/4)*4,ones(1,length/4)*4);
ex_cell_arrayU=cell(1024,1);
ex_cell_arrayS=cell(1024,1);
ex_cell_arrayV=cell(1024,1);

for k3=1:1024
   
            [ex_cell_arrayU{k3,1},ex_cell_arrayS{k3,1},ex_cell_arrayV{k3,1}] = svd(ex_s_Q_mat{x(k3),y(k3)});
           
end
p=1;
for i=1:32
    for j=1:32
        if abs(ex_cell_arrayU{p,1}(2,1))-abs(ex_cell_arrayU{p,1}(3,1))<=0
            ex_wa(i,j)=1;
        else
            ex_wa(i,j)=0;
        end
        p=p+1;
    end
end

%% hebing
ex_w=rearnold(ex_wa,2,3,5);
end