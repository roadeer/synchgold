function y=average_vol(data_quote_minute,threshold)
data_size=size(data_quote_minute);
data_vol=data_quote_minute(:,7);
data_moderate=[];
data_vec = zeros(1,9);
data_index=1;
for i=1:data_size(1)
     
    if(data_vec(7)==0)
        data_vec(1:7)=data_quote_minute(i,:);
        data_vec(1)=data_index;
    else
        if(data_vec(7)<threshold)
            data_vec(7)= data_vec(7)+data_quote_minute(i,7);
            data_vec(6) = data_quote_minute(i,6);
            data_vec(5) = min(data_quote_minute(i,5),data_vec(5));
            data_vec(4) = max(data_quote_minute(i,4),data_vec(4));
            data_vec(8) = data_vec(8)+1;
        else if(data_vec(7)>=threshold)
                data_moderate=[data_moderate;data_vec];
                data_vec(1:7) = data_quote_minute(i,:);
                data_vec(8)=0;
                data_index = data_index+1;
            end
        end
    end
end
y=data_moderate;

%sequence should have [date,open,close,high,low,total_turnover,vol]